"""The library keeps the layout of the Modelica specification, depends on nothing and exercises every model."""

from __future__ import annotations

import importlib.metadata
import re
from functools import cache
from pathlib import Path

import pytest

import fastsmoothbuildings
from fastsmoothbuildings import LIBRARY, NAME
from fastsmoothbuildings.bundle import code_mask, package_order, read_class

DECLARATION = re.compile(
    r"^(?:(?:partial|encapsulated|replaceable|final|expandable|pure|impure|operator)\s+)*"
    r"(?P<kind>package|model|block|function|connector|record|type|class)\s+(?P<name>[A-Za-z_]\w*)"
)
ELEMENT = re.compile(
    r"^  (?:(?:partial|encapsulated|replaceable|final|expandable|pure|impure|operator)\s+)*"
    r"(?:(?:package|model|block|function|connector|record|type|class)\s+(?P<cls>[A-Za-z_]\w*)"
    r"|constant\s+[\w.]+(?:\([^)]*\))?\s+(?P<constant>[A-Za-z_]\w*))",
    re.MULTILINE,
)
FILES = sorted(LIBRARY.rglob("*.mo"))
EXAMPLES = [path for path in FILES if {"Examples", "Validation"} & set(path.relative_to(LIBRARY).parts)]


def code(text: str) -> str:
    """``text`` with its strings and comments blanked."""
    mask = code_mask(text)
    return "".join(character if keep or character == "\n" else " " for character, keep in zip(text, mask, strict=True))


@cache
def declaration(path: Path) -> re.Match[str]:
    match = DECLARATION.match(read_class(path)[0])
    assert match is not None, path
    return match


def within(path: Path) -> str:
    parts = path.relative_to(LIBRARY.parent).parts[:-1]
    if path.name == "package.mo":
        parts = parts[:-1]
    return ".".join(parts)


@pytest.mark.parametrize("path", FILES, ids=lambda path: str(path.relative_to(LIBRARY)))
def test_every_file_holds_its_class_within_its_package(path: Path) -> None:
    first = path.read_text(encoding="utf-8").split("\n", 1)[0]
    assert first == f"within {within(path)};"
    name = path.parent.name if path.name == "package.mo" else path.stem
    assert declaration(path)["name"] == name
    if path.name == "package.mo":
        assert declaration(path)["kind"] == "package"


@pytest.mark.parametrize(
    "package", sorted(path.parent for path in LIBRARY.rglob("package.mo")), ids=lambda path: path.name
)
def test_the_package_order_lists_every_class_once(package: Path) -> None:
    order = package_order(package)
    assert len(order) == len(set(order))
    stored = {path.stem for path in package.glob("*.mo") if path.name != "package.mo"}
    stored |= {path.name for path in package.iterdir() if (path / "package.mo").is_file()}
    text = code((package / "package.mo").read_text(encoding="utf-8"))
    inline = {match["cls"] or match["constant"] for match in ELEMENT.finditer("\n".join(text.split("\n")[2:]))}
    assert set(order) == stored | inline


def test_the_library_uses_no_other_library() -> None:
    for path in FILES:
        text = code(path.read_text(encoding="utf-8"))
        assert not re.search(r"\b(?:Modelica|Buildings|IDEAS|AixLib|ModelicaServices)\.\w", text), path
        assert not re.search(r"\buses\s*\(", text), path


def test_the_python_package_carries_the_version_of_the_library() -> None:
    assert fastsmoothbuildings.__version__ == importlib.metadata.version("fastsmoothbuildings")
    assert re.fullmatch(r"\d+\.\d+\.\d+", fastsmoothbuildings.__version__)
    assert LIBRARY.parent == fastsmoothbuildings.ROOT
    assert LIBRARY.name == NAME


def test_every_model_runs_in_an_example() -> None:
    """Every model and block that is not partial is instantiated by an example or a validation model, or by
    another class of the library."""
    library = [path for path in FILES if path not in EXAMPLES and "UsersGuide" not in path.parts]
    models = {
        path.stem
        for path in library
        if path.name != "package.mo"
        and declaration(path)["kind"] in {"model", "block"}
        and not read_class(path)[0].startswith("partial")
    }
    texts = {path: code(path.read_text(encoding="utf-8")) for path in FILES}
    unused = {
        model
        for model in models
        if not any(
            re.search(rf"\b{model}\s+\w+\s*[(\[;\"]|\b{model}\s+\w+\s*$", text, re.MULTILINE)
            for path, text in texts.items()
            if path.stem != model
        )
    }
    assert not unused
