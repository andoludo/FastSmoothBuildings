within FastSmoothBuildings.Utilities;
function smoothLimitBelow
  "Once continuously differentiable limitation of x from below by l: exactly l below l - deltaX, x above l + deltaX"
  input Real x;
  input Real l;
  input Real deltaX "Half width of the blend";
  output Real y;
algorithm
  y := if x > l + deltaX then x else if x < l - deltaX then l else l + (x - l + deltaX)^2/(4*deltaX);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Limitation of <i>x</i> from below by <i>l</i>, once continuously differentiable and without events: the
first half of <a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>, which applies
it, then smoothLimitAbove.
</p>
<h4>Equations</h4>
<p>
With <i>&delta;</i> = <code>deltaX</code>: <i>y</i> = <i>l</i> below l - deltaX,
<i>y</i> = <i>x</i> above l + deltaX, and in between the parabola
<i>y</i> = <i>l</i> + (<i>x</i> &minus; <i>l</i> + <i>&delta;</i>)<sup>2</sup>/(4 <i>&delta;</i>),
which meets the bound with a zero slope and the identity with a unit slope (C1).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: split from smoothLimit, so that every statement of a function is one assignment (rumoca after
commit 33c2114, 0.10.3 on PyPI, cannot export a variable set by an if-expression and used by the next statement).</li>
</ul>
</html>"));
end smoothLimitBelow;
