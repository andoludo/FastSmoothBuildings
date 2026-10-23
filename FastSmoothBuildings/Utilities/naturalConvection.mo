within FastSmoothBuildings.Utilities;
function naturalConvection
  "Heat flow from a surface to the air q = A*c*|dT|^(4/3) (Buildings natural convection), smooth at dT = 0"
  input Real dT(unit="K") "Surface minus air temperature";
  input Real A(unit="m2") "Surface area";
  input Real cPos "Coefficient when the surface is warmer than the air";
  input Real cNeg "Coefficient when the surface is colder than the air";
  input Real dT0(unit="K") = 0.1 "Temperature difference below which the law is regularised";
  output Real Q_flow(unit="W");
algorithm
  Q_flow := A*((cPos + cNeg)/2 + (cPos - cNeg)/2*dT/sqrt(dT^2 + dT0^2))*dT*(dT^2 + dT0^2)^(1/6);
end naturalConvection;
