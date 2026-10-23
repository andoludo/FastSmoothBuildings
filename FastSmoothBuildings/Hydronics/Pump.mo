within FastSmoothBuildings.Hydronics;
model Pump
  "Pump: pass-through with set flows; with pressure-driven flows, the flow at its head from the curve of
   Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y (1.14, 1 and 0.42 times dp_nominal at 0, 1 and 2 times
   the nominal flow), scaled to the speed y by the affinity laws"
  extends PartialConserving(final GHyd=m_flow_nominal/dp_nominal);
  parameter Real dp_nominal(unit="Pa") = 3e4 "Pressure head at the nominal flow";
  parameter Real m_flow_nominal(unit="kg/s") = 1 "Nominal flow";
  parameter Real eta = 0.5 "Overall efficiency";
  Interfaces.RealInput y(unit="1") "Relative speed (pressure-driven flows)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120})));
  Real dp(unit="Pa") "Head";
  Real P(unit="W") "Electrical power";
protected
  constant Real a = 1.14 "Head at zero flow, relative";
  constant Real b = 0.08 "Quadratic fit of the curve through (0, 1.14), (1, 1), (2, 0.42)";
  constant Real c = -0.22;
  Real x[nPorts_b] "Flow of each outlet relative to y*m_flow_nominal/nPorts_b";
equation
  TOut = TIn;
  dp = sum(port_b[i].p for i in 1:nPorts_b)/nPorts_b - pIn;
  if pressureDriven then
    for i in 1:nPorts_b loop
      // beyond the shut-off head the flow stays at the top of the curve: the root takes a positive argument
      x[i] = (-b - sqrt(Utilities.positivePart(b^2 - 4*c*(a - (port_b[i].p - pIn)/dp_nominal/(y^2 + 1e-4)), 1e-3)))
        /(2*c);
      port_b[i].m_flow = -y*m_flow_nominal/nPorts_b*x[i];
    end for;
    // the forward flow and head only: while the pressures settle, the pump draws no negative power
    P = Utilities.positivePart(dp, 1)*mTra/rhoWat/eta;
  else
    x = zeros(nPorts_b);
    P = dp_nominal*m_flow/rhoWat/eta;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{0,100},{0,50}}, color={0,0,0}),
      Rectangle(extent={{-100,16},{100,-16}}, lineColor={0,0,0}, fillColor={0,127,255},
        fillPattern=FillPattern.HorizontalCylinder),
      Ellipse(extent={{-58,58},{58,-58}}, lineColor={0,0,0}, fillPattern=FillPattern.Sphere,
        fillColor={0,100,199}),
      Polygon(points={{0,50},{0,-50},{54,0},{0,50}}, lineColor={0,0,0}, pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder, fillColor={255,255,255}),
      Text(extent={{64,106},{114,92}}, textColor={0,0,127}, textString="P"),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end Pump;
