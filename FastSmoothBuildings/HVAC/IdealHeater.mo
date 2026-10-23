within FastSmoothBuildings.HVAC;
model IdealHeater
  "Ideal emitter (trano radiator variants ideal and idealbus): Q_flow_nominal times the control y, split between
   the room air and its radiant star"
  parameter Real Q_flow_nominal(unit="W") "Nominal power";
  parameter Real fraRad = 0 "Radiant share";
  Interfaces.RealInput y(unit="1") "Share of the nominal power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Real Q_flow(unit="W") "Heat flow rate";
equation
  // no heat at y <= 0, the nominal power at y >= 1: smoothLimit reaches its bounds exactly
  Q_flow = Q_flow_nominal*Utilities.smoothLimit(y, 0, 1, 1e-3);
  heatPortCon.Q_flow = -(1 - fraRad)*Q_flow;
  heatPortRad.Q_flow = -fraRad*Q_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-60,-20},{40,-20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-60,20},{40,20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-80,0},{-60,-20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-80,0},{-60,20}}, color={191,0,0}, thickness=0.5),
      Polygon(points={{40,0},{40,40},{70,20},{40,0}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{40,-40},{40,0},{70,-20},{40,-40}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{70,40},{90,-40}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
An ideal emitter (trano's radiator variants <code>ideal</code> and <code>idealbus</code>): the nominal power times
the control signal, without water or inertia, split between the room air and its radiant star.
</p>
<h4>Equations</h4>
<p>
<i>Q</i> = <i>Q<sub>nominal</sub></i> smoothLimit(<i>y</i>, 0, 1, 10<sup>&minus;3</sup>),
</p>
<p>
<code>heatPortCon.Q_flow</code> = &minus;(1 &minus; <i>f<sub>Rad</sub></i>) <i>Q</i>, &nbsp;
<code>heatPortRad.Q_flow</code> = &minus;<i>f<sub>Rad</sub></i> <i>Q</i>.
</p>
<p>
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a> reaches its bounds exactly: no heat
at <i>y</i> &le; 0, the nominal power at <i>y</i> &ge; 1. Its half-width 10<sup>&minus;3</sup> is fixed. The ports
carry the heat into the component, hence the signs: the heat leaves the emitter into the room.
</p>
<h4>Parameters</h4>
<p>
<code>Q_flow_nominal</code>, the nominal power; <code>fraRad</code> = 0, the radiant share.
</p>
<h4>Use</h4>
<p>
Connect <code>heatPortCon</code> to <code>heaPorAir</code> and <code>heatPortRad</code> to <code>heaPorRad</code>
of a zone (<a href=\"modelica://FastSmoothBuildings.Zones.Zone\">Zones.Zone</a>), and <code>y</code> to an emission
control such as <a href=\"modelica://FastSmoothBuildings.Controls.EmissionOnOff\">EmissionOnOff</a>, as in
<a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.HVAC</code>.</li>
</ul>
</html>"));
end IdealHeater;
