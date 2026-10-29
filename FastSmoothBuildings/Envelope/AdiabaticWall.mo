within FastSmoothBuildings.Envelope;
model AdiabaticWall "Wall without heat flow through its outer surface"
  extends PartialOpaque;
  Real T[nLay + 1](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, outside first";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
equation
  QInt = Functions.interiorConvection(T[nLay + 1] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_a = 0;
  Q_b = propsBus_a.rad.Q_flow - QInt;
  for b in 1:nLay + 1 loop
    TNod[constructionType.nod[b]] = T[b];
    der(T[b]) = QNod[constructionType.nod[b]]/C[constructionType.nod[b]];
  end for;
  propsBus_a.con.Q_flow = -QInt;
  propsBus_a.rad.T = T[nLay + 1];
  propsBus_a.A = A;
  propsBus_a.epsLw = constructionType.absIR_b;
  propsBus_a.absSol = constructionType.absSol_b;
  propsBus_a.tauSol = 0;
  propsBus_a.isFloor = isFloor;
  propsBus_a.QTraDir = 0;
  propsBus_a.QTraDif = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-90,80},{-90,-80}}, color={0,0,0}, thickness=1)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A construction of a zone without heat flow through its outer surface (<code>Q_a</code> = 0): the conduction of
<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a> stores heat and exchanges it with
the room only. All the layer boundaries <code>T[1]</code> to <code>T[nLay + 1]</code> are states.
</p>
<h4>Equations</h4>
<p>
Room surface: <code>Q_b</code> = <i>Q<sub>rad</sub></i> &minus; <i>Q<sub>int</sub></i>, with
<i>Q<sub>rad</sub></i> the radiation the zone gives to the surface and <i>Q<sub>int</sub></i> the convection to the
room air (<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.interiorConvection\">interiorConvection</a>).
On the bus: the room face at <code>T[nLay + 1]</code>, emissivity <code>absIR_b</code>, solar absorptance
<code>absSol_b</code>, no transmission.
</p>
<h4>Use</h4>
<p>
The ceilings of <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end AdiabaticWall;
