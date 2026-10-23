within FastSmoothBuildings.Utilities;
function regStep "Once continuously differentiable step from y2 (x < -x_small) to y1 (x > x_small)"
  input Real x;
  input Real y1;
  input Real y2;
  input Real x_small = 1e-5;
  output Real y;
algorithm
  y := if x > x_small then y1 else if x < -x_small then y2 else (x/x_small)*((x/x_small)^2 - 3)*(y2 - y1)/4 + (y1 + y2)/2;
  annotation (
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A step from <i>y<sub>2</sub></i> to <i>y<sub>1</sub></i> around <i>x</i> = 0 whose value and first derivative are
continuous. It replaces the <code>if</code> conditions and the events of a switch, so that the model stays an
explicit ODE with continuous derivatives that CasADi and IPOPT can differentiate.
</p>
<h4>Equations</h4>
<p>
With <i>&epsilon;</i> = <code>x_small</code>,
</p>
<table summary=\"Branches of regStep\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Range</th><th>Value</th></tr>
<tr><td><i>x</i> &gt; <i>&epsilon;</i></td><td><i>y</i> = <i>y<sub>1</sub></i></td></tr>
<tr><td><i>x</i> &lt; &minus;<i>&epsilon;</i></td><td><i>y</i> = <i>y<sub>2</sub></i></td></tr>
<tr><td>|<i>x</i>| &le; <i>&epsilon;</i></td>
<td><i>y</i> = (<i>x</i>/<i>&epsilon;</i>) ((<i>x</i>/<i>&epsilon;</i>)<sup>2</sup> &minus; 3)
(<i>y<sub>2</sub></i> &minus; <i>y<sub>1</sub></i>)/4 + (<i>y<sub>1</sub></i> + <i>y<sub>2</sub></i>)/2</td></tr>
</table>
<p>
The cubic meets both constants with a zero slope at <i>x</i> = &plusmn;<i>&epsilon;</i>; its slope at
<i>x</i> = 0 is 3 (<i>y<sub>1</sub></i> &minus; <i>y<sub>2</sub></i>)/(4 <i>&epsilon;</i>).
</p>
<h4>Relation to Buildings</h4>
<p>
The same function as
<code>Buildings.Utilities.Math.Functions.regStep</code>, without its derivative annotation (rumoca
differentiates the expression itself).
</p>
<h4>Use</h4>
<p>
The width <i>&epsilon;</i> is the trade-off of every smooth switch of the library: the wider it is, the easier the
optimal control problem and the further the model from the switching controller it replaces. The controllers of
<a href=\"modelica://FastSmoothBuildings.Controls\">FastSmoothBuildings.Controls</a> expose it as a parameter.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end regStep;
