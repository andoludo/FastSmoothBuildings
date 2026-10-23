"""BESTEST of FastSmoothBuildings: every KPI against the band of ASHRAE 140 and against Buildings, now and along the
history.

The BESTEST validation is trano's (it runs every library trano generates): this script reads the committed files of a
checkout of trano, given by ``--trano`` or the environment variable ``TRANO_REPOSITORY`` (``../trano`` by default),
and simulates nothing. It reads the results of the last BESTEST run of FastSmoothBuildings
(``validation/bestest/results/FastSmoothBuildings``), the frozen values of Buildings (``validation/bestest/expected``)
and, with ``--history``, every version of the frozen values of the library in the git history of trano (``FastModel``
before the library moved to this repository), each set against the Buildings values frozen at the same commit.

    python -m study.analysis.scripts.bestest_comparison --history

Writes ``bestest_kpis.csv`` (one row per case and KPI), ``bestest_summary.json`` and ``bestest_history.csv``.
"""

from __future__ import annotations

import argparse
import importlib
import json
import os
import shutil
import subprocess
import sys
from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
from statistics import fmean
from typing import Any

from study.analysis.scripts._common import ROOT, configure_logging, write_csv, write_json

FROZEN = "validation/bestest/expected/{library}.json"
LIBRARY = "FastSmoothBuildings"
NAMES = (LIBRARY, "FastModel")  # the name of the library in trano, now and before it moved to this repository
Values = Mapping[str, Mapping[str, float]]


@dataclass(frozen=True)
class Bestest:
    """The BESTEST validation of a checkout of trano: its reference data, acceptance bands and committed results."""

    repository: Path
    harness: Any
    reference: Any
    report: Any

    @classmethod
    def at(cls, repository: Path) -> Bestest:
        if not (repository / "validation" / "bestest").is_dir():
            raise FileNotFoundError(f"{repository} is not a checkout of trano: give it with --trano")
        sys.path.insert(0, str(repository))
        modules = (importlib.import_module(f"validation.bestest.{name}") for name in ("harness", "reference", "report"))
        return cls(repository, *modules)

    @property
    def kpis(self) -> tuple[str, ...]:
        return tuple(self.reference.KPIS)

    def committed(self) -> dict[str, dict[str, float]]:
        """The KPIs of the last BESTEST run of the library, by case."""
        results = self.harness.committed_results(LIBRARY).items()
        return {case: {kpi: result.kpis.value(kpi) for kpi in self.kpis} for case, result in results}

    def git(self, *arguments: str) -> str:
        git = shutil.which("git")
        if git is None:
            raise RuntimeError("--history reads the git history of trano: git is not on the PATH")
        # a fixed git command and the paths of the frozen values
        return subprocess.run(  # noqa: S603
            [git, *arguments], cwd=self.repository, capture_output=True, text=True, check=True
        ).stdout


@dataclass(frozen=True)
class KpiRow:
    case: str
    kpi: str
    unit: str
    fast_model: float
    buildings: float | None
    deviation: float | None  # the library against Buildings: relative for a load above LOAD_FLOOR, [K] for a degC
    lower: float
    upper: float
    reference_mean: float
    inside: bool


def kpi_rows(bestest: Bestest, fast_model: Values, buildings: Values, reference: Any) -> list[KpiRow]:  # noqa: ANN401
    rows = []
    for case in sorted(fast_model, key=lambda name: (len(name), name)):
        for kpi in bestest.kpis:
            kpi_reference = reference.kpi(case, kpi)
            value = fast_model[case].get(kpi)
            if kpi_reference is None or value is None:
                continue
            lower, upper = bestest.report.acceptance_band(kpi_reference)
            other = buildings.get(case, {}).get(kpi)
            deviation = None
            if other is not None and kpi_reference.unit == "degC":
                deviation = value - other
            elif other is not None and abs(other) > bestest.report.LOAD_FLOOR:
                deviation = value / other - 1
            rows.append(
                KpiRow(
                    case=case,
                    kpi=kpi,
                    unit=kpi_reference.unit,
                    fast_model=value,
                    buildings=other,
                    deviation=deviation,
                    lower=lower,
                    upper=upper,
                    reference_mean=kpi_reference.mean,
                    inside=lower <= value <= upper,
                )
            )
    return rows


