"""Every class of the library is documented, and its documentation reads as the HTML of a Modelica tool expects."""

from __future__ import annotations

import re
from pathlib import Path

import pytest

from fastsmoothbuildings import LIBRARY
from fastsmoothbuildings._documentation import ClassDocumentation, class_documentation, class_files

FILES = list(class_files())
IDS = [str(path.relative_to(LIBRARY)) for path in FILES]
MODELICA_LINK = re.compile(r'href="modelica://([\w.]+?)(?:#[^"]*)?"')


@pytest.fixture(scope="module")
def classes() -> dict[str, ClassDocumentation]:
    return {item.name: item for item in map(class_documentation, FILES)}


def test_every_file_of_the_library_is_listed_by_its_package() -> None:
    assert sorted(FILES) == sorted(LIBRARY.rglob("*.mo"))


@pytest.mark.parametrize("path", FILES, ids=IDS)
def test_every_class_has_a_comment_and_an_info_page(path: Path) -> None:
    documentation = class_documentation(path)
    assert documentation.comment, f"{documentation.name} has no class comment"
    assert documentation.info, f"{documentation.name} has no Documentation(info=...)"
    assert documentation.info.lstrip().startswith("<html>")
    assert documentation.info.rstrip().endswith("</html>")


@pytest.mark.parametrize("path", FILES, ids=IDS)
def test_the_links_of_the_documentation_name_classes_of_the_library(
    path: Path, classes: dict[str, ClassDocumentation]
) -> None:
    documentation = class_documentation(path)
    for name in MODELICA_LINK.findall((documentation.info or "") + (documentation.revisions or "")):
        package, _, short = name.rpartition(".")
        nested = package in classes and re.search(rf"\b{short}\b", classes[package].path.read_text(encoding="utf-8"))
        assert name in classes or nested, f"{documentation.name} links to {name}, which is not a class of the library"


def test_the_parameters_of_a_class_are_read_with_their_units_and_defaults(
    classes: dict[str, ClassDocumentation],
) -> None:
    parameters = {
        parameter.name: parameter for parameter in classes["FastSmoothBuildings.Controls.Hysteresis"].parameters
    }
    assert list(parameters) == ["uLow", "uHigh", "tau", "dU", "y_start"]
    assert (parameters["tau"].unit, parameters["tau"].default) == ("s", "10")
    assert parameters["dU"].default == "(uHigh - uLow)/10"
    assert parameters["uLow"].comment == "Threshold of the switch to 0"
