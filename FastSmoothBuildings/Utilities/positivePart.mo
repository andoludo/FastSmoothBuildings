within FastSmoothBuildings.Utilities;
function positivePart "Smooth max(x, 0): 0.5*(x + sqrt(x^2 + delta^2))"
  input Real x;
  input Real delta;
  output Real y;
algorithm
  y := 0.5*(x + sqrt(x^2 + delta^2));
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Smooth approximation of max(<i>x</i>, 0), strictly positive: a flow or a cosine that can divide or weight
without a singularity at 0.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = (<i>x</i> + &radic;(<i>x</i><sup>2</sup> + <i>&delta;</i><sup>2</sup>))/2.
</p>
<p>
Infinitely differentiable (C-infinity) for <i>&delta;</i> &gt; 0. Always above max(<i>x</i>, 0): <i>y</i> =
<i>&delta;</i>/2 at <i>x</i> = 0, and the difference (&radic;(<i>x</i><sup>2</sup> + <i>&delta;</i><sup>2</sup>)
&minus; |<i>x</i>|)/2 tends to <i>&delta;</i><sup>2</sup>/(4|<i>x</i>|) for |<i>x</i>| &gt;&gt; <i>&delta;</i>:
<i>y</i> tends to 0 for <i>x</i> &rarr; &minus;&infin; and to <i>x</i> for <i>x</i> &rarr; &infin;.
</p>
<h4>Use</h4>
<p>
<code>delta</code> is the width of the rounding, in the unit of <i>x</i>; unlike
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a>, the result is nowhere exact.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end positivePart;
