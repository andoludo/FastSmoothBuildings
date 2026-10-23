within FastSmoothBuildings.Envelope.Functions;
function exteriorExchange
  "Heat from an outer surface to the outside: natural and wind-driven convection (Buildings TemperatureWind)
   or a fixed coefficient, and long-wave exchange with sky and ground"
  input Real T(unit="K") "Surface temperature";
  input Real A(unit="m2");
  input Real til(unit="rad");
  input Real azi(unit="rad");
  input Real cPos;
  input Real cNeg;
  input Real eps "Long-wave emissivity";
  input Real hFix(unit="W/(m2.K)") "Fixed convection coefficient, 0 for the wind-dependent law";
  input Real TOut(unit="K");
  input Real TBlaSky(unit="K");
  input Real v(unit="m/s") "Wind speed";
  input Real dir(unit="rad") "Wind direction, 0 from the north";
  input Real R = 1.67 "Surface roughness factor (rough)";
  output Real Q_flow(unit="W");
protected
  Real W "Wind direction modifier: 1 windward, 0.5 leeward, 0.75 without wind";
  Real hF(unit="W/(m2.K)") "Forced convection coefficient";
algorithm
  W := 0.75 + (0.5*(0.5 + 0.5*(cos(azi + pi - dir) - cos(1.7453292519943295))
    /sqrt((cos(azi + pi - dir) - cos(1.7453292519943295))^2 + 0.0025)) - 0.25)
    *(0.5 + 0.5*(v - 0.25)/sqrt((v - 0.25)^2 + 0.015625));
  hF := 2.537*W*R*2/A^0.25*(v^2 + 0.0625)^0.25;
  Q_flow := (if hFix > 0 then hFix*A*(T - TOut) else Utilities.naturalConvection(T - TOut, A, cPos, cNeg)
    + A*hF*(T - TOut)) + skyExchange(T, A, til, eps, TOut, TBlaSky);
end exteriorExchange;
