within FastSmoothBuildings.HVAC;
model IdealHeatingCoolingPI
  "Ideal heating and cooling of a zone towards day schedules of set points (trano IdealHeatingCooling): a PI
   controller per mode, limited by the capacities"
  parameter Real TSetHea[:, 2] = [0, 293.15] "Heating set point: time of day [s] and set point [K]";
  parameter Real TSetCoo[:, 2] = [0, 300.15] "Cooling set point: time of day [s] and set point [K]";
  parameter Real QHea_flow_max(unit="W") = 1e6 "Heating capacity";
  parameter Real QCoo_flow_max(unit="W") = 1e6 "Cooling capacity";
  parameter Real k = 0.1 "Gain [1/K]";
  parameter Real Ti(unit="s") = 300 "Integral time";
  parameter Real frad = 0 "Radiant share";
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Real QHea_flow(unit="W") "Heating";
  Real QCoo_flow(unit="W") "Cooling, positive when cooling";
  Real EHea(unit="kWh", start=0, fixed=true) "Heating meter";
  Real ECoo(unit="kWh", start=0, fixed=true) "Cooling meter";
  Controls.PI conHea(k=k, Ti=Ti, e=Utilities.dayTable(Utilities.timeOfDay(time), TSetHea) - heatPortCon.T, enable=1);
  Controls.PI conCoo(k=k, Ti=Ti, e=heatPortCon.T - Utilities.dayTable(Utilities.timeOfDay(time), TSetCoo), enable=1);
equation
  // a saturated mode gives exactly no heat: smoothLimit reaches its bounds (when it saturated at dY, each mode
  // leaked dY*capacity, 1 kW with the 1 MW of BESTEST, into the other)
  QHea_flow = conHea.y*QHea_flow_max;
  QCoo_flow = conCoo.y*QCoo_flow_max;
  der(EHea) = QHea_flow/3.6e6;
  der(ECoo) = QCoo_flow/3.6e6;
  heatPortCon.Q_flow = -(1 - frad)*(QHea_flow - QCoo_flow);
  heatPortRad.Q_flow = -frad*(QHea_flow - QCoo_flow);
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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name"),
      Text(extent={{-80,80},{20,40}}, textColor={0,0,0}, textString="PI")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Ideal heating and cooling of a zone towards day schedules of set points (trano's <code>IdealHeatingCooling</code>):
one <a href=\"modelica://FastSmoothBuildings.Controls.PI\">PI</a> controller per mode, its output the share of the
capacity of that mode, and the energy of each mode metered.
</p>
<h4>Equations</h4>
<p>
With <i>T</i> the temperature of <code>heatPortCon</code> (the zone air) and the set points interpolated in their
day tables by <a href=\"modelica://FastSmoothBuildings.Utilities.dayTable\">dayTable</a>,
</p>
<ul>
<li><code>conHea</code>: error <i>T<sub>SetHea</sub></i>(<i>t</i>) &minus; <i>T</i>, &nbsp;
<i>Q<sub>Hea</sub></i> = <code>conHea.y</code> <i>Q<sub>Hea,max</sub></i>;</li>
<li><code>conCoo</code>: error <i>T</i> &minus; <i>T<sub>SetCoo</sub></i>(<i>t</i>), &nbsp;
<i>Q<sub>Coo</sub></i> = <code>conCoo.y</code> <i>Q<sub>Coo,max</sub></i>;</li>
<li>d<i>E<sub>Hea</sub></i>/d<i>t</i> = <i>Q<sub>Hea</sub></i>/3.6&middot;10<sup>6</sup>, &nbsp;
d<i>E<sub>Coo</sub></i>/d<i>t</i> = <i>Q<sub>Coo</sub></i>/3.6&middot;10<sup>6</sup> (kWh);</li>
<li><code>heatPortCon.Q_flow</code> = &minus;(1 &minus; <i>f<sub>rad</sub></i>) (<i>Q<sub>Hea</sub></i> &minus;
<i>Q<sub>Coo</sub></i>), &nbsp; <code>heatPortRad.Q_flow</code> = &minus;<i>f<sub>rad</sub></i>
(<i>Q<sub>Hea</sub></i> &minus; <i>Q<sub>Coo</sub></i>).</li>
</ul>
<p>
Both controllers are always enabled, their outputs between 0 and 1 by smooth limits that reach their bounds
exactly: a saturated mode gives no heat at all, and the anti-windup keeps its integral from running away while the
other mode works. The schedules are interpolated without events.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of IdealHeatingCoolingPI\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>TSetHea</code></td><td>[0, 293.15]</td>
<td>heating set point: time of day (s) and set point (K)</td></tr>
<tr><td><code>TSetCoo</code></td><td>[0, 300.15]</td>
<td>cooling set point: time of day (s) and set point (K)</td></tr>
<tr><td><code>QHea_flow_max</code>, <code>QCoo_flow_max</code></td><td>10<sup>6</sup> W</td>
<td>heating and cooling capacities</td></tr>
<tr><td><code>k</code></td><td>0.1 1/K</td><td>gain of both controllers</td></tr>
<tr><td><code>Ti</code></td><td>300 s</td><td>integral time of both controllers</td></tr>
<tr><td><code>frad</code></td><td>0</td><td>radiant share</td></tr>
</table>
<p>
The controllers keep the other defaults of <a href=\"modelica://FastSmoothBuildings.Controls.PI\">PI</a>, among
them the half-width <code>dY</code> = 10<sup>&minus;3</sup> of their limits.
</p>
<h4>Use</h4>
<p>
Connect <code>heatPortCon</code> to <code>heaPorAir</code> and <code>heatPortRad</code> to <code>heaPorRad</code>
of a zone; the meters <code>EHea</code> and <code>ECoo</code> give the demands. See
<a href=\"modelica://FastSmoothBuildings.Examples.IdealHeatingRoom\">Examples.IdealHeatingRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.HVAC</code>.</li>
</ul>
</html>"));
end IdealHeatingCoolingPI;
