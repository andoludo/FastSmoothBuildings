"""The examples and validation models the tests run, with the variables kept in their reference results."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from fastsmoothbuildings import LIBRARY, NAME

REFERENCES = LIBRARY / "Resources" / "ReferenceResults" / "OpenModelica"


@dataclass(frozen=True)
class Case:
    """A model of the library to simulate and to translate."""

    name: str
    variables: tuple[str, ...]
    states: tuple[str, ...] = ()
    casadi_tolerance: float = 0.01

    @property
    def qualified(self) -> str:
        """Its full Modelica name."""
        return f"{NAME}.{self.name}"

    @property
    def reference(self) -> Path:
        """Its reference results: OpenModelica's values of ``variables`` on the grid of its experiment."""
        return REFERENCES / f"{self.qualified}.csv"


CASES = (
    Case(
        "Examples.FreeFloatingRoom",
        ("zone.TAir", "zone.TRad", "roof.T[1]", "window.T[1]"),
        states=("zone.TAir", "roof.T[1]", "window.T[1]"),
    ),
    Case(
        "Examples.IdealHeatingRoom",
        ("zone.TAir", "hvac.QHea_flow", "hvac.QCoo_flow", "hvac.EHea", "hvac.ECoo"),
        states=("hvac.EHea", "hvac.ECoo"),
        casadi_tolerance=0.05,
    ),
    Case(
        "Examples.TwoZones",
        ("west.TAir", "east.TAir", "partition.T[1]", "westControl.y", "eastControl.y"),
        states=("west.TAir", "east.TAir"),
        casadi_tolerance=0.15,
    ),
    Case(
        "Examples.VentilatedRoom",
        ("zone.TAir", "unit.TSup", "unit.PFan", "unit.EFan", "supplyDuct.m_flow"),
        states=("zone.TAir", "unit.EFan"),
    ),
    Case(
        "Examples.BoilerCircuit",
        ("zone.TAir", "boiler.T", "supply.T", "radiator.Q_flow", "valve.m_flow", "pump.m_flow", "boiler.EFue"),
        states=("zone.TAir", "boiler.T", "boiler.EFue"),
        casadi_tolerance=0.02,
    ),
    Case(
        "Examples.BoilerCircuitSetFlows",
        ("zone.TAir", "boiler.T", "supply.T", "radiator.Q_flow", "valve.m_flow", "boiler.EFue"),
        states=("zone.TAir", "boiler.T", "boiler.EFue"),
        casadi_tolerance=0.02,
    ),
    Case(
        "Examples.HeatPumpCircuit",
        ("zone.TAir", "heatPump.T", "heatPump.y", "heatPump.PEle", "heatPump.EEle", "radiator1.Q_flow", "pump.m_flow"),
        states=("zone.TAir", "heatPump.T", "heatPump.EEle"),
        casadi_tolerance=0.02,
    ),
    Case(
        "Examples.Photovoltaics",
        ("south.P", "westArray.P", "south.EPro", "westArray.EPro"),
        states=("south.EPro", "westArray.EPro"),
    ),
    Case(
        "Utilities.Validation.SmoothFunctions",
        ("yStep", "yMax", "yMin", "yLimit", "yInside", "yPositive"),
    ),
    Case("Utilities.Validation.Schedules", ("occupied", "TSet")),
    Case("Envelope.Validation.GapConductance", ("hAir", "hLowE", "hArgon")),
    Case("Envelope.Validation.ShadingFractions", ("fraOverhang", "fraFins")),
    Case("Controls.Validation.Hysteresis", ("hys.u", "hys.y"), states=("hys.y",)),
    Case("Controls.Validation.PIControl", ("x", "con.y"), states=("x",), casadi_tolerance=0.001),
)
