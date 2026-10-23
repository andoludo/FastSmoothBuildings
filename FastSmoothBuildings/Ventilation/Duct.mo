within FastSmoothBuildings.Ventilation;
model Duct "Duct carrying y*m_flow_nominal: y is the relative speed of the fan of its unit"
  parameter Integer nPorts_a = 1 "Number of connections of the inlet";
  parameter Integer nPorts_b = 1 "Number of connections of the outlet";
  parameter Real m_flow_nominal(unit="kg/s") "Nominal flow";
  AirInlet port_a[nPorts_a]
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  AirOutlet port_b[nPorts_b]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Real m_flow(unit="kg/s") "Flow through the duct";
equation
  m_flow = sum(port_a[i].m_flow for i in 1:nPorts_a);
  m_flow = port_a[1].y*m_flow_nominal;
  m_flow + sum(port_b[i].m_flow for i in 1:nPorts_b) = 0;
  for i in 1:nPorts_b loop
    port_b[i].T = port_a[1].T;
    port_b[i].y = port_a[1].y;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,40},{100,-40}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={192,192,192}),
      Rectangle(extent={{-100,22},{100,-24}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={0,127,0}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A duct of a balanced ventilation: it carries its nominal flow times the relative speed of the fan of its unit, read
from its inlet, without heat losses or pressure.
</p>
<h4>Equations</h4>
<p>
<i>&#7745;</i> = &sum; <code>port_a[i].m_flow</code> = <code>port_a[1].y</code> <i>&#7745;<sub>nominal</sub></i>,
&nbsp; &sum; <code>port_b[i].m_flow</code> = &minus;<i>&#7745;</i>,
</p>
<p>
and every outlet carries the temperature and the speed of the first inlet connection: <code>port_b[i].T</code> =
<code>port_a[1].T</code>, <code>port_b[i].y</code> = <code>port_a[1].y</code>.
</p>
<h4>Parameters</h4>
<p>
<code>m_flow_nominal</code>, the flow at full speed; <code>nPorts_a</code> = 1 and <code>nPorts_b</code> = 1, the
numbers of connections of the inlet and of the outlet.
</p>
<h4>Use</h4>
<p>
Between a <a href=\"modelica://FastSmoothBuildings.Ventilation.HeatRecoveryUnit\">HeatRecoveryUnit</a> and a
<a href=\"modelica://FastSmoothBuildings.Zones.VentilatedZone\">Zones.VentilatedZone</a>, for the supply and for the
extract air, as in <a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">Examples.VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Ventilation</code>.</li>
</ul>
</html>"));
end Duct;
