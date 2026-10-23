"""The release raises the version annotation of the library, and nothing else."""

from __future__ import annotations

import datetime
import re
import subprocess
import sys
import tomllib
from pathlib import Path

import pytest

import fastsmoothbuildings
from fastsmoothbuildings import LIBRARY

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "bump_version.py"


def run(*arguments: str) -> str:
    return subprocess.run(
        [sys.executable, str(SCRIPT), *arguments], capture_output=True, text=True, check=True
    ).stdout.strip()


def test_the_script_shows_the_version_of_the_library() -> None:
    assert run() == fastsmoothbuildings.__version__


def test_the_package_has_the_version_of_the_library() -> None:
    pyproject = tomllib.loads((SCRIPT.parents[1] / "pyproject.toml").read_text(encoding="utf-8"))
    assert pyproject["project"]["version"] == fastsmoothbuildings.__version__


@pytest.mark.parametrize(("part", "expected"), [("major", "1.0.0"), ("minor", "0.3.0"), ("patch", "0.2.4")])
def test_the_script_raises_one_part_of_the_version(tmp_path: Path, part: str, expected: str) -> None:
    """Only the version and the version date change."""
    package = tmp_path / "package.mo"
    text = (LIBRARY / "package.mo").read_text(encoding="utf-8")
    text = re.sub(r'version="[^"]*"', 'version="0.2.3"', text, count=1)
    seed = re.sub(r'versionDate="[^"]*"', 'versionDate="2000-01-01"', text, count=1)
    package.write_text(seed, encoding="utf-8")
    pyproject = tmp_path / "pyproject.toml"
    pyproject.write_text('[project]\nname = "x"\nversion = "0.2.3"\n\n[tool.x]\nversion = "9"\n', encoding="utf-8")
    assert run(part, "--package", str(package), "--pyproject", str(pyproject)) == expected
    assert pyproject.read_text(encoding="utf-8").count(f'version = "{expected}"') == 1
    today = datetime.datetime.now(tz=datetime.UTC).date().isoformat()
    assert package.read_text(encoding="utf-8") == seed.replace('version="0.2.3"', f'version="{expected}"').replace(
        'versionDate="2000-01-01"', f'versionDate="{today}"'
    )
