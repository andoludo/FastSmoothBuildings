within FastSmoothBuildings.Hydronics;
model ThreeWayValve
  "Mixing valve: the share y of the outlet flow comes from port_1 (supply), 1 - y from port_3 (set flows), or
   Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear, linearized: port_1 equal-percentage on y,
   port_3 linear on 1 - y (pressure-driven flows)"
  parameter Integer nPorts_1 = 1 "Number of connections of the supply inlet";
  parameter Integer nPorts_2 = 1 "Number of connections of the outlet";
  parameter Integer nPorts_3 = 1 "Number of connections of the bypass inlet";
  parameter Real m_flow_nominal(unit="kg/s") = 1 "Nominal flow";
  parameter Real m_flow_small(unit="kg/s") = 1e-6;
  parameter Boolean pressureDriven = false "true: flows from the pressures of the circuit" annotation (Evaluate=true);
  parameter Real tauHyd(unit="s") = 5 "Time constant of the pressure of the inlet nodes";
  parameter Real dpValve_nominal(unit="Pa") = 6000 "Pressure drop of the open path at the nominal flow";
  parameter Real dpFixed_nominal[2](each unit="Pa") = {0, 0} "Pressure drops in series with port_1 and port_3";
  parameter Real fraK = 0.7 "Kv of the bypass path relative to the supply path";
  parameter Real R = 50 "Rangeability";
  parameter Real l[2] = {0.01, 0.01} "Leakages of the supply and bypass paths";
  parameter Real delta0 = 0.01 "Linear range of the characteristic near closure";
  final parameter Real G1Nom(unit="kg/(s.Pa)") = m_flow_nominal/(dpValve_nominal + dpFixed_nominal[1])
    "Conductance of the open supply path";
  final parameter Real G3Nom(unit="kg/(s.Pa)") = m_flow_nominal/(dpValve_nominal/fraK^2 + dpFixed_nominal[2])
    "Conductance of the open bypass path";
  Interfaces.WaterInlet port_1[nPorts_1] "Supply inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.WaterOutlet port_2[nPorts_2] "Mixed outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.WaterInlet port_3[nPorts_3] "Bypass inlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Interfaces.RealInput y(unit="1") "Share of the supply (set flows), or opening of the supply path, 0 to 1"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120})));
  Real m_flow(unit="kg/s") "Outlet flow";
  Real m1(unit="kg/s") "Flow of the supply path";
  Real m3(unit="kg/s") "Flow of the bypass path";
  Real T1(unit="K") "Supply temperature";
  Real T3(unit="K") "Bypass temperature";
  Real p1(unit="Pa", start=0, fixed=pressureDriven) "Pressure of the supply inlet node";
  Real p3(unit="Pa", start=0, fixed=pressureDriven) "Pressure of the bypass inlet node";
  Real G1(unit="kg/(s.Pa)") "Conductance of the supply path";
  Real G3(unit="kg/(s.Pa)") "Conductance of the bypass path";
protected
  Real ys = Utilities.smoothLimit(y, 0, 1, 1e-3);
  Real p2 = sum(port_2[i].p for i in 1:nPorts_2)/nPorts_2 "Pressure of the outlet node";
