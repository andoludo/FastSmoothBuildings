"""Split trano's single-file ``FastModel.mo`` into the FastSmoothBuildings library in the directory layout.

Every package that holds a model, block, function, connector or record (directly or below) becomes a folder with
``package.mo`` and ``package.order``; every other class of such a package becomes a file ``<name>.mo``; constants
and short classes (``connector RealInput = input Real``) stay in ``package.mo``. A package of constants only
(``Types``, ``Icons``) stays one file, as in Buildings.

    python scripts/migration/split_library.py FastModel.mo .

The script checks that the bundle of the folder (``fastsmoothbuildings.bundle.bundle``) gives back the renamed
source character for character.
"""

from __future__ import annotations

import argparse
import re
import shutil
import sys
from collections.abc import Iterator, Sequence
from dataclasses import dataclass, field
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "src"))

from fastsmoothbuildings.bundle import bundle, code_starts

OLD, NEW = "FastModel", "FastSmoothBuildings"
DECLARATION = re.compile(
    r"^(?P<indent> *)(?:(?:partial|encapsulated|replaceable|final|expandable|pure|impure|operator)\s+)*"
    r"(?P<kind>package|model|block|function|connector|record|type|class)\s+(?P<name>[A-Za-z_]\w*)(?P<rest>.*)$"
)
CONSTANT = re.compile(r"^ *constant\s+[\w.]+\s+(?P<name>[A-Za-z_]\w*)")
SPLIT = frozenset({"model", "block", "function", "connector", "record", "class", "type"})


@dataclass
class ModelicaClass:
    """A class of the source with the lines it spans (``last`` is its ``end`` line)."""

    name: str
    kind: str
    indent: int
    first: int
    last: int = -1
    short: bool = False
    elements: list[tuple[int, str]] = field(default_factory=list)  # (line, name) of constants and short classes
    children: list[ModelicaClass] = field(default_factory=list)

    @property
    def is_folder(self) -> bool:
        """A package holding (directly or below) a class that is not a package."""
        return self.kind == "package" and any(
            (child.kind in SPLIT and not child.short) or child.is_folder for child in self.children
        )

    def order(self) -> list[str]:
        """Names of the elements of the package in the order of the source."""
        named = [(child.first, child.name) for child in self.children] + self.elements
        return [name for _, name in sorted(named)]


def parse(lines: Sequence[str]) -> ModelicaClass:
    """The class tree of a single-file package."""
    starts = code_starts(lines)
    stack: list[ModelicaClass] = []
    root: ModelicaClass | None = None
    for number, line in enumerate(lines):
        if not starts[number]:
            continue
        if stack and line == " " * stack[-1].indent + f"end {stack[-1].name};":
            stack.pop().last = number
            continue
        depth = stack[-1].indent + 2 if stack else 0
        if stack and (constant := CONSTANT.match(line)) and line.startswith(" " * depth + "constant"):
            stack[-1].elements.append((number, constant["name"]))
            continue
        declaration = DECLARATION.match(line)
        if declaration is None or len(declaration["indent"]) != depth:
            continue
        current = ModelicaClass(declaration["name"], declaration["kind"], depth, number)
        if declaration["rest"].lstrip().startswith("="):
            current.short, current.last = True, number
            stack[-1].elements.append((number, current.name))
            continue
        if stack:
            stack[-1].children.append(current)
        else:
            root = current
        stack.append(current)
    if root is None or stack or root.last < 0:
        raise ValueError("unbalanced class declarations")
    return root


def _dedented(lines: Sequence[str], indent: int) -> list[str]:
    prefix = " " * indent
    if any(line and not line.startswith(prefix) for line in lines):
        raise ValueError(f"a line is indented less than its class ({indent} spaces)")
    return [line[indent:] for line in lines]


def _without_children(lines: Sequence[str], package: ModelicaClass) -> list[str]:
    """Lines of the package without its classes stored in their own file or folder (and their blank line)."""
    removed: set[int] = set()
    for child in package.children:
        removed.update(range(child.first, child.last + 1))
        if child.first > 0 and not lines[child.first - 1].strip():
            removed.add(child.first - 1)
    span = range(package.first, package.last + 1)
    return [lines[number] for number in span if number not in removed]


def write(lines: Sequence[str], current: ModelicaClass, folder: Path, within: str) -> Iterator[Path]:
    """Write ``current`` below ``folder``; yield the files written."""
    header = f"within {within};" if within else "within ;"
    if current.is_folder:
        package = folder / current.name
        package.mkdir()
        body = _dedented(_without_children(lines, current), current.indent)
        (package / "package.mo").write_text("\n".join([header, *body]) + "\n", encoding="utf-8")
        (package / "package.order").write_text("\n".join(current.order()) + "\n", encoding="utf-8")
        yield package / "package.mo"
        path = f"{within}.{current.name}" if within else current.name
        for child in current.children:
            yield from write(lines, child, package, path)
    else:
        body = _dedented(lines[current.first : current.last + 1], current.indent)
        target = folder / f"{current.name}.mo"
        target.write_text("\n".join([header, *body]) + "\n", encoding="utf-8")
        yield target


def renamed(text: str) -> str:
    """The source with the library and its trano configurations renamed."""
    return re.sub(rf"\b{OLD}(MPC)?\b", lambda match: NEW + (match[1] or ""), text)


def main(arguments: Sequence[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("source", type=Path, help="trano/library/FastModel.mo")
    parser.add_argument("target", type=Path, help="folder that receives FastSmoothBuildings/")
    parsed = parser.parse_args(arguments)

    text = renamed(parsed.source.read_text(encoding="utf-8"))
    lines = text.splitlines()
    root = parse(lines)
    library = parsed.target / root.name
    if library.exists():
        shutil.rmtree(library)
    written = list(write(lines, root, parsed.target, ""))
    if bundle(library) != text:
        raise SystemExit("the bundle of the folder differs from the source")
    print(f"{len(written)} files in {library}; the bundle gives back the source")


if __name__ == "__main__":
    main()
