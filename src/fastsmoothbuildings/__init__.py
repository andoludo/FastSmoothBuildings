"""FastSmoothBuildings: the Modelica library, and where tools find it.

``LIBRARY`` is the folder of the library, to pass to rumoca (``rumoca.Session(roots=[str(LIBRARY)])``: rumoca reads
every Modelica file below a root); ``ROOT`` the folder that holds it, to put on ``MODELICAPATH``; ``bundle()`` the
library as the text of one file, to embed it in a generated model.
"""

from __future__ import annotations

from typing import Final

from fastsmoothbuildings._paths import LIBRARY, NAME, ROOT, modelica_version
from fastsmoothbuildings.bundle import bundle, strip_documentation

__version__: Final = modelica_version(LIBRARY / "package.mo")
__all__ = ["LIBRARY", "NAME", "ROOT", "__version__", "bundle", "strip_documentation"]
