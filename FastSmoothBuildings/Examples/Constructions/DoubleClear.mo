within FastSmoothBuildings.Examples.Constructions;
record DoubleClear = FastSmoothBuildings.Data.Glazing (
  nPan=2,
  x={0.003048, 0.003048},
  k={1, 1},
  d={2500.0, 2500.0},
  c={840.0, 840.0},
  xGas={0.012},
  kGas={0.025},
  muGas_a={3.723e-06},
  muGas_b={4.94e-08},
  cGas={1006},
  MGas={0.02886614024},
  epsGap_a={0.84},
  epsGap_b={0.84},
  tau={0.6994906348, 0.6985663928, 0.6953442573, 0.6881649654, 0.6729982693, 0.6406823125, 0.571662531,
    0.4321138593, 0.201136796, 0, 0.5777675151},
  absPan={{0.0967242489, 0.09732302857, 0.09913158935, 0.1021914583, 0.1065974621, 0.112569839, 0.120565793,
    0.1307986831, 0.1371678328, 0, 0.1227196468}, {0.07632331867, 0.07674905803, 0.07799186167, 0.07991551881,
    0.08216023482, 0.08385431212, 0.08303389368, 0.07585615681, 0.05645076246, 0, 0.08526920479}},
  absIR_a=0.84,
  absIR_b=0.84,
  UFra=1.4) "Clear double glazing of BESTEST case 600: two 3 mm panes, 12 mm of air"
  annotation (Documentation(info="<html>
<p>
The clear double glazing of BESTEST case 600 (ASHRAE Standard 140), a
<a href=\"modelica://FastSmoothBuildings.Data.Glazing\">Data.Glazing</a>: two panes of 3.048 mm
(<i>k</i> = 1 W/(m K)) around a gap of 12 mm of air, long-wave emissivity 0.84 on every face. Solar
transmittance 0.699 at normal incidence, 0.578 hemispherical; frame transmittance 1.4 W/(m<sup>2</sup> K).
</p>
<p>
The windows of <a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">FreeFloatingRoom</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: first version.</li>
</ul>
</html>"));
