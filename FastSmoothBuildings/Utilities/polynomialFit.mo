within FastSmoothBuildings.Utilities;
function polynomialFit "Least-squares quartic c[1] + c[2]*x + ... + c[5]*x^4 through 10 points (x, y)"
  input Real x[10];
  input Real y[10];
  output Real c[5];
protected
  Real A[5, 5];
  Real b[5];
  Real factor;
algorithm
  // normal equations
  for i in 1:5 loop
    for j in 1:5 loop
      A[i, j] := sum(x[k]^(i + j - 2) for k in 1:10);
    end for;
    b[i] := sum(y[k]*x[k]^(i - 1) for k in 1:10);
  end for;
  // Gaussian elimination (the normal matrix is symmetric positive definite: no pivoting needed)
  for i in 1:5 loop
    for k in 1:5 loop
      if k > i then
        factor := A[k, i]/A[i, i];
        for j in 1:5 loop
          A[k, j] := A[k, j] - factor*A[i, j];
        end for;
        b[k] := b[k] - factor*b[i];
      end if;
    end for;
  end for;
  c := zeros(5);
  for m in 1:5 loop
    c[6 - m] := (b[6 - m] - sum((if j > 6 - m then A[6 - m, j]*c[j] else 0) for j in 1:5))/A[6 - m, 6 - m];
  end for;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Least-squares fit of a quartic <i>c</i><sub>1</sub> + <i>c</i><sub>2</sub> <i>x</i> + &hellip; +
<i>c</i><sub>5</sub> <i>x</i><sup>4</sup> through 10 points (<i>x<sub>k</sub></i>, <i>y<sub>k</sub></i>).
</p>
<h4>Equations</h4>
<p>
The normal equations <i>A</i> <i>c</i> = <i>b</i>, with
<i>A<sub>ij</sub></i> = &sum;<sub><i>k</i></sub> <i>x<sub>k</sub></i><sup><i>i</i>+<i>j</i>&minus;2</sup> and
<i>b<sub>i</sub></i> = &sum;<sub><i>k</i></sub> <i>y<sub>k</sub></i> <i>x<sub>k</sub></i><sup><i>i</i>&minus;1</sup>,
solved by Gaussian elimination without pivoting (the normal matrix is symmetric positive definite when at least five
of the <i>x<sub>k</sub></i> differ) and back substitution.
</p>
<h4>Use</h4>
<p>
Called on parameters: the windows fit the solar transmittance and the absorptance of each pane, given at the
incidence angles 0, 10, &hellip;, 90 degrees, as quartics in the cosine of the angle, and evaluate them with
<a href=\"modelica://FastSmoothBuildings.Utilities.polynomial\">polynomial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end polynomialFit;
