within FastSmoothBuildings.Controls;
function smoothMaxN "Smooth maximum of a vector"
  input Real u[:];
  input Real delta = 1e-3;
  output Real y;
algorithm
  y := u[1];
  for i in 2:size(u, 1) loop
    y := Utilities.smoothMax(y, u[i], delta);
  end for;
end smoothMaxN;
