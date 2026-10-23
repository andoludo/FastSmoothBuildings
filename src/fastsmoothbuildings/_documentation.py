"""What the classes of the library say about themselves: their comment, parameters and ``Documentation`` annotation.

The documentation site renders a page per class from it, and the tests check that every class is documented.
"""

from __future__ import annotations

import re
from collections.abc import Iterator, Sequence
from dataclasses import dataclass
from pathlib import Path

from fastsmoothbuildings._paths import LIBRARY
from fastsmoothbuildings.bundle import code_mask, package_order, read_class

PREFIXES = r"(?:(?:partial|encapsulated|replaceable|final|expandable|pure|impure|operator)\s+)*"
DECLARATION = re.compile(
    rf"^(?P<prefixes>{PREFIXES})(?P<kind>package|model|block|function|connector|record|type|class)\s+"
    r"(?P<name>[A-Za-z_]\w*)"
)
SECTION = re.compile(r"\b(?:initial\s+)?(?:equation|algorithm)\b")
VARIABILITY = re.compile(
    r"^(?:(?:final|inner|outer|replaceable|redeclare|input|output|flow|stream|discrete)\s+)*"
    r"(?P<variability>parameter|constant)\s+"
)
STRING = re.compile(r'"((?:[^"\\]|\\.)*)"', re.DOTALL)


@dataclass(frozen=True)
class Parameter:
    name: str
    type: str
    unit: str
    default: str
    comment: str


@dataclass(frozen=True)
class ClassDocumentation:
    """The documentation of a class stored in its own file."""

    path: Path
    name: str  # qualified, FastSmoothBuildings.Envelope.Window
    kind: str
    partial: bool
    comment: str
    extends: tuple[str, ...]
    parameters: tuple[Parameter, ...]
    info: str | None
    revisions: str | None

    @property
    def is_package(self) -> bool:
        return self.path.name == "package.mo"


def unescape(text: str) -> str:
    """The value of a Modelica string literal from its text between the quotes."""
    return re.sub(r"\\(.)", lambda match: {"n": "\n", "t": "\t"}.get(match[1], match[1]), text)


def _string_at(text: str, start: int) -> tuple[str, int] | None:
    """The string literal starting at ``start`` (after whitespace), and the index after it."""
    match = STRING.match(text, start + len(text[start:]) - len(text[start:].lstrip()))
    return (unescape(match[1]), match.end()) if match else None


def _closing(text: str, mask: Sequence[bool], start: int) -> int:
    """The index after the bracket closing the one at ``start``."""
    opening = text[start]
    closing = {"(": ")", "[": "]", "{": "}"}[opening]
    depth, index = 0, start
    while index < len(text):
        if mask[index]:
            depth += (text[index] == opening) - (text[index] == closing)
            if depth == 0:
                return index + 1
        index += 1
    return index


def _statements(text: str, mask: Sequence[bool], start: int, end: int) -> Iterator[tuple[int, int]]:
    """The spans of the statements between ``start`` and ``end`` (split at the semicolons of the code)."""
    depth, first = 0, start
    for index in range(start, end):
        if not mask[index]:
            continue
        character = text[index]
        if character in "([{":
            depth += 1
        elif character in ")]}":
            depth -= 1
        elif character == ";" and depth == 0:
            yield first, index
            first = index + 1


def _value_end(text: str, mask: Sequence[bool], index: int, end: int) -> int:
    """The index where the value of a binding starting at ``index`` ends: its comment or annotation, or ``end``."""
    depth = 0
    while index < end and not (depth == 0 and (not mask[index] or re.match(r"annotation\b", text[index:end]))):
        if mask[index]:
            depth += (text[index] in "([{") - (text[index] in ")]}")
        index += 1
    return index


def _parameter(text: str, mask: Sequence[bool], start: int, end: int) -> Parameter | None:
    """The public parameter declared by the statement ``text[start:end]``, if it declares one."""
    statement = text[start:end].lstrip()
    match = VARIABILITY.match(statement)
    type_ = re.compile(r"[\w.]+").match(text, end - len(statement) + match.end()) if match else None
    if match is None or match["variability"] != "parameter" or type_ is None:
        return None
    index = _closing(text, mask, type_.end()) if text[type_.end()] == "(" else type_.end()
    modifications = text[type_.end() : index]
    name = re.compile(r"\s*([A-Za-z_]\w*)").match(text, index)
    if name is None:
        return None
    index = name.end()
    for bracket in "[(":
        while index < end and text[index] == bracket:
            following = _closing(text, mask, index)
            modifications += text[index:following]
            index = following
    unit = re.search(r'\bunit\s*=\s*"([^"]*)"', modifications)
    default = ""
    if equal := re.match(r"\s*=", text[index:end]):
        value_start = index + equal.end()
        index = _value_end(text, mask, value_start, end)
        default = " ".join(text[value_start:index].split())
    string = _string_at(text, index) if text[index:end].strip().startswith('"') else None
    comment = " ".join(string[0].split()) if string else ""
    return Parameter(name[1], type_[0], unit[1] if unit else "", default, comment)


