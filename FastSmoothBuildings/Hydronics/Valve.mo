within FastSmoothBuildings.Hydronics;
model Valve
  "Two-way valve: sets the flow of its branch to y*m_flow_nominal (set flows), or opens to y as
   Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage, linearized (pressure-driven flows)"
  extends PartialConserving(final GHyd=GNom);
  parameter Real m_flow_nominal(unit="kg/s") "Nominal flow";
  parameter Real dpValve_nominal(unit="Pa") = 1e4 "Pressure drop of the open valve at the nominal flow";
  parameter Real dpFixed_nominal(unit="Pa") = 0 "Pressure drop of the pipes in series at the nominal flow";
  parameter Real R = 50 "Rangeability";
  parameter Real l = 1e-4 "Leakage";
  parameter Real delta0 = 0.01 "Linear range of the characteristic near closure";
  final parameter Real GNom(unit="kg/(s.Pa)") = m_flow_nominal/(dpValve_nominal + dpFixed_nominal)
    "Conductance of the open valve and its pipes";
  Interfaces.RealInput y(unit="1") "Flow relative to the nominal flow (set flows), or opening (pressure-driven)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120})));
  Real G(unit="kg/(s.Pa)") "Conductance (pressure-driven flows)";
equation
  TOut = TIn;
  if pressureDriven then
    G = Utilities.valveConductance(Utilities.equalPercentage(Utilities.smoothLimit(y, 0, 1, 1e-3), R, l, delta0),
      m_flow_nominal, dpValve_nominal, dpFixed_nominal);
    for i in 1:nPorts_b loop
      port_b[i].m_flow = -G/nPorts_b*(pIn - port_b[i].p);
    end for;
  else
    G = 0;
    m_flow = y*m_flow_nominal;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,40},{100,-40}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={192,192,192}),
      Rectangle(extent={{-100,22},{100,-24}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={0,127,255}),
      Rectangle(extent={{-60,40},{60,-40}}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Polygon(points={{0,0},{-76,60},{-76,-60},{0,0}}, lineColor={0,0,0}, fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{0,0},{76,60},{76,-60},{0,0}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(points={{0,40},{0,0}}),
      Line(points={{0,100},{0,40}}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end Valve;
