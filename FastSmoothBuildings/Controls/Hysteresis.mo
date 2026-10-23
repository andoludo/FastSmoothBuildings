within FastSmoothBuildings.Controls;
model Hysteresis
  "y goes to 1 when u rises above uHigh and back to 0 when u falls below uLow (CDL Hysteresis), as a bistable
   state switching within tau"
  parameter Real uLow "Threshold of the switch to 0";
  parameter Real uHigh "Threshold of the switch to 1";
  parameter Real tau(unit="s") = 10 "Switching time";
  parameter Real dU = (uHigh - uLow)/10 "Half-width of the smooth transition of the switch";
  parameter Real y_start = 0 "Initial output";
  Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real y(start=y_start, fixed=true);
equation
  tau*der(y) = Utilities.regStep(u - (uHigh + (uLow - uHigh)*y), 1, 0, dU) - y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}, fillColor={210,210,210},
        fillPattern=FillPattern.Solid, borderPattern=BorderPattern.Raised),
      Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,68},{-80,-29}}, color={192,192,192}),
      Polygon(points={{92,-29},{70,-21},{70,-37},{92,-29}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-79,-29},{84,-29}}, color={192,192,192}),
      Line(points={{-79,-29},{41,-29}}),
      Line(points={{-15,-21},{1,-29},{-15,-36}}),
      Line(points={{41,51},{41,-29}}),
      Line(points={{33,3},{41,22},{50,3}}),
      Line(points={{-49,51},{81,51}}),
      Line(points={{-4,59},{-19,51},{-4,43}}),
      Line(points={{-59,29},{-49,11},{-39,29}}),
      Line(points={{-49,51},{-49,-29}}),
      Text(extent={{-92,-49},{-9,-92}}, textColor={192,192,192}, textString="%uLow"),
      Text(extent={{2,-49},{91,-92}}, textColor={192,192,192}, textString="%uHigh"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A hysteresis without events: the output <code>y</code> goes to 1 when the input <code>u</code> rises above
<code>uHigh</code> and back to 0 when it falls below <code>uLow</code>. Instead of the <code>pre(y)</code> of a
switching hysteresis, the memory is a state with two stable values, and the threshold is crossed by
<a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a> instead of an <code>if</code>: the model stays
an explicit ODE that CasADi and IPOPT can differentiate.
</p>
<h4>Equations</h4>
<p>
<i>&tau;</i> d<i>y</i>/d<i>t</i> = regStep(<i>u</i> &minus; <i>u<sub>thr</sub></i>, 1, 0, <i>dU</i>) &minus;
<i>y</i>, &nbsp; <i>u<sub>thr</sub></i> = <i>u<sub>High</sub></i> + (<i>u<sub>Low</sub></i> &minus;
<i>u<sub>High</sub></i>) <i>y</i>, &nbsp; <i>y</i>(0) = <code>y_start</code>.
</p>
<p>
The threshold moves with the output: it is <code>uHigh</code> at <i>y</i> = 0 and <code>uLow</code> at
<i>y</i> = 1. For <i>u<sub>Low</sub></i> + <i>dU</i> &lt; <i>u</i> &lt; <i>u<sub>High</sub></i> &minus;
<i>dU</i>, both <i>y</i> = 0 and <i>y</i> = 1 are equilibria and the output keeps the one it is at. When <i>u</i>
comes within <i>dU</i> of the threshold, the target of <i>y</i> leaves its value; as <i>y</i> moves, the threshold
moves away from <i>u</i> and the switch completes, <i>y</i> relaxing to its new value with the time constant
<i>&tau;</i>.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of Hysteresis\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>uLow</code>, <code>uHigh</code></td><td>&nbsp;</td><td>thresholds of the switches to 0 and to 1</td></tr>
<tr><td><code>tau</code></td><td>10 s</td><td>switching time</td></tr>
<tr><td><code>dU</code></td><td>(<code>uHigh</code> &minus; <code>uLow</code>)/10</td>
<td>half-width of the smooth transition at each threshold</td></tr>
<tr><td><code>y_start</code></td><td>0</td><td>initial output</td></tr>
</table>
<p>
<code>tau</code> and <code>dU</code> are the smoothing of the switch: the defaults reproduce a switching hysteresis,
and a model exported for calibration or optimal control can lengthen <code>tau</code> and widen <code>dU</code>.
The band where the output is held is not empty only while <code>dU</code> &lt; (<code>uHigh</code> &minus;
<code>uLow</code>)/2.
</p>
<h4>Relation to Buildings</h4>
<p>
The <code>Hysteresis</code> block of CDL, with the output a <code>Real</code> state between 0 and 1 instead of a
<code>Boolean</code>.
</p>
<h4>Use</h4>
<p>
The output is the variable <code>y</code>, read as <code>hys.y</code>; <code>u</code> is usually bound in the
declaration. It switches the on/off emission control
<a href=\"modelica://FastSmoothBuildings.Controls.EmissionOnOff\">EmissionOnOff</a>, the demand of
<a href=\"modelica://FastSmoothBuildings.Controls.BoilerDemand\">BoilerDemand</a>, the pump of
<a href=\"modelica://FastSmoothBuildings.Controls.CollectorControl\">CollectorControl</a> and the heating season and
buffer charging of <a href=\"modelica://FastSmoothBuildings.Controls.HeatPumpControl\">HeatPumpControl</a>. See
<a href=\"modelica://FastSmoothBuildings.Controls.Validation.Hysteresis\">Validation.Hysteresis</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end Hysteresis;
