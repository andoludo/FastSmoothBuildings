"""Show or raise the version of the library: the ``version`` and ``versionDate`` annotations of its package.mo.

    python scripts/bump_version.py            # prints the version
    python scripts/bump_version.py minor      # 0.1.0 -> 0.2.0, versionDate today; prints the new version

The version of the Python package follows: hatchling reads it from the same annotation.
"""

from __future__ import annotations

import argparse
import datetime
import re
from collections.abc import Sequence
from pathlib import Path

PACKAGE = Path(__file__).resolve().parents[1] / "FastSmoothBuildings" / "package.mo"
VERSION = re.compile(r'^(?P<head>\s*version\s*=\s*")(?P<version>\d+\.\d+\.\d+)(?P<tail>")', re.MULTILINE)
DATE = re.compile(r'(?P<head>\bversionDate\s*=\s*")[^"]*(?P<tail>")')
PARTS = ("major", "minor", "patch")


def version(text: str) -> str:
    """The version annotation of the text of a package.mo."""
    match = VERSION.search(text)
    if match is None:
        message = "no version annotation"
        raise ValueError(message)
    return match["version"]


def raised(current: str, part: str) -> str:
    """``current`` with ``part`` raised by one and the parts after it set to zero."""
    numbers = [int(number) for number in current.split(".")]
    index = PARTS.index(part)
    numbers = [*numbers[:index], numbers[index] + 1, *[0] * (len(PARTS) - index - 1)]
    return ".".join(str(number) for number in numbers)


def bump(text: str, part: str, today: datetime.date) -> str:
    """The text of a package.mo with its version raised and its version date set to ``today``."""
    new = raised(version(text), part)
    text = VERSION.sub(lambda match: f"{match['head']}{new}{match['tail']}", text, count=1)
    return DATE.sub(lambda match: f"{match['head']}{today.isoformat()}{match['tail']}", text, count=1)


def main(arguments: Sequence[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("part", nargs="?", choices=PARTS, help="the part to raise; none to print the version")
    parser.add_argument("--package", type=Path, default=PACKAGE, help="the package.mo of the library")
    parsed = parser.parse_args(arguments)
    text = parsed.package.read_text(encoding="utf-8")
    if parsed.part is not None:
        text = bump(text, parsed.part, datetime.datetime.now(tz=datetime.UTC).date())
        parsed.package.write_text(text, encoding="utf-8")
    print(version(text))


if __name__ == "__main__":
    main()
