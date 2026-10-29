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
  Real minX[4](each unit="m") "Width of the shadow in each rectangle";
  Real minY[4](each unit="m") "Height of the shadow in each rectangle";
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
    minX[i] := Utilities.smoothMin(tmpH[i]/lambda_t, Utilities.smoothMin(x2, tmpW[i], del), del);
    minY[i] := Utilities.smoothMin(tmpH[i], Utilities.smoothMin(y2, tmpW[i]*lambda_t, del), del);
    area[i] := tmpH[i]*minX[i] - minX[i]*minY[i]/2;
  end for;
  shdArea := area[1] + area[4] - area[2] - area[3];
  // all in the shade with the sun behind the wall or below the horizon
  fraSun := 1 - Utilities.smoothMax(Utilities.regStep(pi/2 - verAzi, shdArea, AWin, 0.01),
    Utilities.regStep(alt, shdArea, AWin, 0.01), 1e-4*AWin)/AWin;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Fraction <i>f</i> of the area of a window lit by the direct sun between two side fins of depth <code>dep</code>, at
the distance <code>gap</code> from the side edges of the window and extending <code>h</code> above its top. The sun
is given by its altitude <code>alt</code> and the angle <code>verAzi</code> between the horizontal projection of its
rays and the normal of the wall; both fins being alike, the side of the sun is not needed.
</p>
<h4>Equations</h4>
<p>
With tan(<code>verAzi</code>), cos(<code>verAzi</code>) and tan(<code>alt</code>) bounded below by
<i>&delta;</i> = 10<sup>&minus;6</sup>, and <i>&lambda;</i> = tan(<code>alt</code>)/tan(<code>verAzi</code>), the
tangent of the angle between the horizontal and the sun's rays projected on the wall, the corner of the shadow of
a fin is at
</p>
<p>
<i>y<sub>2</sub></i> = <code>dep</code> tan(<code>alt</code>)/cos(<code>verAzi</code>), &nbsp;
<i>x<sub>2</sub></i> = <code>dep</code> tan(<code>verAzi</code>).
</p>
<p>
The shaded area is the superposition of four rectangles of heights <i>H</i> = {<code>h</code> + <code>hWin</code>,
<code>h</code>, <code>h</code> + <code>hWin</code>, <code>h</code>} and widths <i>W</i> = {<code>gap</code> +
<code>wWin</code>, <code>gap</code> + <code>wWin</code>, <code>gap</code>, <code>gap</code>}; for each,
</p>
<p>
<i>m<sub>x</sub></i> = min(<i>H</i>/<i>&lambda;</i>, <i>x<sub>2</sub></i>, <i>W</i>), &nbsp;
<i>m<sub>y</sub></i> = min(<i>H</i>, <i>y<sub>2</sub></i>, <i>W</i> <i>&lambda;</i>), &nbsp;
<i>a</i> = <i>H</i> <i>m<sub>x</sub></i> &minus; <i>m<sub>x</sub></i> <i>m<sub>y</sub></i>/2,
</p>
<p>
<i>A<sub>shd</sub></i> = <i>a<sub>1</sub></i> + <i>a<sub>4</sub></i> &minus; <i>a<sub>2</sub></i> &minus;
<i>a<sub>3</sub></i>, and <i>f</i> = 1 &minus; <i>A<sub>shd</sub></i>/<i>A<sub>win</sub></i>, the whole window
<i>A<sub>win</sub></i> = <code>hWin</code> <code>wWin</code> in the shade when the sun is behind the wall
(<code>verAzi</code> &gt; &pi;/2) or below the horizon (<code>alt</code> &lt; 0).
</p>
<h4>Smoothing</h4>
<ul>
<li>min is <a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a> over a hundredth of the
width of the window; the bounds at <i>&delta;</i> are
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a>, and the tangents a sine over a cosine
bounded below by 10<sup>&minus;3</sup>.</li>
<li>The shade behind the wall and below the horizon is chosen by
<a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a> over 0.01 rad, the larger of the two shaded
areas by smoothMax over 10<sup>&minus;4</sup> <i>A<sub>win</sub></i>.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
The superposition of rectangles of <code>Buildings.HeatTransfer.Windows.BaseClasses.SideFins</code>, written
explicitly with smooth minima, maxima and steps.
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a> with <code>haveSideFins = true</code>;
<a href=\"modelica://FastSmoothBuildings.Envelope.Validation.ShadingFractions\">Validation.ShadingFractions</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end sideFinsSunlitFraction;
