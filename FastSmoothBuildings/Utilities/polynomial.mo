within FastSmoothBuildings.Utilities;
function polynomial "c[1] + c[2]*x + ... + c[n]*x^(n-1)"
  input Real c[:];
  input Real x;
  output Real y;
algorithm
  y := sum(c[i]*x^(i - 1) for i in 1:size(c, 1));
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Value of a polynomial, its coefficients from the constant term up.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = &sum;<sub><i>i</i>=1</sub><sup><i>n</i></sup> <i>c<sub>i</sub></i> <i>x</i><sup><i>i</i>&minus;1</sup>,
<i>n</i> = size(<code>c</code>, 1). C-infinity.
</p>
<h4>Use</h4>
<p>
The windows evaluate their direct solar transmittance and absorptances at the cosine of the incidence angle with it,
the coefficients fitted by <a href=\"modelica://FastSmoothBuildings.Utilities.polynomialFit\">polynomialFit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end polynomial;
