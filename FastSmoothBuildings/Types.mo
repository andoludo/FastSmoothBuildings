within FastSmoothBuildings;
package Types "Types and constants"
  package Tilt "Tilt of a surface, as Buildings.Types.Tilt [rad]"
    constant Real Ceiling = 0 "Ceiling or roof: the surface faces up";
    constant Real Wall = 1.5707963267948966 "Wall";
    constant Real Floor = 3.141592653589793 "Floor: the surface faces down";
    annotation (Documentation(info="<html>
<p>
Tilts of a surface in rad, as <code>Buildings.Types.Tilt</code>: 0 for a ceiling or a roof (the surface faces
up), &pi;/2 for a wall, &pi; for a floor (the surface faces down).
</p>
</html>"));
  end Tilt;

  package EfficiencyCurves "Efficiency curves of boilers, as Buildings.Fluid.Types.EfficiencyCurves"
    constant Integer Constant = 1 "eta = a[1]";
    constant Integer Polynomial = 2 "eta = a[1] + a[2]*y + a[3]*y^2 + ...";
    constant Integer QuadraticLinear = 3 "eta = a[1] + a[2]*y + a[3]*y^2 + (a[4] + a[5]*y + a[6]*y^2)*T";
    annotation (Documentation(info="<html>
<p>
Codes of the efficiency curves of boilers, as <code>Buildings.Fluid.Types.EfficiencyCurves</code>: a constant,
a polynomial of the part load ratio <i>y</i>, or a polynomial of <i>y</i> and of the temperature <i>T</i>; the
values of the parameter <code>effCur</code> of
<a href=\"modelica://FastSmoothBuildings.Hydronics.Boiler\">Hydronics.Boiler</a>.
</p>
</html>"));
  end EfficiencyCurves;
  annotation (Documentation(info="<html>
<p>
Constants of the tilts of surfaces and of the efficiency curves of boilers, as Buildings.Types.Tilt and
Buildings.Fluid.Types.EfficiencyCurves.
</p>
</html>"));
end Types;
