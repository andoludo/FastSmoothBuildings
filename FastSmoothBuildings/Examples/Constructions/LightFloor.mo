within FastSmoothBuildings.Examples.Constructions;
record LightFloor = FastSmoothBuildings.Data.Construction (
  nLay=2,
  x={1.003, 0.025},
  k={0.04, 0.14},
  c={10.0, 1200.0},
  d={10.0, 650.0},
  nSta={1, 1},
  nNod=2,
  lay={1, 2},
  nod={1, 2, 3},
  sub=fill(0, 0),
  absIR_a=0.9,
  absIR_b=0.9,
  absSol_a=0.6,
  absSol_b=0.6) "Light floor of BESTEST case 600: insulation over outdoor air, timber flooring";
