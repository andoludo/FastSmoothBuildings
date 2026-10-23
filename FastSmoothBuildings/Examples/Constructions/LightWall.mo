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
  absSol_b=0.6) "Light wall of BESTEST case 600: wood siding, fiberglass, plasterboard"
  annotation (Documentation(info="<html>
<p>
The light wall of BESTEST case 600 (ASHRAE Standard 140), a
<a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a> with one sublayer per layer:
</p>
<table summary=\"Layers of LightWall\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Layer, from the outside</th><th><code>x</code> (m)</th><th><code>k</code> (W/(m K))</th>
<th><code>c</code> (J/(kg K))</th><th><code>d</code> (kg/m<sup>3</sup>)</th><th><code>nSta</code></th></tr>
<tr><td>Wood siding</td><td>0.009</td><td>0.14</td><td>900</td><td>530</td><td>1</td></tr>
<tr><td>Fiberglass</td><td>0.066</td><td>0.04</td><td>840</td><td>12</td><td>1</td></tr>
<tr><td>Plasterboard</td><td>0.012</td><td>0.16</td><td>840</td><td>950</td><td>1</td></tr>
</table>
<p>
Long-wave emissivity 0.9 and solar absorptance 0.6 on both sides. The walls of
<a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">FreeFloatingRoom</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: first version.</li>
</ul>
</html>"));
