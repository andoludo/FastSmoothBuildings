within FastSmoothBuildings.UsersGuide;
class Smoothing "Smoothing"
  extends FastSmoothBuildings.Icons.Information;
  annotation (preferredView="info", Documentation(info="<html>
<p>
A model of the library has no event: no <code>when</code>, <code>pre</code>, <code>sample</code> or
<code>if</code> on a variable that would switch during the simulation. Where Buildings switches, the library
blends:
</p>
<table summary=\"Smooth functions\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Function</th><th>Replaces</th></tr>
<tr><td><a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a></td>
<td>a step: once continuously differentiable over a given width</td></tr>
<tr><td><a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a></td><td><code>max</code>,
<code>min</code></td></tr>
<tr><td><a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a></td>
<td>a limiter: exactly at its bounds beyond the blends, never outside them</td></tr>
<tr><td><a href=\"modelica://FastSmoothBuildings.Utilities.positivePart\">positivePart</a></td>
<td><code>max(x, 0)</code></td></tr>
<tr><td><a href=\"modelica://FastSmoothBuildings.Utilities.timeOfDay\">timeOfDay</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.occupancy\">occupancy</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.dayTable\">dayTable</a></td>
<td>daily schedules, without the events of a table or a clock</td></tr>
</table>
<p>
The controllers of <a href=\"modelica://FastSmoothBuildings.Controls\">Controls</a> are written with them: a
hysteresis is a fast bistable state, a PI controller has an anti-windup and a smooth reset, a change of set point
takes <code>dtSet</code>. The width of every transition and the switching time of every hysteresis are parameters
(<code>dU</code>, <code>dY</code>, <code>dMax</code>, <code>dT</code>, <code>dtSet</code>, <code>tau</code>), at
values that reproduce the switching controllers by default: a model exported for calibration or optimal control
can widen them.
</p>
</html>"));
end Smoothing;
