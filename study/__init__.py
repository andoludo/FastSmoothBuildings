"""The study of FastSmoothBuildings against the Buildings library, with the models trano generates.

* :mod:`study.buildings`: the closed loop of both libraries on BESTEST cases and two houses, with perturbations of the
  YAML descriptions (``python -m study.buildings``);
* :mod:`study.replay`: FastSmoothBuildings replaying the controls of a Buildings simulation, and the speed of the
  CasADi model (``python -m study.replay``);
* :mod:`study.analysis`: the reports of the analysis and the scripts that compute their numbers.

The study needs trano, trano-simulate and trano-optimization (``uv sync --group study``) and Docker for the
simulations; the committed results are enough to render the reports.
"""
