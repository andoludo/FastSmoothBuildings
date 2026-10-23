within FastSmoothBuildings.Controls;
model CollectorControl
  "Collector control of a pump (trano CollectorControl): on when a valve opens beyond 0.5, off when all are
   below 0.01, the speed from a P controller holding the head at dp_nominal"
  parameter Integer nVal = 1 "Number of valves";
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the speed";
  parameter Real dMax = 1e-3 "Width of the smooth maximum of the openings";
  Interfaces.RealInput yVal[nVal] "Openings of the valves of the circuit"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput dpRel "Head of the pump relative to its nominal head"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput yMax "Largest opening (the boiler control reads it)"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Hysteresis hysPum(uLow=0.01, uHigh=0.5, u=yMax);
  Interfaces.RealOutput y(unit="1") "Speed of the pump"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  yMax = smoothMaxN(yVal, dMax);
  y = Utilities.smoothLimit(k*(hysPum.y - dpRel), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="collector"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Control of the pump of a circuit (trano's <code>CollectorControl</code>): the pump is on when a valve of the circuit
opens beyond 0.5 and off when all are below 0.01; while on, a proportional controller holds its head at the nominal
head.
</p>
<h4>Equations</h4>
<p>
<i>y<sub>Max</sub></i> = smoothMaxN(<code>yVal</code>, <code>dMax</code>), &nbsp;
<i>y</i> = smoothLimit(<i>k</i> (<i>y<sub>Pum</sub></i> &minus; <i>dp<sub>Rel</sub></i>), 0, 1, <i>dY</i>),
</p>
<p>
with <i>y<sub>Pum</sub></i> = <code>hysPum.y</code>, a
<a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a> of <i>y<sub>Max</sub></i> between 0.01
and 0.5. The set point of the relative head is 1 while the pump is on and 0 while it is off; the on/off decision is
a bistable state, the limits of the speed smooth, so the control has no event.
</p>
<h4>Parameters</h4>
<p>
<code>nVal</code> = 1 valves; <code>k</code> = 1; <code>dY</code> = 10<sup>&minus;3</sup>, the half-width of the
smooth limits of the speed; <code>dMax</code> = 10<sup>&minus;3</sup>, the width of the smooth maximum of the
openings. The hysteresis keeps its defaults (<code>hysPum.tau</code> = 10 s, <code>hysPum.dU</code> = 0.049).
</p>
<h4>Use</h4>
<p>
The output <code>yMax</code> is read by
<a href=\"modelica://FastSmoothBuildings.Controls.BoilerDemand\">BoilerDemand</a>. See
<a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end CollectorControl;
