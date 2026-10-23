within FastSmoothBuildings.Examples.Constructions;
record LightWall = FastSmoothBuildings.Data.Construction (
  nLay=3,
  x={0.009, 0.066, 0.012},
  k={0.14, 0.04, 0.16},
  c={900.0, 840.0, 840.0},
  d={530.0, 12.0, 950.0},
  nSta={1, 1, 1},
  nNod=3,
  lay={1, 2, 3},
  nod={1, 2, 3, 4},
  sub=fill(0, 0),
  absIR_a=0.9,
  absIR_b=0.9,
  absSol_a=0.6,
  absSol_b=0.6) "Light wall of BESTEST case 600: wood siding, fiberglass, plasterboard";
