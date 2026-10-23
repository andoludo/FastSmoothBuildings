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
  absSol_b=0.65) "Insulated cavity wall: brick, insulation, block, plaster; the layers split into sublayers"
  annotation (Documentation(info="<html>
<p>
An insulated cavity wall, a <a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a>:
</p>
<table summary=\"Layers of CavityWall\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Layer, from the outside</th><th><code>x</code> (m)</th><th><code>k</code> (W/(m K))</th>
<th><code>c</code> (J/(kg K))</th><th><code>d</code> (kg/m<sup>3</sup>)</th><th><code>nSta</code></th></tr>
<tr><td>Brick</td><td>0.08</td><td>0.89</td><td>800</td><td>1920</td><td>2</td></tr>
<tr><td>Insulation</td><td>0.1</td><td>0.035</td><td>800</td><td>100</td><td>2</td></tr>
<tr><td>Block</td><td>0.14</td><td>0.3</td><td>880</td><td>850</td><td>3</td></tr>
<tr><td>Plaster</td><td>0.015</td><td>0.38</td><td>840</td><td>1120</td><td>1</td></tr>
</table>
<p>
The layers are split into 8 sublayers: the layer boundaries are the nodes <code>nod</code> = {1, 3, 5, 8, 9}, the
nodes inside the layers <code>sub</code> = {2, 4, 6, 7} (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>). Long-wave emissivity 0.88 outside,
0.85 inside; solar absorptance 0.55 outside, 0.65 inside. The outer walls and the partition of the hydronic
examples and of <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: first version.</li>
</ul>
</html>"));
