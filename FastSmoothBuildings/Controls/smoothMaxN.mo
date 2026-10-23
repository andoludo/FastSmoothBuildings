within FastSmoothBuildings.Controls;
function smoothMaxN "Smooth maximum of a vector"
  input Real u[:];
  input Real delta = 1e-3;
  output Real y;
algorithm
  y := u[1];
  for i in 2:size(u, 1) loop
    y := Utilities.smoothMax(y, u[i], delta);
  end for;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
The largest element of a vector, once continuously differentiable: the controls of the circuits take the largest
opening of their valves with it.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = smoothMax(&hellip; smoothMax(smoothMax(<i>u</i><sub>1</sub>, <i>u</i><sub>2</sub>, <i>&delta;</i>),
<i>u</i><sub>3</sub>, <i>&delta;</i>) &hellip;, <i>u<sub>n</sub></i>, <i>&delta;</i>), and <i>y</i> =
<i>u</i><sub>1</sub> for a single element. Each
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a> is exactly the maximum when its two
arguments differ by more than <i>&delta;</i>.
</p>
<h4>Parameters</h4>
<p>
<code>delta</code> = 10<sup>&minus;3</sup> by default, the <code>dMax</code> of the controllers that call it.
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Controls.BoilerDemand\">BoilerDemand</a> and
<a href=\"modelica://FastSmoothBuildings.Controls.CollectorControl\">CollectorControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end smoothMaxN;
