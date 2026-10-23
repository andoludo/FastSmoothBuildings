within FastSmoothBuildings.Envelope;
partial model PartialOpaque
  "Conduction through the layers of a construction split into sublayers, a node at each sublayer boundary: the
   temperatures of the layer boundaries are T, the same states in FastSmoothBuildings and FastSmoothBuildingsMPC (a state copied
   from one library into the other by its name stays at its place), those of the nodes inside the layers TSub"
  extends PartialSurface;
  parameter Data.Construction constructionType "Construction, layers from the outside";
  parameter Boolean stateAtSurface_a = true "Capacity at the outer surface (false: it is held at a temperature)";
  Real TSub[constructionType.nNod - constructionType.nLay](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the nodes inside the layers, outside first (none with one sublayer a layer)";
protected
  parameter Integer nLay = constructionType.nLay "Number of layers";
  parameter Integer nSub = constructionType.nNod "Number of sublayers, between nSub + 1 nodes";
  parameter Real x[nSub](each unit="m") = {constructionType.x[constructionType.lay[j]]
    /constructionType.nSta[constructionType.lay[j]] for j in 1:nSub} "Thickness of each sublayer";
  parameter Real k[nSub](each unit="W/(m.K)") = {constructionType.k[constructionType.lay[j]] for j in 1:nSub};
  parameter Real c[nSub](each unit="J/(kg.K)") = {constructionType.c[constructionType.lay[j]] for j in 1:nSub};
  parameter Real d[nSub](each unit="kg/m3") = {constructionType.d[constructionType.lay[j]] for j in 1:nSub};
  parameter Real C[nSub + 1](each unit="J/K") = {A*((if i > 1 then x[i - 1]*d[i - 1]*c[i - 1]/2 else 0)
    + (if i <= nSub then x[i]*d[i]*c[i]/2 else 0)) for i in 1:nSub + 1}
    "Capacity of each node: half of each adjacent sublayer";
  parameter Real G[nSub](each unit="W/K") = {A*k[i]/x[i] for i in 1:nSub} "Conductance of each sublayer";
  Real TNod[nSub + 1](each unit="K") "Temperature of every node, outside first";
  Real QNod[nSub + 1](each unit="W") "Heat into every node from its sublayers and, at the surfaces, Q_a and Q_b";
  Real Q_a(unit="W") "Heat into the outer surface from the outside";
  Real Q_b(unit="W") "Heat into the inner surface from the room";
equation
  // the subscripts are bounded in both branches: OpenModelica checks the branch that is not taken
  for j in 1:nSub + 1 loop
    QNod[j] = (if j > 1 then G[max(j - 1, 1)]*(TNod[max(j - 1, 1)] - TNod[j]) else Q_a)
      - (if j <= nSub then G[min(j, nSub)]*(TNod[j] - TNod[min(j + 1, nSub + 1)]) else -Q_b);
  end for;
  for m in 1:nSub - nLay loop
    TNod[constructionType.sub[m]] = TSub[m];
    C[constructionType.sub[m]]*der(TSub[m]) = QNod[constructionType.sub[m]];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{0,80},{80,-80}}, fillColor={175,175,175}, fillPattern=FillPattern.Solid,
        lineColor={175,175,175}),
      Rectangle(extent={{-80,80},{0,-80}}, fillColor={215,215,215}, fillPattern=FillPattern.Solid,
        lineColor={175,175,175}),
      Line(points={{-92,0},{90,0}}, color={0,0,0}, thickness=0.5),
      Line(points={{-18,-40},{-32,-40}}, color={0,0,0}, thickness=0.5),
      Line(points={{-12,-32},{-38,-32}}, color={0,0,0}, thickness=0.5),
      Line(points={{-25,0},{-25,-32}}, color={0,0,0}, thickness=0.5),
      Line(points={{32,-40},{18,-40}}, color={0,0,0}, thickness=0.5),
      Line(points={{38,-32},{12,-32}}, color={0,0,0}, thickness=0.5),
      Line(points={{25,0},{25,-32}}, color={0,0,0}, thickness=0.5),
      Rectangle(extent={{-60,6},{-40,-6}}, lineColor={0,0,0}, lineThickness=0.5, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-10,6},{10,-6}}, lineColor={0,0,0}, lineThickness=0.5, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{40,6},{60,-6}}, lineColor={0,0,0}, lineThickness=0.5, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Conduction through the layers of an opaque construction
(<a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a>), from side <i>a</i> (outside) to
side <i>b</i> (room). Layer <i>l</i> is split into <code>nSta[l]</code> sublayers of equal thickness, with a node at
each sublayer boundary: <code>nSub</code> = <code>nNod</code> sublayers between <code>nSub</code> + 1 nodes, outside
first.
</p>
<h4>Equations</h4>
<p>
Sublayer <i>j</i> of layer <i>l</i> = <code>lay[j]</code> has the thickness
<i>x<sub>j</sub></i> = <i>x<sub>l</sub></i>/<i>nSta<sub>l</sub></i>, the conductance
<i>G<sub>j</sub></i> = <i>A</i> <i>k<sub>j</sub></i>/<i>x<sub>j</sub></i>, and gives half of its capacity to each
of its two nodes:
</p>
<p>
<i>C<sub>i</sub></i> = <i>A</i> (<i>x<sub>i&minus;1</sub></i> <i>d<sub>i&minus;1</sub></i>
<i>c<sub>i&minus;1</sub></i> + <i>x<sub>i</sub></i> <i>d<sub>i</sub></i> <i>c<sub>i</sub></i>)/2,
</p>
<p>
the terms of a sublayer that does not exist left out at the surfaces. The heat into node <i>i</i> is
</p>
<p>
<i>Q<sub>i</sub></i> = <i>G<sub>i&minus;1</sub></i> (<i>T<sub>i&minus;1</sub></i> &minus; <i>T<sub>i</sub></i>)
&minus; <i>G<sub>i</sub></i> (<i>T<sub>i</sub></i> &minus; <i>T<sub>i+1</sub></i>),
</p>
<p>
with <code>Q_a</code>, the heat into the outer surface from the outside, in place of the first term at node 1, and
<code>Q_b</code>, the heat into the inner surface from the room, in place of the second term at the last node. Each
node inside a layer, <code>sub[m]</code>, has the state <code>TSub[m]</code>:
<i>C</i> d<code>TSub[m]</code>/d<i>t</i> = <i>Q</i>.
</p>
<h4>Extending classes</h4>
<p>
They declare the temperatures <code>T</code> of the layer boundaries (nodes <code>nod[b]</code>), with
<i>C</i> d<i>T</i>/d<i>t</i> = <i>Q</i> at each node whose temperature is free, and give <code>Q_a</code> and
<code>Q_b</code> from the exchanges at the two faces. <code>T</code> and <code>TSub</code> keep their names and
places whatever the number of sublayers: with one sublayer a layer (the model for optimal control) there is no
<code>TSub</code> (see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>).
</p>
<h4>Parameters</h4>
<ul>
<li><code>stateAtSurface_a</code>: <code>true</code> when the outer surface has a capacity and a state;
<a href=\"modelica://FastSmoothBuildings.Envelope.BoundaryWall\">BoundaryWall</a>, whose outer surface is held at a
temperature, sets it to <code>false</code>.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
The layers are split into the sublayers Buildings gives them (<code>nSta</code> of
<code>Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</code>), at most three a layer in the closed-loop
model.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end PartialOpaque;
