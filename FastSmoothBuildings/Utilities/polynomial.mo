within FastSmoothBuildings.Utilities;
function polynomial "c[1] + c[2]*x + ... + c[n]*x^(n-1)"
  input Real c[:];
  input Real x;
  output Real y;
algorithm
  y := sum(c[i]*x^(i - 1) for i in 1:size(c, 1));
end polynomial;
