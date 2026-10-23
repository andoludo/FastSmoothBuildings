"""Helpers of trano's BESTEST validation (``validation.bestest`` of the trano repository, which its wheel leaves
out)."""

from __future__ import annotations

import hashlib
import re
from typing import TYPE_CHECKING

from trano.elements.base import BaseElement

if TYPE_CHECKING:
    from buildingspy.io.outputfile import Reader
    from trano_simulate.simulate import SimulationOptions


def normalized_model(model: str) -> str:
    """The statements of the model, sorted, without annotations and whitespace.

    Layout coordinates differ between renders and the order of the data records (materials, constructions) between
    processes: neither changes the simulation, so neither changes the hash.
    """
    without_annotations = re.sub(r"annotation\s*\(.*?\)\s*;", "", model, flags=re.DOTALL)  # they hold no semicolon
    pieces = re.split(r";|\b(?=(?:record|package|model|end|equation)\b)", without_annotations)
    statements = {re.sub(r"\s+", "", piece) for piece in pieces} - {""}
    return ";".join(sorted(statements))


def model_hash(model: str, library: str, options: SimulationOptions) -> str:
    """The key of a cached simulation: the library, the simulation options and the generated model."""
    digest = hashlib.sha256()
    # an unset variable filter is left out: the runs cached before the option existed keep their hash
    settings = options.model_dump_json(exclude={"variable_filter"} if options.variable_filter is None else None)
    for part in (library, settings, normalized_model(model)):
        digest.update(part.encode())
        digest.update(b"\0")
    return digest.hexdigest()


def reset_element_names() -> None:
    """Restart the numbering of auto-named elements so that the same case renders the same names."""
    classes: list[type[BaseElement]] = [BaseElement]
    while classes:
        cls = classes.pop()
        cls.name_counter = 0
        classes += cls.__subclasses__()


def find_variable(reader: Reader, suffix: str) -> str:
    """The single result variable ending with ``suffix`` (the model nests components in containers)."""
    matches = [name for name in reader.varNames() if name == suffix or name.endswith("." + suffix)]
    if len(matches) != 1:
        raise ValueError(f"Expected one variable ending with {suffix!r}, found {matches}")
    return str(matches[0])
