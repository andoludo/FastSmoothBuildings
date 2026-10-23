within FastSmoothBuildings.HVAC;
model IdealHeatingCooling "Heat flow rate Q_flow (an input), split between the room air and its radiant star"
  parameter Real fraRad = 0 "Radiant share";
  Interfaces.RealInput Q_flow(unit="W") "Heat flow rate, positive for heating"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
equation
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
Ideal heating and cooling given as a heat flow rate: the input <code>Q_flow</code>, positive for heating and
negative for cooling, split between the room air and its radiant star. It has no controller and no limit, so that
the heat flow rate can be a decision of an optimal control problem.
</p>
<h4>Equations</h4>
<p>
<code>heatPortCon.Q_flow</code> = &minus;(1 &minus; <i>f<sub>Rad</sub></i>) <i>Q</i>, &nbsp;
<code>heatPortRad.Q_flow</code> = &minus;<i>f<sub>Rad</sub></i> <i>Q</i>,
</p>
<p>
the ports carrying the heat into the component.
</p>
<h4>Parameters</h4>
<p>
<code>fraRad</code> = 0, the radiant share.
</p>
<h4>Use</h4>
<p>
Connect <code>heatPortCon</code> to <code>heaPorAir</code> and <code>heatPortRad</code> to <code>heaPorRad</code>
of a zone. In <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a> the input is the
output of an <a href=\"modelica://FastSmoothBuildings.Controls.EmissionMonitored\">EmissionMonitored</a> control
times 1500 W.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.HVAC</code>.</li>
</ul>
</html>"));
end IdealHeatingCooling;
