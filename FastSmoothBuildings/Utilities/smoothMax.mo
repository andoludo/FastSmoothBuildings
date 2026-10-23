within FastSmoothBuildings.Utilities;
function smoothMax "Once continuously differentiable approximation of max(x1, x2)"
  input Real x1;
  input Real x2;
  input Real deltaX;
  output Real y;
algorithm
  y := regStep(x1 - x2, x1, x2, deltaX);
end smoothMax;
