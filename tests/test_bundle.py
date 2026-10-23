"""bundle() writes the library as one file; strip_documentation() leaves the code as it is."""

from __future__ import annotations

import re
from pathlib import Path

import fastsmoothbuildings
from fastsmoothbuildings import LIBRARY, NAME
from fastsmoothbuildings.bundle import bundle, code_mask, code_starts, strip_documentation


def test_the_bundle_holds_every_class_of_the_library() -> None:
    text = fastsmoothbuildings.bundle()
    assert text.startswith(f"package {NAME} ")
    assert text.endswith(f"end {NAME};\n")
    for path in LIBRARY.rglob("*.mo"):
        name = path.parent.name if path.name == "package.mo" else path.stem
        assert f"end {name};" in text or f" {name} =" in text, path


def test_the_classes_of_a_package_go_before_its_annotation(tmp_path: Path) -> None:
    package = tmp_path / "Lib"
    package.mkdir()
    (package / "package.mo").write_text(
        'within ;\npackage Lib "A library"\n  constant Real c = 1;\n'
        '  annotation (Documentation(info="<html>end Lib;</html>"));\nend Lib;\n'
    )
    (package / "M.mo").write_text("within Lib;\nmodel M\n  Real x = c;\nend M;\n")
    (package / "package.order").write_text("c\nM\n")
    text = bundle(package)
    assert text.index("model M") < text.index("annotation (Documentation")
    assert text == (
        'package Lib "A library"\n  constant Real c = 1;\n\n  model M\n    Real x = c;\n  end M;\n'
        '  annotation (Documentation(info="<html>end Lib;</html>"));\nend Lib;\n'
    )


def test_strip_documentation_keeps_the_code_and_the_other_annotations() -> None:
    text = (
        'model M "Documentation(info) in a string"\n'
        "  // Documentation( in a comment\n"
        '  Real x annotation (Documentation(info="(x)"), Placement(transformation(extent={{0,0},{1,1}})));\n'
        '  annotation (Icon(graphics={Text(textString="(")}), Documentation(info="<html>a \\"(\\" b</html>"));\n'
        "end M;\n"
    )
    assert strip_documentation(text) == (
        'model M "Documentation(info) in a string"\n'
        "  // Documentation( in a comment\n"
        "  Real x annotation (Placement(transformation(extent={{0,0},{1,1}})));\n"
        '  annotation (Icon(graphics={Text(textString="(")}));\n'
        "end M;\n"
    )


def test_the_bundle_without_documentation_is_shorter_and_has_none() -> None:
    full = fastsmoothbuildings.bundle()
    short = fastsmoothbuildings.bundle(documentation=False)
    assert len(short) < len(full)
    mask = code_mask(short)
    assert all(not mask[index] for index in range(len(short)) if short.startswith("Documentation(", index))


def test_the_scanners_skip_strings_and_comments() -> None:
    lines = ['a "x\\" y', "still in the string", '" end', "/* comment", "*/ b", 'd // "', "e"]
    assert code_starts(lines) == [True, False, False, True, False, True, True]
    text = 'a "b" /* c */ d // e\nf'
    assert "".join(c for c, keep in zip(text, code_mask(text), strict=True) if keep) == "a   d \nf"


def test_the_bundle_without_examples_keeps_the_models() -> None:
    full = fastsmoothbuildings.bundle()
    lean = fastsmoothbuildings.bundle(examples=False)
    for package in ("Examples", "Validation", "UsersGuide"):
        assert re.search(rf"\bpackage {package}\b", full)
        assert not re.search(rf"\bpackage {package}\b", lean)
    for model in ("model Zone", "model Window", "model HeatPump", "function regStep"):
        assert model in lean
