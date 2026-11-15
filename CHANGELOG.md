# Changelog

## Unreleased

* `Controls.HeatPumpControl`: the minimum on and off times of the compressor (`minOnTime`, `minOffTime`, 300 s as
  the safety control of the Buildings heat pump of trano), which were not modelled. The compressor is a bistable
  state `heaOn` that follows the request (demand, heating season, buffer charging) and stays on until it has run
  `minOnTime` and off until it has been off `minOffTime`, without an event: two shares ramp with the time in each
  state and release the switch after the minimum time, within 1 %. The reference results of
  `Examples.HeatPumpCircuit` change: the room temperature moves by at most 0.09 K.
* `Hydronics.HeatMeter`: a pass-through that meters the heat the water carries above the temperature `TExt` of the
  other pipe, as `Buildings.Fluid.Sensors.HeatMeter` (`Q_flow`), and gives its temperature `T` like
  `TemperatureSensor`. It reads the supply of `Examples.BoilerCircuit`, whose reference results gain `supply.Q_flow`
  and the metered heat `EMet`; the other variables are unchanged.
* `Hydronics.Pump`: the argument of the root of the pump curve keeps a floor of 1e-10. Far beyond the shut-off head
  (a pump at rest against the head of another pump in series) the positive part rounded to zero, where the root has
  no slope: the Jacobian held NaN and CVODES stopped. The reference results of the two examples with a cycling
  generator move at a few instants, where a switch falls on the other side of an output point (`supply.Q_flow` at
  1 point of 290 in `Examples.BoilerCircuit`; `heatPump.y` and `heatPump.PEle` at 7 points of 290 in
  `Examples.HeatPumpCircuit`); their means change by less than 1e-4 of their ranges.

## 0.6.0

* The library translates into CasADi with rumoca 0.10.3 from PyPI, as with the commit 33c2114 of rumoca's main
  branch: the shapes that this release refuses are rewritten, with the same equations (the reference results are
  unchanged). `Utilities.smoothLimit` calls the new `Utilities.smoothLimitBelow` and `Utilities.smoothLimitAbove`;
  the sunlit fractions of the windows and `Controls.smoothMaxN` keep a value per loop step; the heat pump table sums
  its kinks in one expression; the walls and windows write `der(T) = Q/C` in their loops; the valve keeps its limited
  opening in `yLim`, the heat pump control its bounded heating curve in `TCur`, the heat pump the conductance of its
  tank in `UATan`. The development environment takes rumoca from PyPI: no Rust toolchain is needed any more.
  `UsersGuide.Translation` lists the shapes.

## 0.5.0

* Releases follow changes of what users install (the library, the Python package, `pyproject.toml`, `README.md`,
  `LICENSE`); changes to the tests, the study, the documentation site or CI no longer publish a version.
* Tests: every component has an icon and every port is placed on it (from trano).

## 0.3.0

* Every class of the library has its documentation (`Documentation(info, revisions)`): purpose, equations,
  parameters, relation to Buildings, use. A test keeps every class documented and every link pointing to a class.
* The documentation site, on GitHub Pages: the guide, a page per class generated from its documentation, the
  validation and the analysis.
* The study against Buildings moves here from trano (`study/`): the closed loop of both libraries on BESTEST cases
  and two houses with perturbations of their descriptions (`study.buildings`), the replay of the controls of
  Buildings (`study.replay`), the reports of the analysis with their scripts and results (`study.analysis`), and
  the workflow that runs it (`study.yaml`).

## 0.2.0

* `bundle(examples=False)` leaves out the packages `Examples`, `Validation` and `UsersGuide`: the library as a
  generated model embeds it (trano).
* Releases are automatic: every change merged into `main` is released once CI passes on it, as in trano.
* The GitHub release carries only the wheel, the sdist and the library as a zip.

## 0.1.0

First release of the library as FastSmoothBuildings, migrated from the `FastModel` package of
[trano](https://github.com/andoludo/trano) at trano commit c70f8d2 (pull request andoludo/trano#60):

* the package `FastModel` renamed `FastSmoothBuildings`, in the directory layout of the Modelica specification;
  the history of `trano/library/FastModel.mo` is kept;
* the Python package `fastsmoothbuildings`: the library, `ROOT`, `LIBRARY`, `bundle()` and the version from the
  `version` annotation of the library;
* a User's Guide, examples and validation models with reference results from OpenModelica;
* tests of the layout of the library, of its translation by rumoca into CasADi and of its simulation in
  OpenModelica.
