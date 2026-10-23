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
  absSol_b=0.55) "Concrete slab of 25 cm in two layers of two sublayers"
  annotation (Documentation(info="<html>
<p>
A concrete slab of 25 cm, a <a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a> of two
equal layers of two sublayers each:
</p>
<table summary=\"Layers of ConcreteSlab\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Layer, from the outside</th><th><code>x</code> (m)</th><th><code>k</code> (W/(m K))</th>
<th><code>c</code> (J/(kg K))</th><th><code>d</code> (kg/m<sup>3</sup>)</th><th><code>nSta</code></th></tr>
<tr><td>Concrete</td><td>0.125</td><td>1.4</td><td>900</td><td>2240</td><td>2</td></tr>
<tr><td>Concrete</td><td>0.125</td><td>1.4</td><td>900</td><td>2240</td><td>2</td></tr>
</table>
<p>
Layer boundaries at the nodes <code>nod</code> = {1, 3, 5}, nodes inside the layers <code>sub</code> = {2, 4} (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>). Long-wave emissivity 0.88 and
solar absorptance 0.55 on both sides. The floor of the hydronic
examples, the floors and ceilings of <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: first version.</li>
</ul>
</html>"));
