# Migration from trano's FastModel, phase 1: the repository

Phase 1 created this repository from trano's `FastModel` package at trano commit c70f8d2 (PR andoludo/trano#60).

## What it holds

* `main` starts with the 23 commits of trano that changed `trano/library/FastModel.mo`, imported with
  `git filter-repo` (the file as `FastModel.mo`, each message ending with `Imported-from: andoludo/trano@<sha>`,
  pull requests referred to as `andoludo/trano#<n>`); the next commit splits it into the library.
* `FastSmoothBuildings/`: the library in the directory layout, with a User's Guide, the documentation of every
  package, examples and validation models, and their reference results from OpenModelica 1.26.9
  (`Resources/ReferenceResults/OpenModelica`).
* `src/fastsmoothbuildings`: the Python package (`LIBRARY`, `ROOT`, `bundle()`, the version from the version
  annotation of the library); the wheel carries the library.
* `tests/`: the layout, the bundle, rumoca and CasADi, OpenModelica (Docker).
* `.github/workflows`: CI (lint, tests on Python 3.11 and 3.13, OpenModelica, build) and the release on a tag
  `v<version>` (PyPI trusted publishing, a GitHub release with the library as a zip).

## Found on the way

* **rumoca reads every Modelica file below a root.** Given the root of a checkout, it also found a copy of the
  library in `.venv` (hatchling's editable install copies the force-included folder) and refused the duplicates.
  Tools pass `fastsmoothbuildings.LIBRARY`, the folder of the library, as the root; `ROOT` is for `MODELICAPATH`.
* **rumoca 0.10.3 and `dayTable`.** With a table of several rows, rumoca translates `dayTable` when the table is a
  parameter and, at the top level of the model, when the call is an equation; with a literal matrix in the call or
  in the binding of a declaration, it expands the loop of the function into extra equations ("unbalanced model") or
  leaves a residual equation. The library and the models trano generates use the working form (BESTEST 950 with
  its night ventilation and 940 with its set-back schedule translate); the User's Guide states the rule.
* **A mixing valve after the pump.** With the pump upstream of the three-way valve (trano's circuits), a supply
  set point below the boiler temperature closes the supply path and dead-heads the pump; trano runs these circuits
  with the set point above the boiler (the valve open), and so does `Examples.BoilerCircuit`.
* The CasADi models of the examples, integrated by CVODES, follow OpenModelica's DASSL results within 2 to 7 mK on
  the rooms, the boiler and the buffer; 0.09 K with the on/off thermostat of `Examples.TwoZones`, whose switching
  instants differ slightly between the solvers.
