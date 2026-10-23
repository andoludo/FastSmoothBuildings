"""The tests of the study need trano and its simulation packages (``uv sync --group study``)."""

from importlib.util import find_spec

collect_ignore_glob = [] if find_spec("trano") and find_spec("trano_simulate") else ["test_*.py"]
