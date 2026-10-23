"""The examples and validation models simulate in OpenModelica as their reference results say."""

from __future__ import annotations

from pathlib import Path

import numpy as np
import pytest

from tests.cases import CASES, Case
from tests.openmodelica import docker, read, simulate, write

pytestmark = [
    pytest.mark.openmodelica,
    pytest.mark.skipif(docker() is None, reason="the OpenModelica tests run in Docker"),
]


@pytest.fixture(scope="module")
def simulations(tmp_path_factory: pytest.TempPathFactory) -> tuple[str, dict[str, Path]]:
    return simulate(CASES, tmp_path_factory.mktemp("openmodelica"))


def test_the_library_loads_without_messages(simulations: tuple[str, dict[str, Path]]) -> None:
    messages, _ = simulations
    assert not messages.strip(), messages


@pytest.mark.parametrize("case", CASES, ids=lambda case: case.name)
def test_the_model_matches_its_reference_results(
    case: Case, simulations: tuple[str, dict[str, Path]], request: pytest.FixtureRequest
) -> None:
    _, results = simulations
    assert results[case.name].is_file(), (results[case.name].parent / f"{case.qualified}.messages").read_text()
    values = read(results[case.name], case.variables)
    if request.config.getoption("--update-references"):
        write(case.reference, values)
    reference = read(case.reference, case.variables)
    np.testing.assert_allclose(values["time"], reference["time"], rtol=1e-9, atol=1e-6)
    for variable in case.variables:
        tolerance = max(1e-3 * float(np.ptp(reference[variable])), 1e-6 * float(np.max(np.abs(reference[variable]))))
        np.testing.assert_allclose(
            values[variable], reference[variable], rtol=0, atol=max(tolerance, 1e-9), err_msg=variable
        )
