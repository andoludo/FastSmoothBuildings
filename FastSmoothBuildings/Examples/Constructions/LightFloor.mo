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
  absSol_b=0.6) "Light floor of BESTEST case 600: insulation over outdoor air, timber flooring"
  annotation (Documentation(info="<html>
<p>
The light floor of BESTEST case 600 (ASHRAE Standard 140) over outdoor air, a
<a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a> with one sublayer
per layer:
</p>
<table summary=\"Layers of LightFloor\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Layer, from the outside</th><th><code>x</code> (m)</th><th><code>k</code> (W/(m K))</th>
<th><code>c</code> (J/(kg K))</th><th><code>d</code> (kg/m<sup>3</sup>)</th><th><code>nSta</code></th></tr>
<tr><td>Insulation</td><td>1.003</td><td>0.04</td><td>10</td><td>10</td><td>1</td></tr>
<tr><td>Timber flooring</td><td>0.025</td><td>0.14</td><td>1200</td><td>650</td><td>1</td></tr>
</table>
<p>
Long-wave emissivity 0.9 and solar absorptance 0.6 on both sides. The floor of
<a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">FreeFloatingRoom</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: first version.</li>
</ul>
</html>"));
