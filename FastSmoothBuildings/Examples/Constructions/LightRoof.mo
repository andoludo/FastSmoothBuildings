within FastSmoothBuildings.Examples.Constructions;
record LightRoof = FastSmoothBuildings.Data.Construction (
  nLay=3,
  x={0.019, 0.1118, 0.01},
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
  absSol_b=0.6) "Light roof of BESTEST case 600: roof deck, fiberglass, plasterboard";
