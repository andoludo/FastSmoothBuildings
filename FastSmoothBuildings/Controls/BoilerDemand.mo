within FastSmoothBuildings.Controls;
model BoilerDemand
  "Demand of a production (trano BoilerControl, variant simple): on when a valve of its circuits opens beyond 0.5,
   off when all are below 0.01"
  parameter Integer n = 1 "Number of circuits";
  parameter Real dMax = 1e-3 "Width of the smooth maximum of the openings";
  Interfaces.RealInput yMax[n] "Largest opening of the valves of each circuit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Hysteresis hys(uLow=0.01, uHigh=0.5, u=smoothMaxN(yMax, dMax));
  Interfaces.RealOutput y(unit="1") "Demand"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = hys.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="demand"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Demand of a production (trano's <code>BoilerControl</code>, variant simple): 1 when a valve of its circuits opens
beyond 0.5, back to 0 when all are below 0.01.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = <code>hys.y</code>, a <a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a> with
<code>uLow</code> = 0.01 and <code>uHigh</code> = 0.5 of <i>u</i> =
<a href=\"modelica://FastSmoothBuildings.Controls.smoothMaxN\">smoothMaxN</a>(<code>yMax</code>, <code>dMax</code>),
the largest opening over the circuits. The demand is a bistable state, without <code>pre</code> or
<code>when</code>.
</p>
<h4>Parameters</h4>
<p>
<code>n</code> = 1 circuits; <code>dMax</code> = 10<sup>&minus;3</sup>, the width of the smooth maximum. The
hysteresis keeps its defaults, <code>hys.tau</code> = 10 s and <code>hys.dU</code> = 0.049; a calibration can widen
them by modifiers.
</p>
<h4>Use</h4>
<p>
Each input is the <code>yMax</code> of the
<a href=\"modelica://FastSmoothBuildings.Controls.CollectorControl\">CollectorControl</a> of a circuit; the output
feeds the <code>demand</code> of
<a href=\"modelica://FastSmoothBuildings.Controls.HeatPumpControl\">HeatPumpControl</a> in
<a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end BoilerDemand;
