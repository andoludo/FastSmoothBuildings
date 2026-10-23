within FastSmoothBuildings.Hydronics;
partial model PartialFlow
  "Water ports as arrays, one element per connection: the inlets mix, every outlet leaves at TOut; with
   pressure-driven flows, the inlets meet in a pressure node of small compliance"
  parameter Integer nPorts_a = 1 "Number of connections of the inlet";
  parameter Integer nPorts_b = 1 "Number of connections of the outlet";
  parameter Real m_flow_small(unit="kg/s") = 1e-6 "Flow below which the inlet takes the mean inlet temperature";
  parameter Boolean pressureDriven = false
    "true: flows from the pressures of the circuit (closed loop); false: flows set by the valves (optimal control)"
    annotation (Evaluate=true);
  parameter Real tauHyd(unit="s") = 5 "Time constant of the pressure of the inlet node (pressure-driven flows)";
  parameter Real GHyd(unit="kg/(s.Pa)") = 1e-4 "Conductance scaling the compliance of the inlet node";
  Interfaces.WaterInlet port_a[nPorts_a] "Inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.WaterOutlet port_b[nPorts_b] "Outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Real m_flow(unit="kg/s") "Flow through the component";
  Real TIn(unit="K") "Mixed inlet temperature";
  Real TOut(unit="K") "Outlet temperature";
  Real pIn(unit="Pa", start=0, fixed=pressureDriven) "Pressure of the inlet node";
  Real mTra(unit="kg/s") "Flow carrying the inlet water through (its positive part with pressure-driven flows)";
equation
  m_flow = sum(port_a[i].m_flow for i in 1:nPorts_a);
  if pressureDriven then
    // flows may reverse while the pressures settle: the inlets mix with the positive part of their flows
    mTra = Utilities.positivePart(m_flow, m_flow_small);
    TIn = (sum(Utilities.positivePart(port_a[i].m_flow, m_flow_small)*port_a[i].T for i in 1:nPorts_a)
      + m_flow_small*sum(port_a[i].T for i in 1:nPorts_a)/nPorts_a)
      /(sum(Utilities.positivePart(port_a[i].m_flow, m_flow_small) for i in 1:nPorts_a) + m_flow_small);
  else
    mTra = m_flow;
    TIn = (sum(port_a[i].m_flow*port_a[i].T for i in 1:nPorts_a) + m_flow_small*sum(port_a[i].T for i in 1:nPorts_a)
      /nPorts_a)/(m_flow + m_flow_small);
  end if;
  for i in 1:nPorts_b loop
    port_b[i].T = TOut;
  end for;
  for i in 1:nPorts_a loop
    port_a[i].p = pIn;
  end for;
  if pressureDriven then
    tauHyd*GHyd*der(pIn) = m_flow + sum(port_b[i].m_flow for i in 1:nPorts_b);
  else
    pIn = 0;
  end if;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Base class of the water components with one inlet and one outlet. Each port is an array with one element per
connection (<code>nPorts_a</code>, <code>nPorts_b</code>): the inlets mix, every outlet leaves at
<code>TOut</code>, and all inlets share the pressure <code>pIn</code> of the inlet node.
</p>
<h4>Equations</h4>
<p>
Flow through the component, from the inlets: <i>m&#775;</i> = &sum;<sub><i>i</i></sub>
<i>m&#775;<sub>a,i</sub></i> (<code>m_flow</code>).
</p>
<p>
Mixed inlet temperature, with <i>&delta;</i> = <code>m_flow_small</code> and <i>T&#772;<sub>a</sub></i> the mean
of the inlet temperatures:
</p>
<p>
<i>T<sub>in</sub></i> = (&sum;<sub><i>i</i></sub> <i>w<sub>i</sub></i> <i>T<sub>a,i</sub></i> +
<i>&delta;</i> <i>T&#772;<sub>a</sub></i>) / (&sum;<sub><i>i</i></sub> <i>w<sub>i</sub></i> + <i>&delta;</i>),
</p>
<p>
where <i>w<sub>i</sub></i> = <i>m&#775;<sub>a,i</sub></i> with set flows and
<i>w<sub>i</sub></i> = positivePart(<i>m&#775;<sub>a,i</sub></i>, <i>&delta;</i>) with pressure-driven flows.
At zero flow the inlet takes the mean inlet temperature, and <code>TIn</code> stays defined.
</p>
<p>
The flow that carries the inlet water through the component, used by the energy balances of the extending
classes, is <code>mTra</code> = <i>m&#775;</i> with set flows and
positivePart(<i>m&#775;</i>, <i>&delta;</i>) with pressure-driven flows, so that a flow reversing while the
pressures settle carries no water backwards through the balance.
</p>
<h4>Set flows and pressure-driven flows</h4>
<ul>
<li>Set flows (<code>pressureDriven = false</code>): <code>pIn</code> = 0.</li>
<li>Pressure-driven flows: the inlet node is a pressure state of small compliance,
<i>&tau;<sub>hyd</sub></i> <i>G<sub>hyd</sub></i> d<i>p<sub>in</sub></i>/d<i>t</i> = <i>m&#775;</i> +
&sum;<sub><i>j</i></sub> <i>m&#775;<sub>b,j</sub></i>, with <i>&tau;<sub>hyd</sub></i> = <code>tauHyd</code> and
<i>G<sub>hyd</sub></i> = <code>GHyd</code>. When <code>GHyd</code> is the conductance of the outlets, as the
extending classes set it, the pressure of the node settles with the time constant <code>tauHyd</code>.</li>
</ul>
<h4>Extending classes</h4>
<p>
An extending class gives <code>TOut</code> and, with pressure-driven flows, the flow of every outlet
<code>port_b[j].m_flow</code> from <code>pIn</code> and the pressure <code>port_b[j].p</code> of the node
downstream. With set flows it adds the mass balance
(<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialConserving\">PartialConserving</a>), or leaves it to
the circuit when the component is the reference of its circuit
(<a href=\"modelica://FastSmoothBuildings.Hydronics.Boiler\">Boiler</a>,
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPump\">HeatPump</a>).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end PartialFlow;
