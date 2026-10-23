within FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08;
function smoothTable
  "Quadratic in the condenser temperature through the rows at 35, 45 and 55 degC, linear between the source
   columns with the kinks smoothed over dTSou: a differentiable version of the table"
  input Real TConOut(unit="K");
  input Real TSource(unit="K");
  input Boolean heating "true: heating capacity, false: electrical power";
  input Real dTSou(unit="K") = 1 "Smoothing of the kinks of the interpolation in the source temperature";
  output Real y;
protected
  Real v[9] "Value at each source temperature";
  Real L[3] "Lagrange basis in the condenser temperature";
algorithm
  L[1] := (TConOut - TCon[2])*(TConOut - TCon[3])/((TCon[1] - TCon[2])*(TCon[1] - TCon[3]));
  L[2] := (TConOut - TCon[1])*(TConOut - TCon[3])/((TCon[2] - TCon[1])*(TCon[2] - TCon[3]));
  L[3] := (TConOut - TCon[1])*(TConOut - TCon[2])/((TCon[3] - TCon[1])*(TCon[3] - TCon[2]));
  for j in 1:9 loop
    v[j] := if heating then L[1]*QHea[1, j] + L[2]*QHea[2, j] + L[3]*QHea[3, j] else L[1]*PEle[1, j]
      + L[2]*PEle[2, j] + L[3]*PEle[3, j];
  end for;
  y := v[1] + (v[2] - v[1])/(TSou[2] - TSou[1])*(TSource - TSou[1]);
  for i in 2:8 loop
    y := y + ((v[i + 1] - v[i])/(TSou[i + 1] - TSou[i]) - (v[i] - v[i - 1])/(TSou[i] - TSou[i - 1]))
      *Utilities.positivePart(TSource - TSou[i], dTSou);
  end for;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heating capacity (<code>heating = true</code>) or electrical power of the Vitocal 251-A08 at a condenser outlet
temperature and a source temperature: a version of the table with continuous derivatives, for the equations of
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPump\">HeatPump</a>.
</p>
<h4>Equations</h4>
<p>
In the condenser outlet temperature <i>T<sub>c</sub></i>, a quadratic through the first three rows of the table,
at <i>T<sub>C,1</sub></i>, <i>T<sub>C,2</sub></i>, <i>T<sub>C,3</sub></i> = 35, 45 and 55 &deg;C, with the
Lagrange basis
</p>
<p>
<i>L<sub>k</sub></i>(<i>T<sub>c</sub></i>) = &prod;<sub><i>m</i> &ne; <i>k</i></sub> (<i>T<sub>c</sub></i>
&minus; <i>T<sub>C,m</sub></i>) / (<i>T<sub>C,k</sub></i> &minus; <i>T<sub>C,m</sub></i>), &nbsp;
<i>v<sub>j</sub></i> = &sum;<sub><i>k</i>=1..3</sub> <i>L<sub>k</sub></i> <i>Y<sub>k,j</sub></i>
</p>
<p>
at each source temperature <i>T<sub>S,j</sub></i> of the table, <i>Y</i> being <code>QHea</code> or
<code>PEle</code>. In the source temperature <i>T<sub>s</sub></i>, the piecewise linear interpolation of the
<i>v<sub>j</sub></i>, written as the first segment plus the change of slope at each inner breakpoint, each kink
smoothed by <a href=\"modelica://FastSmoothBuildings.Utilities.positivePart\">positivePart</a> over
<i>&delta;</i> = <code>dTSou</code>:
</p>
<p>
<i>y</i> = <i>v<sub>1</sub></i> + <i>s<sub>1</sub></i> (<i>T<sub>s</sub></i> &minus; <i>T<sub>S,1</sub></i>) +
&sum;<sub><i>j</i>=2..8</sub> (<i>s<sub>j</sub></i> &minus; <i>s<sub>j&minus;1</sub></i>)
positivePart(<i>T<sub>s</sub></i> &minus; <i>T<sub>S,j</sub></i>, <i>&delta;</i>), &nbsp;
<i>s<sub>j</sub></i> = (<i>v<sub>j+1</sub></i> &minus; <i>v<sub>j</sub></i>) / (<i>T<sub>S,j+1</sub></i> &minus;
<i>T<sub>S,j</sub></i>).
</p>
<h4>Accuracy</h4>
<ul>
<li>At 35, 45 and 55 &deg;C the quadratic passes through the rows of the table; the rows at 65 and 70 &deg;C are
not used, and above 55 &deg;C the quadratic extrapolates.</li>
<li>At a distance <i>x</i> from a breakpoint of the source temperature, the value differs from the linear
interpolation by (&radic;(<i>x</i><sup>2</sup> + <i>&delta;</i><sup>2</sup>) &minus; |<i>x</i>|)/2 times the
change of slope there: <i>&delta;</i>/2 at the breakpoint, about <i>&delta;</i><sup>2</sup>/(4 |<i>x</i>|) away
from it.</li>
<li>Below the first and above the last source temperature of the table, the value follows the first and the last
segment: it extrapolates linearly, where
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08.interpolate\">interpolate</a> holds the
edge value.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics.HeatPumps.Vitocal251A08</code>.</li>
</ul>
</html>"));
end smoothTable;
