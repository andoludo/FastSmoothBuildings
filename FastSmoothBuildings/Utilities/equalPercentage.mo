within FastSmoothBuildings.Utilities;
function equalPercentage
  "Equal-percentage valve characteristic with leakage (Buildings.Fluid.Actuators.BaseClasses.equalPercentage):
   linear below delta0/2, R^(y-1) above 1.5*delta0, a cubic Hermite joining them"
  input Real y "Opening";
  input Real R "Rangeability";
  input Real l "Leakage at y = 0";
  input Real delta0 "Width of the linear range near closure";
  output Real phi;
protected
  Real x0 = delta0/2;
  Real x1 = 1.5*delta0;
  Real y0 = l + x0*(R^(delta0 - 1) - l)/delta0;
  Real s0 = (R^(delta0 - 1) - l)/delta0;
  Real y1 = R^(x1 - 1);
  Real s1 = log(R)*R^(x1 - 1);
  Real h;
  Real u;
algorithm
  if y < x0 then
    phi := l + y*(R^(delta0 - 1) - l)/delta0;
  elseif y > x1 then
    phi := R^(y - 1);
  else
    h := x1 - x0;
    u := (y - x0)/h;
    phi := (2*u^3 - 3*u^2 + 1)*y0 + (u^3 - 2*u^2 + u)*h*s0 + (-2*u^3 + 3*u^2)*y1 + (u^3 - u^2)*h*s1;
  end if;
end equalPercentage;
