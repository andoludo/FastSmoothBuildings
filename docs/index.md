# FastSmoothBuildings

FastSmoothBuildings is a Modelica library of buildings and their heating, cooling and ventilation systems written
as **smooth, event-free, explicit ordinary differential equations**:

* in closed loop, with its own smooth controllers, it follows the
  [Modelica Buildings library](https://github.com/lbl-srg/modelica-buildings): layered walls, windows with the
  angular optics and gas gaps of Buildings, long-wave and solar exchanges in the rooms, radiators, valves, pumps,
  boilers, heat pumps with their buffer, ventilation with heat recovery, photovoltaics;
* with the controls of its systems as inputs, [rumoca](https://github.com/CogniPilot/rumoca) translates it into a
  [CasADi](https://web.casadi.org) model, ready for model predictive control, state estimation and calibration with
  IPOPT.

It has no dependency, not even the Modelica Standard Library, and runs in OpenModelica, Dymola and rumoca alike.

The library was developed as the `FastModel` package of [trano](https://github.com/andoludo/trano), which generates
its models from a YAML description of a building; its history is in this repository. In trano's validation, the
models it generates pass the 27 cases of ASHRAE Standard 140 (BESTEST), with heating and cooling loads within 1.1 %
of Buildings on average, and follow Buildings within 0.02 to 0.10 K on the zone temperatures of a six-zone house
([BESTEST](validation/bestest.md)).

## Install

The Modelica library is the folder [`FastSmoothBuildings`](https://github.com/andoludo/FastSmoothBuildings/tree/main/FastSmoothBuildings):

* **OpenModelica**: add the folder that holds it to `MODELICAPATH` and `loadModel(FastSmoothBuildings)`, or
  `loadFile("<path>/FastSmoothBuildings/package.mo")`;
* **Dymola, OMEdit**: open `FastSmoothBuildings/package.mo`.

The Python package `fastsmoothbuildings` carries the library and tells tools where it is:

```bash
pip install fastsmoothbuildings
```

```python
import rumoca

import fastsmoothbuildings

session = rumoca.Session(roots=[str(fastsmoothbuildings.LIBRARY)])  # rumoca reads the library from its folder
model = session.loads(source, model="MyBuilding.building").to_casadi()

text = fastsmoothbuildings.bundle()  # or the whole library as one file, to embed it in a generated model
```

`fastsmoothbuildings.LIBRARY` is the folder of the library (rumoca reads every Modelica file below a root, so give it
the library itself), `fastsmoothbuildings.ROOT` the folder that holds it, to put on `MODELICAPATH`, and
`fastsmoothbuildings.__version__` the version of the library (its `version` annotation).

## The library

The [library reference](library/index.md) has a page per class, from its Modelica documentation.

| Package | Content |
|---|---|
| `UsersGuide` | Conventions, the smooth functions and the rules that keep a model translatable by rumoca |
| `Examples` | Rooms, hydronic circuits, ventilation and ideal systems to simulate |
| `BoundaryConditions` | Weather data, solar position, Perez sky model, irradiance on tilted surfaces |
| `Envelope` | Walls, floors, roofs (layers split into sublayers as Buildings), windows (panes, gas gaps, frame, overhangs and side fins) |
| `Zones` | Room air, long-wave exchange between surfaces, distribution of the transmitted sun, internal gains |
| `Hydronics` | Water circuits with set flows (optimal control) or pressure-driven flows (closed loop): pipes, pumps, valves, three-way valves, junctions, EN 442 radiators, boilers, air-to-water heat pumps with buffer |
| `Ventilation` | Ducts and air handling unit with heat recovery |
| `Controls` | Event-free controllers: hysteresis as fast bistable states, anti-windup PI, emission, collector, boiler and heat pump controls, every smoothing width a parameter |
| `HVAC` | Ideal heating and cooling |
| `Electrical` | Photovoltaics |
| `Utilities` | Smooth functions (`regStep`, `smoothMax`, `smoothMin`, `smoothLimit`, ...), convection laws, valve characteristics |

A model built from these classes stays an explicit ODE: no `when`, `pre`, `sample` or event-generating `if`;
switches are `regStep` transitions whose width is a parameter. rumoca sizes arrays and evaluates subscripts from
literal parameters only, so the records of the constructions carry their layer and node counts written out (see
the User's Guide).

## Examples

| Example | What it shows |
|---|---|
| `Examples.FreeFloatingRoom` | The room of BESTEST case 600FF under clear winter days |
| `Examples.IdealHeatingRoom` | The same room heated to 20 °C and cooled to 27 °C by an ideal system |
| `Examples.TwoZones` | Two rooms with an internal wall, a slab on the ground, an on/off and a proportional room controller |
| `Examples.VentilatedRoom` | Balanced ventilation with heat recovery |
| `Examples.BoilerCircuit` | Gas boiler, pump, three-way valve, radiator and thermostatic valve, pressure-driven flows (closed loop) |
| `Examples.BoilerCircuitSetFlows` | The same circuit with set flows, as the model of optimal control has them |
| `Examples.HeatPumpCircuit` | Air-to-water heat pump with its buffer and two radiators |
| `Examples.Photovoltaics` | Arrays facing south and west |

The `Validation` packages of `Utilities`, `Envelope` and `Controls` exercise the smooth functions, the schedules, the
gas gaps, the overhangs and side fins, the hysteresis and the PI controller. Every example translates with rumoca,
and its CasADi model integrated by CVODES follows the OpenModelica results within 0.01 K on the rooms.

## License

BSD 3-Clause; the portions that follow the Modelica Buildings Library carry its license too (see
[`LICENSE`](https://github.com/andoludo/FastSmoothBuildings/blob/main/LICENSE)).
