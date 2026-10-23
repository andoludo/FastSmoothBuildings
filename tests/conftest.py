"""Options of the tests."""

from __future__ import annotations

import pytest


def pytest_addoption(parser: pytest.Parser) -> None:
    parser.addoption(
        "--update-references",
        action="store_true",
        default=False,
        help="rewrite the reference results of the examples from their OpenModelica simulations",
    )
