within FastSmoothBuildings.Data;
record Construction
  "Opaque construction: layers from the outside (side a) to the inside (side b), each split into nSta[i] sublayers
   of equal thickness (Buildings.HeatTransfer.Data.OpaqueConstructions.Generic and its nSta)"
  parameter Integer nLay "Number of layers";
  parameter Real x[nLay](each unit="m") "Thickness";
  parameter Real k[nLay](each unit="W/(m.K)") "Thermal conductivity";
  parameter Real c[nLay](each unit="J/(kg.K)") "Specific heat capacity";
  parameter Real d[nLay](each unit="kg/m3") "Density";
  // the sublayers are written out, without defaults: rumoca sizes arrays and evaluates subscripts from literal
  // parameters only
  parameter Integer nSta[nLay]
    "Sublayers of each layer: the states Buildings gives it, at most 3 (FastSmoothBuildings); 1, a node at each layer
     boundary (FastSmoothBuildingsMPC, whose states are decision variables of the optimal control)";
  parameter Integer nNod "Number of sublayers, the sum of nSta";
  parameter Integer lay[nNod] "Layer of each sublayer, from the outside";
  parameter Integer nod[nLay + 1] "Node of each layer boundary, from the outside (nod[1] = 1)";
  parameter Integer sub[nNod - nLay] "Nodes inside the layers, from the outside";
  parameter Real absIR_a = 0.84 "Long-wave emissivity of side a (outside)";
  parameter Real absIR_b = 0.84 "Long-wave emissivity of side b (inside)";
  parameter Real absSol_a = 0.84 "Solar absorptance of side a (outside)";
  parameter Real absSol_b = 0.84 "Solar absorptance of side b (inside)";
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
An opaque construction: its layers from the outside (side <i>a</i>) to the inside (side <i>b</i>), the split of
each layer into sublayers of equal thickness, and the radiative properties of its two faces. The walls of
<a href=\"modelica://FastSmoothBuildings.Envelope\">Envelope</a> read it
(<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a>).
</p>
<h4>Fields</h4>
<table summary=\"Fields of Construction\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Field</th><th>Meaning</th></tr>
<tr><td><code>nLay</code></td><td>number of layers</td></tr>
<tr><td><code>x</code>, <code>k</code>, <code>c</code>, <code>d</code></td>
<td>thickness, thermal conductivity, specific heat capacity and density of each layer</td></tr>
<tr><td><code>nSta[l]</code></td><td>number of sublayers of layer <i>l</i>: the states Buildings gives it, at most 3,
in the closed-loop model; 1, a node at each layer boundary, in the model for optimal control</td></tr>
<tr><td><code>nNod</code></td><td>number of sublayers, the sum of <code>nSta</code>; there are
<code>nNod</code> + 1 nodes, numbered from the outside</td></tr>
<tr><td><code>lay[j]</code></td><td>the layer of sublayer <i>j</i></td></tr>
<tr><td><code>nod[b]</code></td><td>the node of layer boundary <i>b</i> (<code>nLay</code> + 1 of them,
<code>nod[1]</code> = 1, <code>nod[nLay + 1]</code> = <code>nNod</code> + 1)</td></tr>
<tr><td><code>sub[m]</code></td><td>the nodes inside the layers (<code>nNod</code> &minus; <code>nLay</code> of
them)</td></tr>
<tr><td><code>absIR_a</code>, <code>absIR_b</code></td><td>long-wave emissivity of side <i>a</i> and side
<i>b</i></td></tr>
<tr><td><code>absSol_a</code>, <code>absSol_b</code></td><td>solar absorptance of side <i>a</i> and side
<i>b</i></td></tr>
</table>
<p>
The counts and the indices follow from <code>nSta</code> but are written out, without defaults: rumoca sizes arrays
and evaluates subscripts from literal parameters only (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>). For instance, four
layers with <code>nSta = {2, 2, 3, 1}</code> have <code>nNod = 8</code>,
<code>lay = {1, 1, 2, 2, 3, 3, 3, 4}</code>, <code>nod = {1, 3, 5, 8, 9}</code> and <code>sub = {2, 4, 6, 7}</code>
(<a href=\"modelica://FastSmoothBuildings.Examples.Constructions.CavityWall\">Examples.Constructions.CavityWall</a>);
with one sublayer a layer, <code>nod = {1, 2, ..., nLay + 1}</code> and <code>sub = fill(0, 0)</code>.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</code> and its <code>nSta</code>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Data</code>.</li>
</ul>
</html>"));
end Construction;
