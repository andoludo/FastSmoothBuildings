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
end polynomialFit;
