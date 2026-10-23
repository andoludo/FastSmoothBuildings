"""Simulations of the library in the official OpenModelica image (Docker), and their results."""

from __future__ import annotations

import csv
import os
import re
import shutil
import subprocess
from collections.abc import Iterable, Sequence
from pathlib import Path, PurePosixPath

import numpy as np
import numpy.typing as npt

from fastsmoothbuildings import LIBRARY, NAME
from tests.cases import Case

IMAGE = os.environ.get("FSB_OPENMODELICA_IMAGE", "openmodelica/openmodelica:v1.26.9-ompython")
MOUNT = PurePosixPath("/library")
WORK = PurePosixPath("/work")


def docker() -> str | None:
    """The docker executable, if there is one and its daemon answers."""
    executable = shutil.which("docker")
    if executable is None:
        return None
    answer = subprocess.run([executable, "info"], capture_output=True, check=False)
    return executable if answer.returncode == 0 else None


def omc(script: str, work: Path) -> str:
    """Run an OpenModelica script with the library on ``MODELICAPATH``; its output."""
    executable = docker()
    if executable is None:
        message = "docker is not available"
        raise RuntimeError(message)
    (work / "run.mos").write_text(f'setModelicaPath("{MOUNT}");\n{script}', encoding="utf-8")
    user = [] if os.name != "posix" else ["--user", f"{os.getuid()}:{os.getgid()}", "-e", f"HOME={WORK}"]
    command = [
        executable, "run", "--rm", *user,
        "-v", f"{LIBRARY}:{MOUNT / NAME}:ro",
        "-v", f"{work}:{WORK}",
        "-w", str(WORK),
        IMAGE, "omc", str(WORK / "run.mos"),
    ]  # fmt: skip
    return subprocess.run(command, capture_output=True, text=True, check=True, timeout=3600).stdout


def variable_filter(variables: Iterable[str]) -> str:
    """OpenModelica's ``variableFilter`` that keeps exactly ``variables``."""
    return "|".join(re.sub(r"([.\[\]()])", r"\\\\\1", variable) for variable in variables)


def simulate(cases: Sequence[Case], work: Path) -> tuple[str, dict[str, Path]]:
    """Simulate ``cases`` in one OpenModelica session: the messages of loading the library and the result files."""
    lines = [f"loadModel({NAME});", 'writeFile("load.txt", getErrorString());']
    for case in cases:
        lines += [
            f'simulate({case.qualified}, outputFormat="csv", fileNamePrefix="{case.qualified}",'
            f' variableFilter="{variable_filter(case.variables)}");',
            f'writeFile("{case.qualified}.log", getErrorString());',
        ]
    omc("\n".join(lines) + "\n", work)
    return (work / "load.txt").read_text(encoding="utf-8"), {
        case.name: work / f"{case.qualified}_res.csv" for case in cases
    }


def read(path: Path, variables: Sequence[str]) -> dict[str, npt.NDArray[np.float64]]:
    """The time and ``variables`` of a CSV result file."""
    with path.open(encoding="utf-8", newline="") as file:
        rows = list(csv.DictReader(file))
    return {name: np.array([float(row[name]) for row in rows]) for name in ("time", *variables)}


def write(path: Path, values: dict[str, npt.NDArray[np.float64]]) -> None:
    """Write results as CSV, ten significant digits."""
    path.parent.mkdir(parents=True, exist_ok=True)
    names = list(values)
    with path.open("w", encoding="utf-8", newline="") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerow(names)
        writer.writerows([f"{values[name][i]:.10g}" for name in names] for i in range(len(values["time"])))
