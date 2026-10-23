within FastSmoothBuildings;
package Types "Types and constants"
  package Tilt "Tilt of a surface, as Buildings.Types.Tilt [rad]"
    constant Real Ceiling = 0 "Ceiling or roof: the surface faces up";
    constant Real Wall = 1.5707963267948966 "Wall";
    constant Real Floor = 3.141592653589793 "Floor: the surface faces down";
  end Tilt;

  package EfficiencyCurves "Efficiency curves of boilers, as Buildings.Fluid.Types.EfficiencyCurves"
    constant Integer Constant = 1 "eta = a[1]";
    constant Integer Polynomial = 2 "eta = a[1] + a[2]*y + a[3]*y^2 + ...";
    constant Integer QuadraticLinear = 3 "eta = a[1] + a[2]*y + a[3]*y^2 + (a[4] + a[5]*y + a[6]*y^2)*T";
  end EfficiencyCurves;
end Types;
