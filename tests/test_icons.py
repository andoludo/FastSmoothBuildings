"""Every component a model is built from has an icon, and every port of a model is placed on it (moved from trano's
tests of the library it embeds)."""

from __future__ import annotations

import re
from functools import cache

from fastsmoothbuildings import bundle

Classes = dict[str, tuple[bool, str, str]]


@cache
def classes() -> Classes:
    """The models and connectors of the library a generated model embeds, by name: whether they are partial, their
    kind and their body."""
    text = bundle(examples=False)
    found = {}
    for match in re.finditer(r"^( *)(partial )?(model|connector) (\w+)\b(?! =)", text, re.MULTILINE):
        indent, partial, kind, name = match.groups()
        end = re.compile(rf"^{indent}end {name};", re.MULTILINE).search(text, match.end())
        assert end, name
        found[name] = (bool(partial), kind, text[match.end() : end.start()])
    return found


def has_icon(name: str, found: Classes) -> bool:
    body = found[name][2]
    bases = [base.split(".")[-1] for base in re.findall(r"^\s*extends ([\w.]+)", body, re.MULTILINE)]
    return "Icon(" in body or any(has_icon(base, found) for base in bases if base in found)


def test_every_component_has_an_icon() -> None:
    found = classes()
    assert found
    assert not [name for name, (partial, _, _) in found.items() if not partial and not has_icon(name, found)]


def test_every_port_is_placed_on_the_icon() -> None:
    found = classes()
    connectors = {"RealInput", "RealOutput"} | {name for name, (_, kind, _) in found.items() if kind == "connector"}
    unplaced = [
        f"{name}.{component}"
        for name, (_, kind, body) in found.items()
        if kind == "model"
        for declaration in re.findall(r"^\s*((?:Interfaces\.|Ventilation\.)?\w+ \w+[^;]*);", body, re.MULTILINE)
        if declaration.split()[0].split(".")[-1] in connectors and "Placement" not in declaration
        for component in [declaration.split()[1].split("(")[0].split("[")[0]]
    ]
    assert not unplaced
