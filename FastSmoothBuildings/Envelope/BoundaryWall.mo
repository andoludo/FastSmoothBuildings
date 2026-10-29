within FastSmoothBuildings.Envelope;
model BoundaryWall "Floor on ground or over outdoor air: the outer surface is held at a temperature"
  extends PartialOpaque(final stateAtSurface_a=false);
  parameter Boolean outdoorAir = false "true: the outer surface at the outdoor air temperature";
  parameter Real TGro(unit="K") = 283.15 "Ground temperature";
  Real T[nLay](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, the outer surface excluded";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
equation
  TNod[1] = if outdoorAir then propsBus_a.wea.TDryBul else TGro;
  // the outer surface is held at its temperature: its balance is not solved
  Q_a = 0;
  QInt = Functions.interiorConvection(T[nLay] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_b = propsBus_a.rad.Q_flow - QInt;
  for b in 2:nLay + 1 loop
    TNod[constructionType.nod[b]] = T[b - 1];
    der(T[b - 1]) = QNod[constructionType.nod[b]]/C[constructionType.nod[b]];
  end for;
  propsBus_a.con.Q_flow = -QInt;
  propsBus_a.rad.T = T[nLay];
  propsBus_a.A = A;
  propsBus_a.epsLw = constructionType.absIR_b;
  propsBus_a.absSol = constructionType.absSol_b;
  propsBus_a.tauSol = 0;
  propsBus_a.isFloor = isFloor;
  propsBus_a.QTraDir = 0;
  propsBus_a.QTraDif = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-80},{-80,-100}}, lineColor={127,0,0}, fillColor={127,0,0},
        fillPattern=FillPattern.Backward)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Floor on the ground or over outdoor air: the conduction of
<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a> with the outer surface held at a
temperature, the ground temperature <code>TGro</code> or, with <code>outdoorAir = true</code>, the outdoor dry-bulb
temperature.
</p>
<h4>Equations</h4>
<p>
The outer surface (node 1) is not a state: its temperature is set and its balance is not solved
(<code>Q_a</code> = 0, the heat to the ground is not computed). The other layer boundaries are states,
<code>T[1]</code> to <code>T[nLay]</code> being the boundaries 2 to <code>nLay</code> + 1 of the construction; the
room surface is <code>T[nLay]</code>.
</p>
<p>
Room surface: <code>Q_b</code> = <i>Q<sub>rad</sub></i> &minus; <i>Q<sub>int</sub></i>, with
<i>Q<sub>rad</sub></i> the radiation the zone gives to the surface and <i>Q<sub>int</sub></i> the convection to the
room air (<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.interiorConvection\">interiorConvection</a>).
On the bus: emissivity <code>absIR_b</code>, solar absorptance <code>absSol_b</code>, no transmission.
</p>
<h4>Parameters</h4>
<ul>
<li><code>TGro</code>: a constant ground temperature, under the layers of the construction.</li>
</ul>
<h4>Use</h4>
<p>
The floors of <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end BoundaryWall;
