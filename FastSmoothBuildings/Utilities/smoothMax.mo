within FastSmoothBuildings.Utilities;
function smoothMax "Once continuously differentiable approximation of max(x1, x2)"
  input Real x1;
  input Real x2;
  input Real deltaX;
  output Real y;
algorithm
  y := regStep(x1 - x2, x1, x2, deltaX);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Once continuously differentiable approximation of max(<i>x<sub>1</sub></i>, <i>x<sub>2</sub></i>), without events
(see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Smoothing\">Smoothing</a>).
</p>
<h4>Equations</h4>
<p>
<i>y</i> = <a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a>(<i>x<sub>1</sub></i> &minus;
<i>x<sub>2</sub></i>, <i>x<sub>1</sub></i>,
<i>x<sub>2</sub></i>, &Delta;<i>x</i>): <i>y</i> = <i>x<sub>1</sub></i> when <i>x<sub>1</sub></i> &minus;
<i>x<sub>2</sub></i> &gt; &Delta;<i>x</i>, <i>y</i> = <i>x<sub>2</sub></i> when <i>x<sub>1</sub></i> &minus;
<i>x<sub>2</sub></i> &lt; &minus;&Delta;<i>x</i>, and in between a weighted mean of the two arguments whose weight
goes from 0 to 1 along the cubic of regStep.
</p>
<p>
The result is exact outside the blend and continuous with its first derivative (C1). Inside the blend it lies
between the two arguments, at most 0.087 &Delta;<i>x</i> below max(<i>x<sub>1</sub></i>, <i>x<sub>2</sub></i>);
it equals it when <i>x<sub>1</sub></i> = <i>x<sub>2</sub></i>.
</p>
<h4>Use</h4>
<p>
<code>deltaX</code> (&gt; 0) is the half width of the blend, in the unit of the arguments. The arguments are those
of <code>Buildings.Utilities.Math.Functions.smoothMax</code>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end smoothMax;
