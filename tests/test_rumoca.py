"""rumoca translates every example into CasADi, and the CasADi model follows OpenModelica's results."""

from __future__ import annotations

import math
from functools import cache
from typing import Any

import numpy as np
import numpy.typing as npt
import pytest

import fastsmoothbuildings
from tests.cases import CASES, Case
from tests.openmodelica import read

ca = pytest.importorskip("casadi")
rumoca = pytest.importorskip("rumoca")
Vector = npt.NDArray[np.float64]


def wrapper(case: Case) -> str:
    return f"model Wrapper\n  extends {case.qualified};\nend Wrapper;\n"


@cache
def translate(source: str, model: str, *, bundle: bool = False, examples: bool = True) -> Any:  # noqa: ANN401
    """The CasADi export of ``model`` in ``source``, the library read from its folder or embedded as one file."""
    if bundle:
        text = fastsmoothbuildings.bundle(examples=examples) + source
        return rumoca.Session().loads(text, model=model).to_casadi()
    return rumoca.Session(roots=[str(fastsmoothbuildings.LIBRARY)]).loads(source, model=model).to_casadi()


def defaults(export: Any) -> tuple[Vector, Vector, Vector]:  # noqa: ANN401
    """Start states, zero inputs and default parameters of an export."""
    states = np.asarray(export.default_states, dtype=float).ravel()
    parameters = np.asarray(export.default_parameters, dtype=float).ravel()
    return states, np.zeros(export.rhs.size1_in(2)), parameters


def derivatives(export: Any, time: float, states: Vector, inputs: Vector, parameters: Vector) -> Vector:  # noqa: ANN401
    return np.asarray(export.rhs(time, states, inputs, parameters), dtype=float).ravel()


@pytest.mark.parametrize("case", CASES, ids=lambda case: case.name)
def test_rumoca_translates_the_model(case: Case) -> None:
    export = translate(wrapper(case), "Wrapper")
    states, inputs, parameters = defaults(export)
    assert export.rhs.size1_in(2) == 0, "an example is closed: no free input"
    for hour in (0, 6, 12, 18):
        assert np.all(np.isfinite(derivatives(export, 3600.0 * hour, states, inputs, parameters)))


def test_the_bundle_translates_as_the_folder() -> None:
    case = next(case for case in CASES if case.name == "Examples.BoilerCircuit")
    folder = translate(wrapper(case), "Wrapper")
    embedded = translate(wrapper(case), "Wrapper", bundle=True)
    assert [str(name) for name in folder.state_names] == [str(name) for name in embedded.state_names]
    states, inputs, parameters = defaults(folder)
    for hour in (0, 12):
        np.testing.assert_array_equal(
            derivatives(folder, 3600.0 * hour, states, inputs, parameters),
            derivatives(embedded, 3600.0 * hour, states, inputs, parameters),
        )


@pytest.mark.parametrize("case", [case for case in CASES if case.states], ids=lambda case: case.name)
def test_the_casadi_model_follows_the_reference_results(case: Case) -> None:
    """CVODES on the CasADi model against OpenModelica's DASSL on the Modelica model: the same trajectories."""
    export = translate(wrapper(case), "Wrapper")
    names = [str(name) for name in export.state_names]
    states, inputs, parameters = defaults(export)
    reference = read(case.reference, case.variables)
    x, t, p = ca.SX.sym("x", states.size), ca.SX.sym("t"), ca.SX.sym("p", parameters.size)
    problem = {"x": x, "t": t, "p": p, "ode": export.rhs(t, x, inputs, p)}
    options = {"abstol": 1e-8, "reltol": 1e-6, "max_num_steps": 200000}
    integrator = ca.integrator("integrator", "cvodes", problem, 0.0, reference["time"][1:], options)
    trajectory = np.hstack([states[:, None], np.asarray(integrator(x0=states, p=parameters)["xf"])])
    for state in case.states:
        difference = np.max(np.abs(trajectory[names.index(state)] - reference[state]))
        assert difference < case.casadi_tolerance, f"{state}: {difference}"


PROBE = """
model Probe
  input Real u1;
  input Real u2;
  input Real u3;
{states}
equation
{equations}
end Probe;
"""


def probe(expressions: list[str], inputs: list[float]) -> Vector:
    """The values of ``expressions`` of ``u1``, ``u2`` and ``u3``, evaluated by the CasADi export of rumoca as the
    derivatives of as many states."""
    source = PROBE.format(
        states="\n".join(f"  Real s{i}(start=0, fixed=true);" for i in range(len(expressions))),
        equations="\n".join(f"  der(s{i}) = {expression};" for i, expression in enumerate(expressions)),
    )
    export = translate(source, "Probe")
    _, _, parameters = defaults(export)
    return derivatives(export, 0.0, np.zeros(len(expressions)), np.array(inputs, dtype=float), parameters)


