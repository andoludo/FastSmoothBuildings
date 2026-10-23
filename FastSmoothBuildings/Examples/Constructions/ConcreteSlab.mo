within FastSmoothBuildings.Examples.Constructions;
record ConcreteSlab = FastSmoothBuildings.Data.Construction (
  nLay=2,
  x={0.125, 0.125},
  k={1.4, 1.4},
  c={900.0, 900.0},
  d={2240.0, 2240.0},
  nSta={2, 2},
  nNod=4,
  lay={1, 1, 2, 2},
  nod={1, 3, 5},
  sub={2, 4},
  absIR_a=0.88,
  absIR_b=0.88,
  absSol_a=0.55,
  absSol_b=0.55) "Concrete slab of 25 cm in two layers of two sublayers";
