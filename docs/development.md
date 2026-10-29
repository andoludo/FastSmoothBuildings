# Development


```bash
uv sync                          # Python environment with rumoca and CasADi
uv run pytest                    # structure, bundle and rumoca tests
uv run pytest -m openmodelica    # simulations of the examples in OpenModelica (Docker)
uv run ruff check . && uv run ruff format --check . && uv run mypy
```

The OpenModelica tests run the examples in the official image `openmodelica/openmodelica:v1.26.9-ompython` and
compare them with `FastSmoothBuildings/Resources/ReferenceResults/OpenModelica`; `uv run pytest -m openmodelica
--update-references` rewrites the references after a deliberate change. The rumoca tests integrate the CasADi models
and compare them with the same references, without Docker.

## Releasing

A change merged into `main` is released once CI passes on it when it changes what users install: the library, the
Python package, `pyproject.toml`, `README.md` or `LICENSE` (changes to the tests, the study, the documentation site or
CI wait for the next such change, as semantic versioning has it). The release workflow tags the version of
`FastSmoothBuildings/package.mo` when it has no tag yet (the first release, or a version raised by hand in a pull
request), and otherwise raises the minor version and commits it (`python scripts/bump_version.py minor`). The tag
publishes the wheel and the sdist on PyPI and creates the GitHub release with the library as a zip for OpenModelica
and Dymola; its notes are the section of the version in `CHANGELOG.md`, or the commits since the previous release.
The workflow uses the repository secrets `ACCESS_TOKEN` (a personal access token that may push to the repository) and
`PYPI_API_TOKEN` (a PyPI API token), as trano does.


## The study

The study against Buildings (`study/`) runs the models trano generates from the YAML descriptions of BESTEST cases and
two houses, with Buildings and with FastSmoothBuildings, in OpenModelica:

```bash
uv sync --group study                                   # trano, trano-simulate, trano-optimization
uv run python -m study.buildings run 950FF              # both libraries, every variant of a case (Docker)
uv run python -m study.buildings report --docs          # the page "Against Buildings" from the committed results
uv run python -m study.replay compare residential_after # FastSmoothBuildings replaying the controls of Buildings
uv run python -m study.analysis.scripts.study_responses # the numbers of a report of the analysis
```

The simulations need Docker and the Modelica libraries of trano (`TRANO_MODELICA_LIBRARIES`); the results are committed
(`study/buildings/results`, `study/analysis/results`), so the reports and the pages render without them. The workflow
`study.yaml` runs the study on demand, or on a push whose commit message carries `[study]`, and commits its results.

## The documentation

```bash
uv sync --group docs
uv run mkdocs serve
```

The pages of the library are generated from the `Documentation` annotations of its classes (`docs/gen_pages.py`), the
pages of the analysis from `study/analysis`. The workflow `docs.yaml` publishes the site on GitHub Pages.