def _statistics(name: str, values: list[float]) -> dict[str, float | None]:
    return {
        f"{name}_mean": fmean(values) if values else None,
        f"{name}_min": min(values, default=None),
        f"{name}_max": max(values, default=None),
    }


def summary(rows: list[KpiRow]) -> dict[str, float | int | None]:
    """The statistics the BESTEST page gives: KPIs inside their band, gaps of the loads and temperatures."""

    def deviations(kpi: str | None = None, temperature: bool = False) -> list[float]:
        return [
            row.deviation
            for row in rows
            if row.deviation is not None and (row.unit == "degC") == temperature and kpi in (None, row.kpi)
        ]

    loads = [abs(value) for value in deviations()]
    temperatures = [abs(value) for value in deviations(temperature=True)]
    return (
        {"cases": len({row.case for row in rows}), "kpis": len(rows), "inside": sum(row.inside for row in rows)}
        | _statistics("annual_heating", deviations(kpi="annual_heating"))
        | _statistics("annual_cooling", deviations(kpi="annual_cooling"))
        | {"loads_mean_abs": fmean(loads) if loads else None, "loads_max_abs": max(loads, default=None)}
        | {
            "temperatures_mean_abs_k": fmean(temperatures) if temperatures else None,
            "temperatures_max_abs_k": max(temperatures, default=None),
        }
    )


def history(bestest: Bestest, reference: Any) -> list[dict[str, object]]:  # noqa: ANN401
    """The statistics of every frozen version of the values of the library in trano, oldest first."""
    rows: list[dict[str, object]] = []
    paths = [FROZEN.format(library=name) for name in NAMES]
    log = bestest.git("log", "--reverse", "--format=%h%x09%ad%x09%s", "--date=short", "--", *paths)
    for line in log.splitlines():
        commit, date, subject = line.split("\t", 2)
        present = bestest.git("ls-tree", "--name-only", commit, "--", *paths).split()
        if not present:
            continue  # the commit removed the file
        fast_model = json.loads(bestest.git("show", f"{commit}:{present[0]}"))
        buildings = json.loads(bestest.git("show", f"{commit}:{FROZEN.format(library='Buildings')}"))
        statistics = summary(kpi_rows(bestest, fast_model, buildings, reference))
        rows.append({"commit": commit, "date": date, "subject": subject, **statistics})
    return rows


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--history", action="store_true", help="also every frozen version in the git history")
    parser.add_argument(
        "--trano",
        type=Path,
        default=Path(os.environ.get("TRANO_REPOSITORY", ROOT.parent / "trano")),
        help="a checkout of trano (default: $TRANO_REPOSITORY or ../trano)",
    )
    arguments = parser.parse_args(argv)
    configure_logging()
    bestest = Bestest.at(arguments.trano.resolve())
    reference = bestest.reference.load_reference()
    rows = kpi_rows(bestest, bestest.committed(), bestest.report.frozen_values("Buildings"), reference)
    write_csv("bestest_kpis.csv", [vars(row) for row in rows])
    shading = [row for row in rows if row.case in {"610", "630", "910", "930"}]
    write_json(
        "bestest_summary.json",
        {
            "all_cases": summary(rows),
            "shading_cases": summary(shading)
            | {"largest_gap_to_buildings": max(abs(row.deviation or 0) for row in shading)},
            "outside_band": [f"{row.case} {row.kpi}" for row in rows if not row.inside],
        },
    )
    if arguments.history:
        write_csv("bestest_history.csv", history(bestest, reference))


if __name__ == "__main__":
    main()
