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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Fraction <i>f</i> of the area of a window lit by the direct sun below an overhang of depth <code>dep</code>, at the
distance <code>gap</code> above the top of the window and extending <code>wL</code> and <code>wR</code> beyond its
left and right edges (seen from outside). The sun is given by its altitude <code>alt</code>, the angle
<code>verAzi</code> between the horizontal projection of its rays and the normal of the wall, and
<code>side</code>, positive when it is left of the normal.
</p>
<h4>Equations</h4>
<p>
The extension on the side of the sun, <i>w</i> = <code>wL</code> when <code>side</code> &gt; 0 and
<code>wR</code> otherwise, and the corner of the shadow,
</p>
<p>
<i>y<sub>1</sub></i> = <code>dep</code> tan(<code>alt</code>)/cos(<code>verAzi</code>), &nbsp;
<i>x<sub>1</sub></i> = <code>dep</code> tan(<code>verAzi</code>).
</p>
<p>
The shaded area is the superposition of four rectangles of heights <i>H</i> = {<code>gap</code>,
<code>gap</code> + <code>hWin</code>, <code>gap</code>, <code>gap</code> + <code>hWin</code>} and widths
<i>W</i> = {<i>w</i> + <code>wWin</code>, <i>w</i>, <i>w</i>, <i>w</i> + <code>wWin</code>}; for each,
with <i>x<sub>2</sub></i> = <i>x<sub>1</sub></i> <i>H</i>/<i>y<sub>1</sub></i> and
<i>u</i> = min(<i>x<sub>1</sub></i>, <i>x<sub>2</sub></i>) &minus; <i>W</i>,
</p>
<p>
<i>a</i> = min(<i>y<sub>1</sub></i>, <i>H</i>) <i>W</i> &minus; min(<i>y<sub>1</sub></i>, <i>H</i>)
min(<i>x<sub>2</sub></i>, <i>y<sub>1</sub></i>)/2 + max((<i>y<sub>1</sub></i>/<i>x<sub>1</sub></i>) <i>u</i>, 0)
max(<i>u</i>, 0)/2,
</p>
<p>
<i>A<sub>shd</sub></i> = <i>a<sub>4</sub></i> + <i>a<sub>3</sub></i> &minus; <i>a<sub>2</sub></i> &minus;
<i>a<sub>1</sub></i>. The whole window is in the shade when the sun is behind the wall (<code>verAzi</code> &gt;
&pi;/2) or below the horizon (<code>alt</code> &lt; 0):
</p>
<p>
<i>f</i> = 1 &minus; <i>A<sub>shd</sub></i>/<i>A<sub>win</sub></i>, limited to [0, 1], &nbsp;
<i>A<sub>win</sub></i> = <code>hWin</code> <code>wWin</code>.
</p>
<h4>Smoothing</h4>
<ul>
<li>min and max are <a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a> over a hundredth of the width of the
window, the limits of <i>f</i> over 0.01.</li>
<li>The tangents are a sine over a cosine bounded below by 10<sup>&minus;3</sup>; <i>x<sub>1</sub></i> and
<i>y<sub>1</sub></i> are bounded below by 10<sup>&minus;8</sup> <code>hWin</code> where they divide.</li>
<li>The side of the sun is chosen by <a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a> over
0.005, the shade behind the wall and below the horizon by regStep over 0.01 rad.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
The superposition of rectangles of <code>Buildings.HeatTransfer.Windows.BaseClasses.Overhang</code>, written
explicitly with smooth minima, maxima and steps.
</p>
<h4>Validation</h4>
<p>
Within 0.0006 of the closed form of the shadow; for instance 0.5000 = 1 &minus; tan&nbsp;45&deg;/2 for a sun
facing the wall 45&deg; high and an overhang 1 m deep, 10 m wider on each side, flush with the top of a window
2 m high.
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a> with <code>haveOverhang = true</code>;
<a href=\"modelica://FastSmoothBuildings.Envelope.Validation.ShadingFractions\">Validation.ShadingFractions</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end overhangSunlitFraction;
