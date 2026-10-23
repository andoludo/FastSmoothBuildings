"""Single-file text of a Modelica library stored in the directory layout of the Modelica specification (13.4)."""

from __future__ import annotations

import re
from collections.abc import Sequence
from pathlib import Path

from fastsmoothbuildings._paths import LIBRARY

INDENT = "  "
WITHIN = re.compile(r"\A\s*within\b[^;]*;[ \t]*\n")
DOCUMENTATION = re.compile(r"\bDocumentation\s*\(")
CLASS_ANNOTATION = re.compile(rf"^{INDENT}annotation\b")


def read_class(path: Path) -> list[str]:
    """Lines of a class file without its ``within`` clause."""
    return WITHIN.sub("", path.read_text(encoding="utf-8"), count=1).rstrip("\n").split("\n")


def package_order(package: Path) -> list[str]:
    """Names listed in ``package.order``, in their order."""
    order = package / "package.order"
    return order.read_text(encoding="utf-8").split() if order.is_file() else []


def _scan(line: str, in_string: bool, in_comment: bool) -> tuple[bool, bool]:
    """Whether the end of ``line`` is inside a string and inside a block comment."""
    index = 0
    while index < len(line):
        if in_string:
            if line[index] == "\\":
                index += 2
                continue
            in_string = line[index] != '"'
        elif in_comment:
            in_comment = not line.startswith("*/", index)
            index += 0 if in_comment else 1
        elif line.startswith("//", index):
            break
        else:
            in_string = line[index] == '"'
            in_comment = line.startswith("/*", index)
            index += 1 if in_comment else 0
        index += 1
    return in_string, in_comment


def code_starts(lines: Sequence[str]) -> list[bool]:
    """Whether each line starts outside a string and outside a block comment."""
    starts: list[bool] = []
    in_string = in_comment = False
    for line in lines:
        starts.append(not (in_string or in_comment))
        in_string, in_comment = _scan(line, in_string, in_comment)
    return starts


def code_mask(text: str) -> list[bool]:
    """Whether each character of ``text`` is code: outside strings and comments."""
    mask = [True] * len(text)
    index, in_string = 0, False
    while index < len(text):
        if in_string:
            mask[index] = False
            if text[index] == "\\":
                mask[index + 1 : index + 2] = [False] * len(mask[index + 1 : index + 2])
                index += 2
                continue
            in_string = text[index] != '"'
        elif text[index] == '"':
            mask[index], in_string = False, True
        elif text.startswith("//", index) or text.startswith("/*", index):
            end = text.find("\n" if text[index + 1] == "/" else "*/", index + 2)
            end = len(text) if end < 0 else end + (0 if text[index + 1] == "/" else 2)
            mask[index:end] = [False] * (end - index)
            index = end
            continue
        index += 1
    return mask


def _class_annotation(body: Sequence[str]) -> int:
    """Index of the line that opens the annotation of the class in ``body`` (its declaration and elements),
    ``len(body)`` without one: the classes stored in files go before it, an annotation ends a class."""
    starts = code_starts(body)
    found = [number for number, line in enumerate(body) if starts[number] and CLASS_ANNOTATION.match(line)]
    return found[-1] if found else len(body)


def _indented(lines: Sequence[str], depth: int) -> list[str]:
    return [INDENT * depth + line if line else line for line in lines]


def _package_lines(package: Path, depth: int) -> list[str]:
    *body, end = read_class(package / "package.mo")
    annotation = _class_annotation(body)
    lines = _indented(body[:annotation], depth)
    # a blank line separates the classes, except the first one from a declaration without elements
    separator = [""] if any(line.rstrip().endswith(";") for line in body[:annotation]) else []
    for name in package_order(package):
        if (package / name / "package.mo").is_file():
            child = _package_lines(package / name, depth + 1)
        elif (package / f"{name}.mo").is_file():
            child = _indented(read_class(package / f"{name}.mo"), depth + 1)
        else:
            continue  # a constant or a short class of package.mo
        lines += [*separator, *child]
        separator = [""]
    return [*lines, *_indented([*body[annotation:], end], depth)]


def bundle(library: Path | None = None, *, documentation: bool = True) -> str:
    """The library at ``library`` (the folder holding its ``package.mo``, FastSmoothBuildings by default) as the
    text of one file; ``documentation=False`` leaves out the ``Documentation`` annotations."""
    text = "\n".join(_package_lines(library or LIBRARY, 0)) + "\n"
    return text if documentation else strip_documentation(text)


def strip_documentation(text: str) -> str:
    """``text`` without its ``Documentation(...)`` annotations (with the comma that joins one to the other
    elements of its ``annotation``)."""
    mask = code_mask(text)
    pieces: list[str] = []
    position = 0
    for match in DOCUMENTATION.finditer(text):
        if match.start() < position or not mask[match.start()]:
            continue
        start, end = match.start(), _closing_parenthesis(text, match.end(), mask)
        before = text[position:start].rstrip()
        after = text[end:].lstrip()
        if before.endswith(","):
            before = before[:-1]
        elif after.startswith(","):
            end = len(text) - len(after) + 1
        pieces.append(before)
        position = end
    pieces.append(text[position:])
    return "".join(pieces)


def _closing_parenthesis(text: str, start: int, mask: Sequence[bool]) -> int:
    """Index just after the parenthesis that closes the one opened before ``start``, strings skipped."""
    depth, index = 1, start
    while depth:
        if mask[index]:
            depth += {"(": 1, ")": -1}.get(text[index], 0)
        index += 1
    return index
