within FastSmoothBuildings.Controls;
model PI
  "PI controller with limits and anti-windup (Modelica LimPID: back-calculation with Ni), its integral relaxed to
   the reset value while disabled"
  parameter Real k "Gain";
  parameter Real Ti(unit="s") "Integral time";
  parameter Real yMin = 0;
  parameter Real yMax = 1;
  parameter Real Ni = 0.9 "Anti-windup gain";
  parameter Real yReset = yMin "Output after a reset";
  parameter Real tauReset(unit="s") = 30 "Time constant of the reset while disabled";
  parameter Real dY = 1e-3*(yMax - yMin) "Width of the smooth limits";
  Interfaces.RealInput e "Control error"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput enable "1: integrate, 0: reset"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=90, origin={0,-120})));
  Real I(start=yReset/k, fixed=true) "Integral of the error";
  Real yUnl "Unlimited output";
  Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  yUnl = k*(e + I);
  y = Utilities.smoothLimit(yUnl, yMin, yMax, dY);
  der(I) = enable*(e/Ti + (y - yUnl)/(k*Ni*Ti)) + (1 - enable)*(yReset/k - e - I)/tauReset;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-80,82},{-88,60},{-72,60},{-80,82}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,68},{-80,-100}}, color={192,192,192}),
      Line(points={{-90,-80},{70,-80}}, color={192,192,192}),
      Polygon(points={{74,-80},{52,-72},{52,-88},{74,-80}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,-80},{-80,-22}}, color={0,0,0}),
      Line(points={{-80,-22},{6,56}}, color={0,0,0}),
      Line(points={{6,56},{68,56}}, color={0,0,0}),
      Text(extent={{-26,-22},{74,-62}}, textColor={0,0,0}, textString="PI"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A PI controller with limits and anti-windup, and a reset without events: while it is disabled, its integral relaxes
to the value that gives the reset output, instead of being reset by a trigger. The limits are
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>, which reaches them exactly.
</p>
<h4>Equations</h4>
<p>
With the control error <i>e</i> and the integral <i>I</i>,
</p>
<p>
<i>y<sub>unl</sub></i> = <i>k</i> (<i>e</i> + <i>I</i>), &nbsp;
<i>y</i> = smoothLimit(<i>y<sub>unl</sub></i>, <i>y<sub>Min</sub></i>, <i>y<sub>Max</sub></i>, <i>dY</i>),
</p>
<p>
d<i>I</i>/d<i>t</i> = <i>enable</i> (<i>e</i>/<i>T<sub>i</sub></i> + (<i>y</i> &minus; <i>y<sub>unl</sub></i>) /
(<i>k</i> <i>N<sub>i</sub></i> <i>T<sub>i</sub></i>)) + (1 &minus; <i>enable</i>)
(<i>y<sub>Reset</sub></i>/<i>k</i> &minus; <i>e</i> &minus; <i>I</i>) / <i>&tau;<sub>Reset</sub></i>,
&nbsp; <i>I</i>(0) = <i>y<sub>Reset</sub></i>/<i>k</i>.
</p>
<ul>
<li><code>enable</code> = 1: the integral of <i>e</i>/<i>T<sub>i</sub></i>, with back-calculation: when the output
is limited, <i>y</i> &minus; <i>y<sub>unl</sub></i> draws the integral back with the anti-windup gain
<code>Ni</code>.</li>
<li><code>enable</code> = 0: the integral relaxes with the time constant <code>tauReset</code> so that the unlimited
output tends to <code>yReset</code>; the controller restarts from there when it is enabled again.</li>
</ul>
<p>
<code>enable</code> is a <code>Real</code> and the two parts are blended by it, so it can be the output of a
<a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a>. The output is not multiplied by
<code>enable</code>: a model that needs no output while disabled multiplies it, as
<a href=\"modelica://FastSmoothBuildings.Controls.HeatPumpControl\">HeatPumpControl</a> does.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of PI\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>k</code>, <code>Ti</code></td><td>&nbsp;</td><td>gain and integral time</td></tr>
<tr><td><code>yMin</code>, <code>yMax</code></td><td>0, 1</td><td>limits of the output</td></tr>
<tr><td><code>Ni</code></td><td>0.9</td><td>anti-windup gain</td></tr>
<tr><td><code>yReset</code></td><td><code>yMin</code></td><td>output after a reset</td></tr>
<tr><td><code>tauReset</code></td><td>30 s</td><td>time constant of the reset while disabled</td></tr>
<tr><td><code>dY</code></td><td>10<sup>&minus;3</sup> (<code>yMax</code> &minus; <code>yMin</code>)</td>
<td>half-width of the smooth limits</td></tr>
</table>
<p>
<code>dY</code> and <code>tauReset</code> are the smoothing of the controller: a calibration or an optimal control
problem can widen them.
</p>
<h4>Relation to the Modelica Standard Library</h4>
<p>
The limits and the anti-windup of <code>LimPID</code> (back-calculation with <code>Ni</code>); the reset of a
trigger is replaced by the relaxation above.
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Controls.EmissionPI\">EmissionPI</a>,
<a href=\"modelica://FastSmoothBuildings.Controls.HeatPumpControl\">HeatPumpControl</a> and
<a href=\"modelica://FastSmoothBuildings.HVAC.IdealHeatingCoolingPI\">HVAC.IdealHeatingCoolingPI</a>. See
<a href=\"modelica://FastSmoothBuildings.Controls.Validation.PIControl\">Validation.PIControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end PI;
