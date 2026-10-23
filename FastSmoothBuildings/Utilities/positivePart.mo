within FastSmoothBuildings.Utilities;
function positivePart "Smooth max(x, 0): 0.5*(x + sqrt(x^2 + delta^2))"
  input Real x;
  input Real delta;
  output Real y;
algorithm
  y := 0.5*(x + sqrt(x^2 + delta^2));
end positivePart;
