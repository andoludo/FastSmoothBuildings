within FastSmoothBuildings.Envelope.Functions;
function overhangSunlitFraction
  "Fraction of a window lit by the direct sun below an overhang: the superposition of rectangles of
   Buildings.HeatTransfer.Windows.BaseClasses.Overhang, with its smooth minima, maxima and steps, explicit"
  input Real verAzi(unit="rad") "Angle between the horizontal projection of the sun's rays and the wall normal";
  input Real alt(unit="rad") "Solar altitude";
  input Real side "Positive when the sun is left of the normal, seen from outside: the width wL shades";
  input Real hWin(unit="m") "Window height";
  input Real wWin(unit="m") "Window width";
  input Real dep(unit="m") "Depth of the overhang";
  input Real gap(unit="m") "Distance between the top of the window and the overhang";
  input Real wL(unit="m") "Extension of the overhang beyond the left edge of the window";
  input Real wR(unit="m") "Extension of the overhang beyond the right edge of the window";
  output Real fraSun "Sunlit fraction of the window area";
protected
  Real AWin(unit="m2") = hWin*wWin;
  Real del(unit="m") = wWin/100 "Width over which the minima and maxima are smoothed";
  Real w(unit="m") "wL or wR, depending on the side of the sun";
  Real tmpH[4](each unit="m") "Heights of the rectangles of the superposition";
  Real tmpW[4](each unit="m") "Widths of the rectangles of the superposition";
  Real y1(unit="m") "Vertical distance between the overhang and the lower edge of its shadow";
  Real x1(unit="m") "Horizontal distance between the window side and the corner of the shadow";
  Real ratio "y1/x1";
  Real x2(unit="m") "Where the shadow line crosses the lower edge of a rectangle";
  Real cut(unit="m");
  Real area[4](each unit="m2") "Shaded areas of the rectangles";
  Real shdArea(unit="m2");
algorithm
  w := Utilities.regStep(side, wL, wR, 0.005);
  tmpH := {gap, gap + hWin, gap, gap + hWin};
  tmpW := {w + wWin, w, w, w + wWin};
  // tan(alt)/cos(verAzi) and tan(verAzi), bounded when the sun grazes the wall or stands behind it
  y1 := dep*sin(alt)/Utilities.smoothMax(cos(alt), 1e-3, 1e-4)/Utilities.smoothMax(cos(verAzi), 1e-3, 1e-4);
  x1 := dep*sin(verAzi)/Utilities.smoothMax(cos(verAzi), 1e-3, 1e-4);
  ratio := y1/Utilities.smoothMax(x1, 1e-8*hWin, 1e-9*hWin);
  for i in 1:4 loop
    x2 := x1*tmpH[i]/Utilities.smoothMax(y1, 1e-8*hWin, 1e-9*hWin);
    cut := Utilities.smoothMin(x1, x2, del) - tmpW[i];
    area[i] := Utilities.smoothMin(y1, tmpH[i], del)*tmpW[i]
      - Utilities.smoothMin(y1, tmpH[i], del)*Utilities.smoothMin(x2, y1, del)/2
      + Utilities.smoothMax(ratio*cut, 0, del)*Utilities.smoothMax(cut, 0, del)/2;
  end for;
  shdArea := area[4] + area[3] - area[2] - area[1];
  // all in the shade with the sun behind the wall or below the horizon
  fraSun := Utilities.smoothMin(Utilities.smoothMax(1 - Utilities.smoothMax(
    Utilities.regStep(pi/2 - verAzi, shdArea, AWin, 0.01), Utilities.regStep(alt, shdArea, AWin, 0.01), 0.01)/AWin,
    0, 0.01), 1, 0.01);
end overhangSunlitFraction;
