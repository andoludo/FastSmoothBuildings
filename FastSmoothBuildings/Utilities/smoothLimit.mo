within FastSmoothBuildings.Utilities;
function smoothLimit
  "Once continuously differentiable limitation of x to [l, u]: exactly l below l - deltaX and u above u + deltaX,
   x between l + deltaX and u - deltaX, quadratic blends in between that never leave [l, u]"
  input Real x;
  input Real l;
  input Real u;
  input Real deltaX "Half width of the blends, below (u - l)/2";
  output Real y;
protected
  Real z "x limited from below";
algorithm
  z := if x > l + deltaX then x else if x < l - deltaX then l else l + (x - l + deltaX)^2/(4*deltaX);
  y := if z < u - deltaX then z else if z > u + deltaX then u else u - (u + deltaX - z)^2/(4*deltaX);
end smoothLimit;
