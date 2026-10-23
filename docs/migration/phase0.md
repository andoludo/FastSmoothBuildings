# Migration from trano's FastModel, phase 0: trials

Phase 0 of the migration of trano's `FastModel` package (trano/library/FastModel.mo) to the FastSmoothBuildings
library tried the split into the directory layout and its use from OpenModelica and rumoca before anything was
pushed. Source: trano commit c70f8d2 (branch `feat/smooth-controller-parameters`, PR #60), OpenModelica 1.26.9,
rumoca 0.10.3.

## 1. The split

`scripts/migration/split_library.py` renames the package (`FastModel` → `FastSmoothBuildings`; the library refers to itself
by its full name once, `extends FastSmoothBuildings.Icons.Package`, and two description strings name trano's
configurations, now `FastSmoothBuildings` and `FastSmoothBuildingsMPC`) and writes the directory layout of the
Modelica specification (13.4):

* every package that holds a model, block, function, connector or record (directly or below) is a folder with
  `package.mo` and `package.order`: 15 folders;
* every other class of such a package is a file `<name>.mo`: 92 files; `Icons` and `Types` (constants only) stay
  one file each, as in Buildings;
* constants and short classes (`connector RealInput = input Real`) stay in `package.mo`; `package.order` lists
  classes and constants in the order of the source.

`fastsmoothbuildings.bundle.bundle()` writes the folder back as one file (to embed it in a generated model). The
split checks that the bundle gives back the renamed source **character for character**.

## 2. OpenModelica

| Check | Single file | Folder (`MODELICAPATH`) |
|---|---|---|
| messages while loading (missing or extra `package.order` entries) | none | none |
| classes (`getClassNames(recursive=true)`) | 112 | the same 112 |
| `checkModel` of the 38 models and blocks that are not partial | 31 pass | the same output, word for word |

The 7 models that do not check are the walls, the window and the zones: their construction records have no
defaults on purpose (`nLay`, `nPan`, `nSurf` must be literal for rumoca), so they check only inside a model that
gives them a record; phase 1 adds such examples.

The runnable models of four trano inputs, generated with the library embedded and with the library loaded from the
folder, simulated for two days (tolerance 1e-6, 576 intervals) give **the same values for every variable, bit for
bit**:

| Input | Variables |
|---|---|
| tests/models/single_zone_hydronic.yaml | 1634 |
| BESTEST 960 (sun-space) | 2142 |
| examples/residential_before_renovation.yaml | 8116 |
| examples/residential_after_renovation.yaml | 9249 |

## 3. rumoca and CasADi

For six inputs, each as MPC model and as closed-loop model (12 exports), `rumoca.Session().loads` of the model with
the library embedded (as trano writes it) and `rumoca.Session(roots=[...]).loads` of the model with the library
referenced from the folder give the same CasADi model: the same names of states, inputs and parameters, and no
difference in the start states, the parameters and the derivatives at four times of the day.

| Input | MPC: states / inputs / parameters | Closed loop: states / inputs / parameters | Translation, embedded / roots (s) |
|---|---|---|---|
| BESTEST 600FF | 25 / 9 / 550 | 54 / 9 / 782 | 2.9–3.2 / 2.7 |
| BESTEST 630 (overhang, fins) | 27 / 10 / 667 | 60 / 9 / 923 | 4.0–4.3 / 4.0 |
| BESTEST 960 | 42 / 12 / 835 | 96 / 11 / 1259 | 4.1–4.8 / 4.0–4.3 |
| single_zone_hydronic | 27 / 12 / 758 | 52 / 9 / 903 | 6.3–7.0 / 6.8–6.9 |
| residential_after_renovation | 189 / 28 / 4165 | 278 / 19 / 4770 | 43–50 / 45 |
| residential_before_renovation | 160 / 27 / 3544 | 224 / 19 / 3955 | 38 / 40–41 |

Loading from roots costs no time.

### Found: the records name the embedded copy

trano's three data templates (`library.json`, `construction` twice and `glazing`) write
`record x = <package>.FastModel.Data.Construction(...)`: the qualified name of the copy inside the generated
package, the one thing that stops a reference to the library. Written as `FastSmoothBuildings.Data.Construction`,
the name finds the embedded copy first (Modelica looks in the enclosing packages) and the library otherwise: with
the library embedded, the 6 exports tried and the OpenModelica simulation of single_zone_hydronic are identical to
the qualified names. Phase 2 writes the plain name, so that the switch to a reference (phase 3) needs no change of
these templates.

## 4. Documentation

`Utilities.regStep` and `Envelope.Functions.gapConductance` carry a sample of the documentation of phase 4
(purpose, equations as implemented, smoothing, relation to Buildings, validation, references, revisions) in HTML
with tables, sub- and superscripts, entities, escaped quotes and `modelica://` links. The two documented classes
are in [`phase0/`](phase0/), with the documentation of `gapConductance` as a browser shows it
([`phase0/gap_conductance_documentation.png`](phase0/gap_conductance_documentation.png)).

* OpenModelica loads it without a message and `getDocumentationAnnotation` returns it whole (3687 characters for
  `gapConductance`, the quotes unescaped, the links kept);
* rumoca translates the models with it, from the folder and embedded, to the same CasADi model.

A copy with a 3 kB documentation on each of the 107 files (a bundle of 494 896 characters, three times the 163 390
of the library today) measures the cost: OpenModelica loads it, as folder and as one file, and checks every class
as without it; rumoca translates it to the same CasADi model, from the folder and embedded, in the same time
(best of three):

| MPC model | No documentation (roots) | Sample (roots / embedded) | 3 kB on every file (roots / embedded / embedded, stripped) |
|---|---|---|---|
| single_zone_hydronic | 6.3 s | 6.5 / 6.4 s | 6.4 / 6.2 / 6.6 s |
| residential_after_renovation | 42.2 s | 43.3 / 42.5 s | 44.4 / 43.1 / 42.6 s |

`strip_documentation` (the documentation removed from the bundle) gives the same model too, but is not needed for
speed.

### Found: the bundle must put the classes before the annotation of their package

The first bundle put the classes of a folder at the end of its `package.mo`, after the annotation of the package:
not valid Modelica (an annotation ends a class), which rumoca refused once the packages had a `Documentation`.
`bundle()` now inserts them before the annotation; the folder itself was never affected.

## Result

The split, the bundle and both ways of using the library (embedded or referenced) give the same models in
OpenModelica and in CasADi. Phase 1 can create the repository from the split.

Scripts of the trials (outside the repository): `equivalence.py` (rumoca), `om_simulate.py` and the `check_*.mos`
scripts (OpenModelica), `documentation.py` (documentation and timing).
