within FastSmoothBuildings.Envelope;
model OuterWall "Exterior wall or roof: wind and sky at the outside, sun, conduction, room exchanges"
  extends PartialOpaque;
  Real T[nLay + 1](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, outside first";
  BoundaryConditions.TiltedSurface sol(final azi=azi, final til=til) "Irradiance on the outer surface"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  Real QSol(unit="W") "Absorbed solar radiation";
  Real QExt(unit="W") "Heat from the outer surface to the outside air and the sky";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
protected
  parameter Real cExtPos = Utilities.convectionCoefficient(pi - til, true) "Outer face: tilt pi - til";
  parameter Real cExtNeg = Utilities.convectionCoefficient(pi - til, false);
equation
  connect(propsBus_a.wea, sol.weaBus);
  QSol = constructionType.absSol_a*A*(sol.HDir + sol.HDif);
  QExt = Functions.exteriorExchange(T[1], A, til, azi, cExtPos, cExtNeg, constructionType.absIR_a, propsBus_a.hConExt,
    propsBus_a.wea.TDryBul, propsBus_a.wea.TBlaSky, propsBus_a.wea.winSpe, propsBus_a.wea.winDir);
  QInt = Functions.interiorConvection(T[nLay + 1] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_a = QSol - QExt;
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
      Ellipse(extent={{-100,100},{-68,68}}, lineColor={255,255,0}, fillColor={255,213,170},
        fillPattern=FillPattern.Sphere)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Exterior wall or roof: the conduction of
<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a> between the sun, the outdoor air
and the sky on the outside and the room on the inside. The layer boundaries <code>T[1]</code> (outer surface) to
<code>T[nLay + 1]</code> (room surface) are states.
</p>
<h4>Equations</h4>
<p>
Outer surface: <code>Q_a</code> = <i>Q<sub>sol</sub></i> &minus; <i>Q<sub>ext</sub></i>, with the absorbed sun
</p>
<p>
<i>Q<sub>sol</sub></i> = <i>&alpha;<sub>a</sub></i> <i>A</i> (<i>H<sub>dir</sub></i> + <i>H<sub>dif</sub></i>),
</p>
<p>
<i>&alpha;<sub>a</sub></i> = <code>absSol_a</code> of the construction and the irradiance from
<a href=\"modelica://FastSmoothBuildings.BoundaryConditions.TiltedSurface\">TiltedSurface</a>, and the heat to the
outdoor air and the sky <i>Q<sub>ext</sub></i> from
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.exteriorExchange\">exteriorExchange</a> (emissivity
<code>absIR_a</code>; the natural convection coefficients of the outer face, which faces the other way, at the tilt
&pi; &minus; <code>til</code>).
</p>
<p>
Room surface: <code>Q_b</code> = <i>Q<sub>rad</sub></i> &minus; <i>Q<sub>int</sub></i>, with
<i>Q<sub>rad</sub></i> the long-wave and solar radiation the zone gives to the surface (<code>propsBus_a.rad</code>)
and <i>Q<sub>int</sub></i> the convection to the room air from
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.interiorConvection\">interiorConvection</a>.
</p>
<p>
On the bus: the room face at <code>T[nLay + 1]</code>, emissivity <code>absIR_b</code>, solar absorptance
<code>absSol_b</code>, no transmission.
</p>
<h4>Use</h4>
<p>
The walls and the roof of
<a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">Examples.FreeFloatingRoom</a>. The convection
coefficients may be fixed by the zone (<code>hConExt</code>, <code>hConInt</code> on the bus).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end OuterWall;