equation
  m_flow = -sum(port_2[i].m_flow for i in 1:nPorts_2);
  for i in 1:nPorts_1 loop
    port_1[i].p = p1;
  end for;
  for i in 1:nPorts_3 loop
    port_3[i].p = p3;
  end for;
  if pressureDriven then
    T1 = (sum(Utilities.positivePart(port_1[i].m_flow, m_flow_small)*port_1[i].T for i in 1:nPorts_1)
      + m_flow_small*sum(port_1[i].T for i in 1:nPorts_1)/nPorts_1)
      /(sum(Utilities.positivePart(port_1[i].m_flow, m_flow_small) for i in 1:nPorts_1) + m_flow_small);
    T3 = (sum(Utilities.positivePart(port_3[i].m_flow, m_flow_small)*port_3[i].T for i in 1:nPorts_3)
      + m_flow_small*sum(port_3[i].T for i in 1:nPorts_3)/nPorts_3)
      /(sum(Utilities.positivePart(port_3[i].m_flow, m_flow_small) for i in 1:nPorts_3) + m_flow_small);
    G1 = Utilities.valveConductance(Utilities.equalPercentage(ys, R, l[1], delta0), m_flow_nominal,
      dpValve_nominal, dpFixed_nominal[1]);
    G3 = Utilities.valveConductance(l[2] + (1 - ys)*(1 - l[2]), m_flow_nominal, dpValve_nominal/fraK^2,
      dpFixed_nominal[2]);
    m1 = G1*(p1 - p2);
    m3 = G3*(p3 - p2);
    tauHyd*G1Nom*der(p1) = sum(port_1[i].m_flow for i in 1:nPorts_1) - m1;
    tauHyd*G3Nom*der(p3) = sum(port_3[i].m_flow for i in 1:nPorts_3) - m3;
    for i in 1:nPorts_2 loop
      port_2[i].m_flow = -(m1 + m3)/nPorts_2;
      port_2[i].T = (Utilities.positivePart(m1, 1e-5)*T1 + Utilities.positivePart(m3, 1e-5)*T3)
        /(Utilities.positivePart(m1, 1e-5) + Utilities.positivePart(m3, 1e-5));
    end for;
  else
    G1 = 0;
    G3 = 0;
    p1 = 0;
    p3 = 0;
    T1 = (sum(port_1[i].m_flow*port_1[i].T for i in 1:nPorts_1) + m_flow_small*sum(port_1[i].T for i in 1:nPorts_1)
      /nPorts_1)/(sum(port_1[i].m_flow for i in 1:nPorts_1) + m_flow_small);
    T3 = (sum(port_3[i].m_flow*port_3[i].T for i in 1:nPorts_3) + m_flow_small*sum(port_3[i].T for i in 1:nPorts_3)
      /nPorts_3)/(sum(port_3[i].m_flow for i in 1:nPorts_3) + m_flow_small);
    m1 = sum(port_1[i].m_flow for i in 1:nPorts_1);
    m3 = sum(port_3[i].m_flow for i in 1:nPorts_3);
    m1 + m3 = m_flow;
    m1 = y*m_flow;
    for i in 1:nPorts_2 loop
      port_2[i].T = y*T1 + (1 - y)*T3;
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,40},{100,-40}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={192,192,192}),
      Rectangle(extent={{-100,22},{100,-22}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={0,127,255}),
      Rectangle(extent={{-60,40},{60,-40}}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Polygon(points={{0,0},{-76,60},{-76,-60},{0,0}}, lineColor={0,0,0}, fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{0,0},{76,60},{76,-60},{0,0}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-40,-56},{40,-100}}, lineColor={0,0,0}, fillPattern=FillPattern.VerticalCylinder,
        fillColor={192,192,192}),
      Rectangle(extent={{-22,-56},{22,-100}}, lineColor={0,0,0}, fillPattern=FillPattern.VerticalCylinder,
        fillColor={0,127,255}),
      Polygon(points={{0,0},{60,-76},{-60,-76},{0,0}}, lineColor={0,0,0}, fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Line(points={{0,40},{0,0}}),
      Line(points={{0,100},{0,40}}),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Mixing valve: the outlet <code>port_2</code> takes water from the supply inlet <code>port_1</code> and from the
bypass inlet <code>port_3</code>, in the share set by <code>y</code>. The connections of each inlet mix first, at
<i>T<sub>1</sub></i> and <i>T<sub>3</sub></i>, as the inlets of
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialFlow\">PartialFlow</a> do (weighted by the positive parts
of their flows with pressure-driven flows).
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, <i>y</i> is the share of the supply in the outlet flow <i>m&#775;</i>:
</p>
<p>
<i>m&#775;<sub>1</sub></i> = <i>y</i> <i>m&#775;</i>, &nbsp; <i>m&#775;<sub>3</sub></i> = (1 &minus; <i>y</i>)
<i>m&#775;</i>, &nbsp; <i>T<sub>2</sub></i> = <i>y</i> <i>T<sub>1</sub></i> + (1 &minus; <i>y</i>)
<i>T<sub>3</sub></i>,
</p>
<p>
the outlet flow being set downstream, and the pressures <code>p1</code>, <code>p3</code> are 0.
</p>
<p>
With pressure-driven flows, <i>y</i> is the opening of the supply path, limited to [0, 1] by
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a> (<i>y<sub>s</sub></i>). Each path
has the conductance of
<a href=\"modelica://FastSmoothBuildings.Utilities.valveConductance\">valveConductance</a> with its fixed
resistance in series:
</p>
<table summary=\"Paths of the three-way valve\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Path</th><th>Characteristic</th><th>Pressure drop of the open path</th><th>Fixed resistance</th></tr>
<tr><td>supply, <code>port_1</code></td>
<td><a href=\"modelica://FastSmoothBuildings.Utilities.equalPercentage\">equalPercentage</a>(<i>y<sub>s</sub></i>,
<code>R</code>, <code>l[1]</code>, <code>delta0</code>)</td>
<td><code>dpValve_nominal</code></td><td><code>dpFixed_nominal[1]</code></td></tr>
<tr><td>bypass, <code>port_3</code></td>
<td><code>l[2]</code> + (1 &minus; <i>y<sub>s</sub></i>) (1 &minus; <code>l[2]</code>)</td>
<td><code>dpValve_nominal</code>/<code>fraK</code><sup>2</sup></td><td><code>dpFixed_nominal[2]</code></td></tr>
</table>
<p>
Each inlet is a pressure node of small compliance, the outlet takes the mean pressure <i>p<sub>2</sub></i> of
the nodes downstream:
</p>
<p>
<i>m&#775;<sub>1</sub></i> = <i>G<sub>1</sub></i> (<i>p<sub>1</sub></i> &minus; <i>p<sub>2</sub></i>), &nbsp;
<i>m&#775;<sub>3</sub></i> = <i>G<sub>3</sub></i> (<i>p<sub>3</sub></i> &minus; <i>p<sub>2</sub></i>),
</p>
<p>
<i>&tau;<sub>hyd</sub></i> <i>G<sub>1,nom</sub></i> d<i>p<sub>1</sub></i>/d<i>t</i> =
&sum; <code>port_1.m_flow</code> &minus; <i>m&#775;<sub>1</sub></i>, &nbsp;
<i>&tau;<sub>hyd</sub></i> <i>G<sub>3,nom</sub></i> d<i>p<sub>3</sub></i>/d<i>t</i> =
&sum; <code>port_3.m_flow</code> &minus; <i>m&#775;<sub>3</sub></i>,
</p>
<p>
with <code>G1Nom</code> and <code>G3Nom</code> the conductances of the open paths. The outlets share
<i>m&#775;<sub>1</sub></i> + <i>m&#775;<sub>3</sub></i> evenly and leave at the temperature mixed with the
positive parts of the two path flows (positivePart with 10<sup>&minus;5</sup> kg/s).
</p>
<h4>Parameters</h4>
<ul>
<li><code>fraK</code>: <i>K<sub>v</sub></i> of the bypass path relative to the supply path; the open bypass
drops <code>dpValve_nominal</code>/<code>fraK</code><sup>2</sup> at the nominal flow.</li>
<li><code>l</code>: leakages of the supply and bypass paths.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear</code>, its flow laws linearized: the supply
path equal-percentage in <i>y</i>, the bypass path linear in 1 &minus; <i>y</i>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end ThreeWayValve;