def _annotation_string(text: str, mask: Sequence[bool], key: str) -> str | None:
    """The string given to ``key`` in the ``Documentation(...)`` annotation of the class: the last one of the text,
    since the annotation of a class follows its elements and the classes nested in it."""
    found = [match for match in re.finditer(r"\bDocumentation\s*\(", text) if mask[match.start()]]
    if not found:
        return None
    position = found[-1].start()
    end = _closing(text, mask, found[-1].end() - 1)
    for entry in re.finditer(rf"\b{key}\s*=", text[position:end]):
        if mask[position + entry.start()]:
            string = _string_at(text, position + entry.end())
            return string[0] if string else None
    return None


def _elements(text: str, mask: Sequence[bool], start: int, end: int) -> tuple[list[str], list[Parameter]]:
    """The classes extended and the public parameters declared between ``start`` and ``end``, the elements of the
    classes nested there left out."""
    extends: list[str] = []
    parameters: list[Parameter] = []
    public = True
    nested = 0  # classes declared inside the body: their elements are theirs
    for first, last in _statements(text, mask, start, end):
        begin = first
        code = (character if keep else " " for character, keep in zip(text[begin:last], mask[begin:last], strict=True))
        statement = re.sub(r"\s+", " ", "".join(code)).strip()
        for keyword in ("public", "protected"):
            if statement.startswith(keyword + " ") or statement == keyword:
                public = keyword == "public"
                statement = statement.removeprefix(keyword).strip()
                begin = text.index(keyword, begin) + len(keyword)
        declared = DECLARATION.match(statement)
        if declared and not re.match(r"\s*=", statement[declared.end() :]):
            nested += 1  # a class with a body, up to its end; a short class definition has none
        if statement.startswith("end "):
            nested = max(nested - 1, 0)
            continue
        if nested or not public:
            continue
        if statement.startswith("extends "):
            extends.append(statement.split()[1].split("(")[0])
        elif parameter := _parameter(text, mask, begin, last):
            parameters.append(parameter)
    return extends, parameters


def class_documentation(path: Path, library: Path = LIBRARY) -> ClassDocumentation:
    """The documentation of the class stored in ``path`` (a ``.mo`` file of the library)."""
    text = "\n".join(read_class(path))
    mask = code_mask(text)
    declaration = DECLARATION.match(text)
    if declaration is None:
        raise ValueError(f"{path} holds no class")
    parts = path.relative_to(library.parent).with_suffix("").parts
    name = ".".join(parts[:-1] if path.name == "package.mo" else parts)
    after_name = declaration.end()
    short = re.compile(r"\s*=\s*(?P<base>[\w.]+)\s*").match(text, after_name)
    if short:  # a short class definition, record Name = Base(modifications) "comment"
        after_name = short.end()
        if text[after_name : after_name + 1] == "(":
            after_name = _closing(text, mask, after_name)
    comment = _string_at(text, after_name)
    body_start = comment[1] if comment else after_name
    sections = [match.start() for match in SECTION.finditer(text) if mask[match.start()]]
    body_end = min(sections, default=len(text))
    extends, parameters = _elements(text, mask, body_start, body_end)
    return ClassDocumentation(
        path=path,
        name=name,
        kind=declaration["kind"],
        partial="partial" in declaration["prefixes"],
        comment=" ".join(comment[0].split()) if comment else "",
        extends=(short["base"], *extends) if short else tuple(extends),
        parameters=tuple(parameters),
        info=_annotation_string(text, mask, "info"),
        revisions=_annotation_string(text, mask, "revisions"),
    )


def class_files(library: Path = LIBRARY) -> Iterator[Path]:
    """The files of the classes of the library, in the order of the ``package.order`` files."""

    def walk(package: Path) -> Iterator[Path]:
        yield package / "package.mo"
        for name in package_order(package):
            if (package / name / "package.mo").is_file():
                yield from walk(package / name)
            elif (package / f"{name}.mo").is_file():
                yield package / f"{name}.mo"

    yield from walk(library)
