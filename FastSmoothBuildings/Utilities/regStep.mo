within FastSmoothBuildings.Utilities;
function regStep "Once continuously differentiable step from y2 (x < -x_small) to y1 (x > x_small)"
  input Real x;
  input Real y1;
  input Real y2;
  input Real x_small = 1e-5;
  output Real y;
algorithm
  y := if x > x_small then y1 else if x < -x_small then y2 else (x/x_small)*((x/x_small)^2 - 3)*(y2 - y1)/4 + (y1 + y2)/2;
end regStep;
