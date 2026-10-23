within FastSmoothBuildings.Utilities;
function smoothLimitInside
  "Once continuously differentiable limitation of x to [l + deltaX, u - deltaX], strictly inside [l, u] (for
   arguments of functions singular at the bounds, as acos at -1 and 1)"
  input Real x;
  input Real l;
  input Real u;
  input Real deltaX;
  output Real y;
algorithm
  y := smoothMin(smoothMax(x, l + deltaX, deltaX), u - deltaX, deltaX);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Limitation of <i>x</i> strictly inside [<i>l</i>, <i>u</i>], once continuously differentiable: for the argument of
a function singular at the bounds, as <code>acos</code> and <code>asin</code> at &minus;1 and 1.
</p>
<h4>Equations</h4>
<p>
With <i>&delta;</i> = <code>deltaX</code>,
</p>
<p>
<i>y</i> = smoothMin(smoothMax(<i>x</i>, <i>l</i> + <i>&delta;</i>, <i>&delta;</i>), <i>u</i> &minus;
<i>&delta;</i>, <i>&delta;</i>),
</p>
<p>
with <a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a>. For <i>u</i> &minus; <i>l</i> &ge;
4 <i>&delta;</i>: <i>y</i> = <i>l</i> + <i>&delta;</i> for <i>x</i> &lt; <i>l</i>, <i>y</i> = <i>x</i> between
<i>l</i> + 2 <i>&delta;</i> and <i>u</i> &minus; 2 <i>&delta;</i>, <i>y</i> = <i>u</i> &minus; <i>&delta;</i> for
<i>x</i> &gt; <i>u</i>. In the blends the result passes at most 0.087 <i>&delta;</i> beyond <i>l</i> +
<i>&delta;</i> and <i>u</i> &minus; <i>&delta;</i>, so it stays at least 0.91 <i>&delta;</i> away from the bounds.
C1.
</p>
<h4>Use</h4>
<p>
The weather and the windows bound the cosines they give to <code>acos</code> and <code>asin</code> with it, whose
derivatives are infinite at &minus;1 and 1.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end smoothLimitInside;
