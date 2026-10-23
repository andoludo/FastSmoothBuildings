within FastSmoothBuildings.Examples.Constructions;
record CavityWall = FastSmoothBuildings.Data.Construction (
  nLay=4,
  x={0.08, 0.1, 0.14, 0.015},
  k={0.89, 0.035, 0.3, 0.38},
  c={800.0, 800.0, 880.0, 840.0},
  d={1920.0, 100.0, 850.0, 1120.0},
  nSta={2, 2, 3, 1},
  nNod=8,
  lay={1, 1, 2, 2, 3, 3, 3, 4},
  nod={1, 3, 5, 8, 9},
  sub={2, 4, 6, 7},
  absIR_a=0.88,
  absIR_b=0.85,
  absSol_a=0.55,
  absSol_b=0.65) "Insulated cavity wall: brick, insulation, block, plaster; the layers split into sublayers";
