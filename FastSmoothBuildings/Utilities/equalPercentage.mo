within FastSmoothBuildings.Utilities;
function equalPercentage
  "Equal-percentage valve characteristic with leakage (Buildings.Fluid.Actuators.BaseClasses.equalPercentage):
   linear below delta0/2, R^(y-1) above 1.5*delta0, a cubic Hermite joining them"
  input Real y "Opening";
  input Real R "Rangeability";
  input Real l "Leakage at y = 0";
  input Real delta0 "Width of the linear range near closure";
  output Real phi;
protected
  Real x0 = delta0/2;
  Real x1 = 1.5*delta0;
  Real y0 = l + x0*(R^(delta0 - 1) - l)/delta0;
  Real s0 = (R^(delta0 - 1) - l)/delta0;
  Real y1 = R^(x1 - 1);
  Real s1 = log(R)*R^(x1 - 1);
  Real h;
  Real u;
algorithm
  if y < x0 then
    phi := l + y*(R^(delta0 - 1) - l)/delta0;
  elseif y > x1 then
    phi := R^(y - 1);
  else
    h := x1 - x0;
    u := (y - x0)/h;
    phi := (2*u^3 - 3*u^2 + 1)*y0 + (u^3 - 2*u^2 + u)*h*s0 + (-2*u^3 + 3*u^2)*y1 + (u^3 - u^2)*h*s1;
  end if;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Equal-percentage characteristic <i>&phi;</i>(<i>y</i>) of a valve with leakage, once continuously
differentiable.
</p>
<h4>Equations</h4>
<p>
With the rangeability <i>R</i>, the leakage <i>l</i> and <i>&delta;</i><sub>0</sub> = <code>delta0</code>:
</p>
<table summary=\"Branches of equalPercentage\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Range</th><th><i>&phi;</i></th></tr>
<tr><td><i>y</i> &lt; <i>&delta;</i><sub>0</sub>/2</td>
<td><i>l</i> + <i>y</i> (<i>R</i><sup><i>&delta;</i><sub>0</sub>&minus;1</sup> &minus;
<i>l</i>)/<i>&delta;</i><sub>0</sub></td></tr>
<tr><td><i>&delta;</i><sub>0</sub>/2 &le; <i>y</i> &le; 1.5 <i>&delta;</i><sub>0</sub></td>
<td>cubic Hermite polynomial matching the value and slope of both neighbours</td></tr>
<tr><td><i>y</i> &gt; 1.5 <i>&delta;</i><sub>0</sub></td><td><i>R</i><sup><i>y</i>&minus;1</sup></td></tr>
</table>
<p>
<i>&phi;</i>(0) = <i>l</i>, <i>&phi;</i>(1) = 1; the linear branch passes through
<i>R</i><sup><i>&delta;</i><sub>0</sub>&minus;1</sup> at <i>y</i> = <i>&delta;</i><sub>0</sub>. C1.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.Actuators.BaseClasses.equalPercentage</code>.
</p>
<h4>Use</h4>
<p>
The two-way and three-way valves of <a href=\"modelica://FastSmoothBuildings.Hydronics\">Hydronics</a> pass it,
their opening limited to [0, 1] by
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>, to
<a href=\"modelica://FastSmoothBuildings.Utilities.valveConductance\">valveConductance</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end equalPercentage;
