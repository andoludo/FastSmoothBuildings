within FastSmoothBuildings.Utilities;
function smoothLimit
  "Once continuously differentiable limitation of x to [l, u]: exactly l below l - deltaX and u above u + deltaX,
   x between l + deltaX and u - deltaX, quadratic blends in between that never leave [l, u]"
  input Real x;
  input Real l;
  input Real u;
  input Real deltaX "Half width of the blends, below (u - l)/2";
  output Real y;
algorithm
  y := smoothLimitAbove(smoothLimitBelow(x, l, deltaX), u, deltaX);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Limitation of <i>x</i> to [<i>l</i>, <i>u</i>], once continuously differentiable and without events: exactly at
the bounds beyond the blends, never outside them (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Smoothing\">Smoothing</a>).
</p>
<h4>Equations</h4>
<p>
With <i>&delta;</i> = <code>deltaX</code>, <i>x</i> is first limited from below to <i>z</i>
(<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimitBelow\">smoothLimitBelow</a>), then <i>z</i> from
above to <i>y</i>
(<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimitAbove\">smoothLimitAbove</a>):
</p>
<table summary=\"Branches of smoothLimit\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Range</th><th>Value</th></tr>
<tr><td><i>x</i> &lt; <i>l</i> &minus; <i>&delta;</i></td><td><i>z</i> = <i>l</i></td></tr>
<tr><td>|<i>x</i> &minus; <i>l</i>| &le; <i>&delta;</i></td>
<td><i>z</i> = <i>l</i> + (<i>x</i> &minus; <i>l</i> + <i>&delta;</i>)<sup>2</sup>/(4 <i>&delta;</i>)</td></tr>
<tr><td><i>x</i> &gt; <i>l</i> + <i>&delta;</i></td><td><i>z</i> = <i>x</i></td></tr>
<tr><td><i>z</i> &lt; <i>u</i> &minus; <i>&delta;</i></td><td><i>y</i> = <i>z</i></td></tr>
<tr><td>|<i>z</i> &minus; <i>u</i>| &le; <i>&delta;</i></td>
<td><i>y</i> = <i>u</i> &minus; (<i>u</i> + <i>&delta;</i> &minus; <i>z</i>)<sup>2</sup>/(4 <i>&delta;</i>)</td></tr>
<tr><td><i>z</i> &gt; <i>u</i> + <i>&delta;</i></td><td><i>y</i> = <i>u</i></td></tr>
</table>
<p>
Each parabola meets the constant bound with a zero slope and the identity with a unit slope (C1). The result is
<i>l</i> below <i>l</i> &minus; <i>&delta;</i>, <i>u</i> above <i>u</i> + <i>&delta;</i>, <i>x</i> between
<i>l</i> + <i>&delta;</i> and <i>u</i> &minus; <i>&delta;</i>, and non-decreasing in <i>x</i>.
</p>
<h4>Use</h4>
<p>
<code>deltaX</code> is the half width of the blends; below (<i>u</i> &minus; <i>l</i>)/2, the result stays within
[<i>l</i>, <i>u</i>]. The controllers limit their outputs with it, and the valves their opening.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
<li>October 2026: the two limits are the functions smoothLimitBelow and smoothLimitAbove, one assignment each:
rumoca after commit 33c2114 (0.10.3 on PyPI) cannot export a variable set by an if-expression and used by the next
statement.</li>
</ul>
</html>"));
end smoothLimit;
