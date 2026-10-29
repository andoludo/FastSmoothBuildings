within FastSmoothBuildings.Utilities;
function smoothLimitAbove
  "Once continuously differentiable limitation of x from above by u: exactly u above u + deltaX, x below u - deltaX"
  input Real x;
  input Real u;
  input Real deltaX "Half width of the blend";
  output Real y;
algorithm
  y := if x < u - deltaX then x else if x > u + deltaX then u else u - (u + deltaX - x)^2/(4*deltaX);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Limitation of <i>x</i> from above by <i>u</i>, once continuously differentiable and without events: the
second half of <a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>, which applies
smoothLimitBelow, then it.
</p>
<h4>Equations</h4>
<p>
With <i>&delta;</i> = <code>deltaX</code>: <i>y</i> = <i>u</i> above u + deltaX,
<i>y</i> = <i>x</i> below u - deltaX, and in between the parabola
<i>y</i> = <i>u</i> &minus; (<i>u</i> + <i>&delta;</i> &minus; <i>x</i>)<sup>2</sup>/(4 <i>&delta;</i>),
which meets the bound with a zero slope and the identity with a unit slope (C1).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: split from smoothLimit, so that every statement of a function is one assignment (rumoca after
commit 33c2114, 0.10.3 on PyPI, cannot export a variable set by an if-expression and used by the next statement).</li>
</ul>
</html>"));
end smoothLimitAbove;
