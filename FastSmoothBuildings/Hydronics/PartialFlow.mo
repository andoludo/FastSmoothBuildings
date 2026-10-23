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
end PartialFlow;
