within FastSmoothBuildings.Hydronics;
model Pump
  "Pump: pass-through with set flows; with pressure-driven flows, the flow at its head from a decreasing curve through
   the points of Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y (1.14, 1 and 0.42 times dp_nominal at 0, 1
   and 2 times the nominal flow), scaled to the speed y by the affinity laws"
  extends PartialConserving(final GHyd=m_flow_nominal/dp_nominal);
  parameter Real dp_nominal(unit="Pa") = 3e4 "Pressure head at the nominal flow";
  parameter Real m_flow_nominal(unit="kg/s") = 1 "Nominal flow";
  parameter Real eta = 0.5 "Overall efficiency";
  Interfaces.RealInput y(unit="1") "Relative speed (pressure-driven flows)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120})));
  Real dp(unit="Pa") "Head";
  Real P(unit="W") "Electrical power";
protected
  Real x[nPorts_b] "Flow of each outlet relative to y*m_flow_nominal/nPorts_b";
equation
  TOut = TIn;
  dp = sum(port_b[i].p for i in 1:nPorts_b)/nPorts_b - pIn;
  if pressureDriven then
    for i in 1:nPorts_b loop
      // beyond the shut-off head the flow falls to zero (Utilities.pumpFlow)
      x[i] = Utilities.pumpFlow((port_b[i].p - pIn)/dp_nominal/(y^2 + 1e-4));
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
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Circulation pump. With set flows the circuit flows are set by the valves and the pump only passes the water
through and computes its power; with pressure-driven flows it delivers the flow of its curve at the head the
circuit puts on it, at the relative speed <code>y</code>.
</p>
<h4>Equations</h4>
<p>
The water passes at the inlet temperature, <code>TOut</code> = <code>TIn</code>. The head is
<code>dp</code> = <i>p&#772;<sub>b</sub></i> &minus; <i>p<sub>in</sub></i>, <i>p&#772;<sub>b</sub></i> the mean
pressure of the nodes downstream (0 with set flows).
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, what enters leaves, and the electrical power is taken at the nominal head:
<i>P</i> = <code>dp_nominal</code> <i>m&#775;</i> / (<i>&rho;</i> <i>&eta;</i>), <i>&eta;</i> =
<code>eta</code>. The input <code>y</code> is not used.
</p>
<p>
With pressure-driven flows, the head of the pump relative to <i>&Delta;p<sub>0</sub></i> = <code>dp_nominal</code>
falls with the flow relative to the nominal flow, <i>x</i>, as <i>h</i>(<i>x</i>) = 1.14 &minus; 0.14
<i>x</i><sup>2.3626</sup>, through the points (0, 1.14), (1, 1) and (2, 0.42), scaled to the speed <i>y</i> by the
affinity laws (flow as <i>y</i>, head as <i>y</i><sup>2</sup>). For each of the <i>n<sub>b</sub></i> outlets, the
flow is that of the curve at the head of that outlet,
<a href=\"modelica://FastSmoothBuildings.Utilities.pumpFlow\">Utilities.pumpFlow</a>:
</p>
<p>
<i>x<sub>j</sub></i> = pumpFlow(<i>h<sub>j</sub></i>), &nbsp;
<i>h<sub>j</sub></i> = (<i>p<sub>b,j</sub></i> &minus; <i>p<sub>in</sub></i>) /
(<i>&Delta;p<sub>0</sub></i> (<i>y</i><sup>2</sup> + 10<sup>&minus;4</sup>)),
</p>
<p>
<code>port_b[j].m_flow</code> = &minus;<i>y</i> <code>m_flow_nominal</code> <i>x<sub>j</sub></i> /
<i>n<sub>b</sub></i>.
</p>
<p>
Beyond the shut-off head the flow falls to zero: a pump against closed valves passes nothing and its head stays
near the shut-off head. The 10<sup>&minus;4</sup> keeps the relative head defined at <i>y</i> = 0. The
power counts the forward head and flow only, <i>P</i> = positivePart(<code>dp</code>, 1) <code>mTra</code> /
(<i>&rho;</i> <i>&eta;</i>), so the pump draws no negative power while the pressures settle. The compliance of the
inlet node is scaled by <code>m_flow_nominal</code>/<code>dp_nominal</code>.
</p>
<h4>Relation to Buildings</h4>
<p>
The curve is that of <code>Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y</code>: 1.14, 1 and 0.42 times
<code>dp_nominal</code> at 0, 1 and 2 times the nominal flow. The electrical power is not added to the water
(<code>TOut</code> = <code>TIn</code>).
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>, the speed follows
the opening of the radiator valve through
<a href=\"modelica://FastSmoothBuildings.Controls.CollectorControl\">Controls.CollectorControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
<li>November 2026: the curve is decreasing (Utilities.pumpFlow). The parabola through the same points rose
between no flow and 0.18 times the nominal flow: beyond its top the pump kept that flow whatever the head, and
against closed valves the pressures of the circuit rose without bound.</li>
</ul>
</html>"));
end Pump;
