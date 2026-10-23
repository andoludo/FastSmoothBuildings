within FastSmoothBuildings.Utilities;
function smoothLimitInside
  "Once continuously differentiable limitation of x to [l + deltaX, u - deltaX], strictly inside [l, u] (for
   arguments of functions singular at the bounds, as acos at -1 and 1)"
  input Real x;
  input Real l;
  input Real u;
  input Real deltaX;
  output Real y;
algorithm
  y := smoothMin(smoothMax(x, l + deltaX, deltaX), u - deltaX, deltaX);
end smoothLimitInside;
