within FastSmoothBuildings.Envelope.Functions;
function interiorConvection "Heat from a room surface to the air: natural convection, or a fixed coefficient"
  input Real dT(unit="K") "Surface minus air temperature";
  input Real A(unit="m2");
  input Real cPos;
  input Real cNeg;
  input Real hFix(unit="W/(m2.K)") "Fixed coefficient, 0 for the natural convection law";
  output Real Q_flow(unit="W");
algorithm
  Q_flow := if hFix > 0 then hFix*A*dT else Utilities.naturalConvection(dT, A, cPos, cNeg);
end interiorConvection;
