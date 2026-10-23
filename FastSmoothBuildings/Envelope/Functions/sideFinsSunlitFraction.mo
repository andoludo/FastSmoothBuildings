within FastSmoothBuildings.Envelope.Functions;
function sideFinsSunlitFraction
  "Fraction of a window lit by the direct sun between two side fins: the superposition of rectangles of
   Buildings.HeatTransfer.Windows.BaseClasses.SideFins, with its smooth minima, maxima and steps, explicit"
  input Real verAzi(unit="rad") "Angle between the horizontal projection of the sun's rays and the wall normal";
  input Real alt(unit="rad") "Solar altitude";
  input Real hWin(unit="m") "Window height";
  input Real wWin(unit="m") "Window width";
  input Real dep(unit="m") "Depth of the fins";
  input Real gap(unit="m") "Distance between the window edges and the fins";
  input Real h(unit="m") "Extension of the fins above the top of the window";
  output Real fraSun "Sunlit fraction of the window area";
protected
  constant Real delta = 1e-6 "Small number to avoid a division by zero";
  Real AWin(unit="m2") = hWin*wWin;
  Real del(unit="m") = wWin/100 "Width over which the minima and maxima are smoothed";
  Real tmpH[4](each unit="m") = {h + hWin, h, h + hWin, h} "Heights of the rectangles of the superposition";
  Real tmpW[4](each unit="m") = {gap + wWin, gap + wWin, gap, gap} "Widths of the rectangles of the superposition";
  Real verAzi_t "tan(verAzi), at least delta";
  Real verAzi_c "cos(verAzi), at least delta";
  Real alt_t "tan(alt), at least delta";
  Real lambda_t "Tangent of the angle between the horizontal and the sun's rays projected on the wall";
  Real y2(unit="m") "Vertical distance between the top of a fin and the corner of its shadow";
  Real x2(unit="m") "Horizontal distance between a fin and the corner of its shadow";
  Real minX(unit="m");
  Real minY(unit="m");
  Real area[4](each unit="m2") "Shaded areas of the rectangles";
  Real shdArea(unit="m2");
algorithm
  verAzi_c := Utilities.smoothMax(cos(verAzi), delta, delta/10);
  verAzi_t := Utilities.smoothMax(sin(verAzi)/Utilities.smoothMax(cos(verAzi), 1e-3, 1e-4), delta, delta/10);
  alt_t := Utilities.smoothMax(sin(alt)/Utilities.smoothMax(cos(alt), 1e-3, 1e-4), delta, delta/10);
  lambda_t := Utilities.smoothMax(alt_t/verAzi_t, delta, delta/10);
  y2 := dep*alt_t/verAzi_c;
  x2 := dep*verAzi_t;
  for i in 1:4 loop
    minX := Utilities.smoothMin(tmpH[i]/lambda_t, Utilities.smoothMin(x2, tmpW[i], del), del);
    minY := Utilities.smoothMin(tmpH[i], Utilities.smoothMin(y2, tmpW[i]*lambda_t, del), del);
    area[i] := tmpH[i]*minX - minX*minY/2;
  end for;
  shdArea := area[1] + area[4] - area[2] - area[3];
  // all in the shade with the sun behind the wall or below the horizon
  fraSun := 1 - Utilities.smoothMax(Utilities.regStep(pi/2 - verAzi, shdArea, AWin, 0.01),
    Utilities.regStep(alt, shdArea, AWin, 0.01), 1e-4*AWin)/AWin;
end sideFinsSunlitFraction;
