within FastSmoothBuildings.Hydronics;
model Junction2 "Split valve without bypass: its inlets (port_1) mix, its outlets (port_2) leave at the mixed temperature"
  parameter Integer nPorts_1 = 1 "Number of connections of the inlet";
  parameter Integer nPorts_2 = 1 "Number of connections of the outlet";
  parameter Real m_flow_small(unit="kg/s") = 1e-6;
  parameter Boolean pressureDriven = false "true: flows from the pressures of the circuit" annotation (Evaluate=true);
  parameter Real tauHyd(unit="s") = 5 "Time constant of the pressure of the inlet node";
  parameter Real dp_nominal[3](each unit="Pa") = {5000, -1, -1} "Pressure drops of Buildings' Junction";
  parameter Real m_flow_nominal[3](each unit="kg/s") = 0.15*{1, -1, -1} "Nominal flows of Buildings' Junction";
  parameter Real dpLink(unit="Pa") = 1000 "Pressure drop at the nominal flow when dp_nominal[1] is not positive";
  final parameter Real G(unit="kg/(s.Pa)") = abs(m_flow_nominal[1])/max(dp_nominal[1], dpLink)
    "Conductance of each outlet (dp_nominal[1], at least dpLink)";
  Interfaces.WaterInlet port_1[nPorts_1] "Inlets"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.WaterOutlet port_2[nPorts_2] "Outlets"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Real T(unit="K") "Mixed temperature";
  Real pIn(unit="Pa", start=0, fixed=pressureDriven) "Pressure of the inlet node";
equation
  for i in 1:nPorts_1 loop
    port_1[i].p = pIn;
  end for;
  T = if pressureDriven then (sum(Utilities.positivePart(port_1[i].m_flow, m_flow_small)*port_1[i].T
    for i in 1:nPorts_1) + m_flow_small*sum(port_1[i].T for i in 1:nPorts_1)/nPorts_1)
    /(sum(Utilities.positivePart(port_1[i].m_flow, m_flow_small) for i in 1:nPorts_1) + m_flow_small)
    else (sum(port_1[i].m_flow*port_1[i].T for i in 1:nPorts_1) + m_flow_small*sum(port_1[i].T for i in 1:nPorts_1)
    /nPorts_1)/(sum(port_1[i].m_flow for i in 1:nPorts_1) + m_flow_small);
  for i in 1:nPorts_2 loop
    port_2[i].T = T;
  end for;
  if pressureDriven then
    tauHyd*G*nPorts_2*der(pIn) = sum(port_1[i].m_flow for i in 1:nPorts_1) + sum(port_2[i].m_flow for i in 1:nPorts_2);
    for i in 1:nPorts_2 loop
      port_2[i].m_flow = -G*(pIn - port_2[i].p);
    end for;
  else
    pIn = 0;
    sum(port_1[i].m_flow for i in 1:nPorts_1) + sum(port_2[i].m_flow for i in 1:nPorts_2) = 0;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Polygon(points={{-100,-40},{100,-40},{100,40},{-100,40},{-100,-40}}, lineColor={0,0,0},
        fillColor={175,175,175}, fillPattern=FillPattern.Solid),
      Polygon(points={{-100,-22},{100,-22},{100,22},{-100,22},{-100,-22}}, lineColor={0,0,0},
        fillPattern=FillPattern.HorizontalCylinder, fillColor={0,128,255}),
      Ellipse(extent={{-12,12},{12,-12}}, lineColor={0,0,0}, fillColor={0,0,0}, fillPattern=FillPattern.Solid),
      Text(extent={{-151,142},{149,102}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Hydronics.Junction\">Junction</a> without the second outlet: the
connections of the inlet <code>port_1</code> mix, and every connection of the outlet <code>port_2</code> leaves at
the mixed temperature <code>T</code>.
</p>
<h4>Equations</h4>
<p>
Mixed temperature, with <i>&delta;</i> = <code>m_flow_small</code> and <i>T&#772;<sub>1</sub></i> the mean of the
inlet temperatures:
</p>
<p>
<i>T</i> = (&sum;<sub><i>i</i></sub> <i>w<sub>i</sub></i> <i>T<sub>1,i</sub></i> + <i>&delta;</i>
<i>T&#772;<sub>1</sub></i>) / (&sum;<sub><i>i</i></sub> <i>w<sub>i</sub></i> + <i>&delta;</i>),
</p>
<p>
where <i>w<sub>i</sub></i> is the inlet flow with set flows and its positive part with pressure-driven flows.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, the junction conserves mass, &sum; <code>port_1.m_flow</code> + &sum; <code>port_2.m_flow</code> =
0. With pressure-driven flows, the inlet is a pressure node of small compliance and each outlet connection has the
linear conductance <i>G</i> = |<code>m_flow_nominal[1]</code>| / max(<code>dp_nominal[1]</code>,
<code>dpLink</code>):
</p>
<p>
<code>port_2[j].m_flow</code> = &minus;<i>G</i> (<i>p<sub>in</sub></i> &minus; <i>p<sub>2,j</sub></i>),
&nbsp; <i>&tau;<sub>hyd</sub></i> <i>G</i> <i>n<sub>2</sub></i> d<i>p<sub>in</sub></i>/d<i>t</i> =
&sum; <code>port_1.m_flow</code> + &sum; <code>port_2.m_flow</code>.
</p>
<p>
Only <code>dp_nominal[1]</code> and <code>m_flow_nominal[1]</code> enter the equations, as in
<a href=\"modelica://FastSmoothBuildings.Hydronics.Junction\">Junction</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end Junction2;
