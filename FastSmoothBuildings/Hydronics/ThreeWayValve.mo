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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end ThreeWayValve;
