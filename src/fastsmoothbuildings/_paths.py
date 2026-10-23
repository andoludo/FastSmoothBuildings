"""Where the Modelica library is: inside the installed package, or at the root of a checkout (editable install)."""

from __future__ import annotations

import re
from pathlib import Path
from typing import Final

NAME: Final = "FastSmoothBuildings"
VERSION = re.compile(r'^\s*version\s*=\s*"(?P<version>[^"]+)"', re.MULTILINE)


def _root() -> Path:
    package = Path(__file__).resolve().parent
    for root in (package / "modelica", package.parents[1]):
        if (root / NAME / "package.mo").is_file():
            return root
    message = f"the Modelica library {NAME} is neither in {package / 'modelica'} nor at the root of a checkout"
    raise FileNotFoundError(message)


def modelica_version(package: Path) -> str:
    """The ``version`` annotation of the ``package.mo`` of a library."""
    match = VERSION.search(package.read_text(encoding="utf-8"))
    if match is None:
        message = f"{package} has no version annotation"
        raise ValueError(message)
    return match["version"]


ROOT: Final = _root()
LIBRARY: Final = ROOT / NAME
