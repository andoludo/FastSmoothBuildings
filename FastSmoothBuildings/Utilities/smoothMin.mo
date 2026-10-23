within FastSmoothBuildings.Utilities;
function smoothMin "Once continuously differentiable approximation of min(x1, x2)"
  input Real x1;
  input Real x2;
  input Real deltaX;
  output Real y;
algorithm
  y := regStep(x2 - x1, x1, x2, deltaX);
end smoothMin;
