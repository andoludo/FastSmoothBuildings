within FastSmoothBuildings.Utilities;
function convectionCoefficient
  "Natural convection coefficient of Buildings for a surface tilt: wall 1.3, ceiling 0.76/1.51, floor 1.51/0.76"
  input Real til(unit="rad") "Tilt: 0 for a ceiling, pi/2 for a wall, pi for a floor";
  input Boolean warmer "true: the coefficient when the surface is warmer than the air";
  output Real c;
algorithm
  if abs(sin(til)) < 1e-6 and cos(til) > 0 then
    c := if warmer then 0.76 else 1.51;
  elseif abs(sin(til)) < 1e-6 and cos(til) < 0 then
    c := if warmer then 1.51 else 0.76;
  else
    c := 1.3;
  end if;
end convectionCoefficient;
