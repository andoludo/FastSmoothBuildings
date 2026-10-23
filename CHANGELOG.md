# Changelog

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