@pytest.mark.parametrize(
    ("x", "expected"),
    [(-1.0, 0.0), (-0.01, 0.0), (0.0, 0.0025), (0.005, 0.005625), (0.02, 0.02), (0.5, 0.5), (1.0, 0.9975), (2.0, 1.0)],
)
def test_the_smooth_limit_reaches_its_bounds_and_stays_inside(x: float, expected: float) -> None:
    """Exactly 0 and 1 beyond the blends of half width 0.01, never outside [0, 1]."""
    value = probe(["FastSmoothBuildings.Utilities.smoothLimit(u1, 0, 1, 0.01)"], [x, 0, 0])[0]
    assert value == pytest.approx(expected, abs=1e-12)


def en673_gap_conductance(thickness: float, eps_a: float, eps_b: float) -> float:
    """Conductance of an air gap after EN 673 at its mean temperature (283 K) with 15 K across it."""
    mean, sigma, gravity, conductivity, density, capacity = 283.0, 5.670374419e-8, 9.81, 0.025, 1.2, 1006.0
    viscosity = 3.723e-6 + 4.94e-8 * mean
    radiation = 4 * sigma * mean**3 / (1 / eps_a + 1 / eps_b - 1)
    grashof = gravity * thickness**3 * 15.0 * density**2 / (mean * viscosity**2)
    nusselt = max(1.0, 0.035 * math.pow(grashof * viscosity * capacity / conductivity, 0.38))
    return radiation + nusselt * conductivity / thickness


def gap(t_a: float, t_b: float, eps: float = 0.84) -> float:
    expression = (
        "FastSmoothBuildings.Envelope.Functions.gapConductance(u1, u2, 0.012, 0.025, 3.723e-6, 4.94e-8, 1006,"
        " 0.02897, u3, 0.84, 2.0)"
    )
    return float(probe([expression], [t_a, t_b, eps])[0])


def test_the_gas_gap_conducts_with_the_temperatures_of_its_panes() -> None:
    """A 12 mm air gap: the EN 673 value at the EN 673 state, a fifth more between panes at 40 and 30 degC, most of
    the radiation gone with a low-e face, smooth when both panes are at the same temperature."""
    reference = gap(290.5, 275.5)
    assert reference == pytest.approx(en673_gap_conductance(0.012, 0.84, 0.84), rel=0.02)
    assert gap(313.15, 303.15) == pytest.approx(1.18 * reference, rel=0.02)
    assert gap(278.15, 268.15) < reference
    assert gap(290.5, 275.5, eps=0.04) < 0.45 * reference
    assert gap(293.15, 293.15) == pytest.approx(gap(293.16, 293.14), rel=1e-4)


@pytest.mark.parametrize(
    ("ver_azi", "alt", "overhang", "fins"),
    [
        (0.0, math.pi / 4, 0.5, 1.0),  # the sun facing the wall: a 1 m overhang shades 1 m of the 2 m window
        (0.0, math.pi / 3, 1 - math.sqrt(3) / 2, 1.0),
        # a low sun 45 degrees aside: the overhang shades a strip of tan(0.05)/cos(45) = 7 cm, a 1 m fin shades
        # 1 m of the 3 m width but for the small triangle above its shadow
        (math.pi / 4, 0.05, 1 - math.tan(0.05) / math.cos(math.pi / 4) / 2, 0.672),
        (0.0, -0.2, 0.0, 0.0),  # the sun below the horizon
        (2.0, 0.5, 0.0, 0.0),  # the sun behind the wall
    ],
)
def test_overhangs_and_side_fins_shade_as_buildings(ver_azi: float, alt: float, overhang: float, fins: float) -> None:
    """The sunlit fractions of Buildings' Overhang and SideFins on geometries whose shadow is known."""
    fractions = probe(
        [
            "FastSmoothBuildings.Envelope.Functions.overhangSunlitFraction(u1, u2, 0, 2.0, 3.0, 1.0, 0.0, 10.0, 10.0)",
            "FastSmoothBuildings.Envelope.Functions.sideFinsSunlitFraction(u1, u2, 2.0, 3.0, 1.0, 0.0, 0.0)",
        ],
        [ver_azi, alt, 0.0],
    )
    assert fractions[0] == pytest.approx(overhang, abs=0.02)
    assert fractions[1] == pytest.approx(fins, abs=0.02)


def test_the_bundle_without_examples_translates_as_the_folder() -> None:
    """The library as a model embeds it (no examples, no User's Guide) gives the same CasADi model."""
    source = PROBE.format(
        states="  Real s0(start=0, fixed=true);",
        equations="  der(s0) = FastSmoothBuildings.Envelope.Functions.gapConductance(u1, u2, 0.012, 0.025, 3.723e-6,"
        " 4.94e-8, 1006, 0.02897, u3, 0.84, 2.0);",
    )
    folder = translate(source, "Probe")
    lean = translate(source, "Probe", bundle=True, examples=False)
    _, _, parameters = defaults(folder)
    inputs = np.array([290.5, 275.5, 0.84])
    np.testing.assert_array_equal(
        derivatives(folder, 0.0, np.zeros(1), inputs, parameters),
        derivatives(lean, 0.0, np.zeros(1), inputs, defaults(lean)[2]),
    )
