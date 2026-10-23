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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
The coefficient <i>c</i> of the natural convection law <i>q</i> = <i>c</i> |&Delta;<i>T</i>|<sup>1/3</sup>
&Delta;<i>T</i> of Buildings (see
<a href=\"modelica://FastSmoothBuildings.Utilities.naturalConvection\">naturalConvection</a>), in
W/(m<sup>2</sup> K<sup>4/3</sup>), from the tilt of the surface and the sign of the temperature difference.
</p>
<h4>Equations</h4>
<table summary=\"Coefficients of convectionCoefficient\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Surface</th><th>Tilt</th><th>Surface warmer than the air</th><th>Surface colder</th></tr>
<tr><td>Ceiling</td><td>sin(<code>til</code>) = 0, cos(<code>til</code>) &gt; 0</td><td>0.76</td><td>1.51</td></tr>
<tr><td>Floor</td><td>sin(<code>til</code>) = 0, cos(<code>til</code>) &lt; 0</td><td>1.51</td><td>0.76</td></tr>
<tr><td>Any other</td><td></td><td>1.3</td><td>1.3</td></tr>
</table>
<p>
A surface counts as horizontal when |sin(<code>til</code>)| &lt; 10<sup>&minus;6</sup>; an inclined surface takes
the coefficient of a wall. A warm ceiling and a cold floor stratify the air: the lower coefficient.
</p>
<h4>Use</h4>
<p>
The function switches on its arguments: call it on parameters only, as the surfaces do (<code>til</code> for the
room side, <code>pi - til</code> for a side that faces the other way: the outside of a window, side <i>b</i> of an
internal wall), so that the coefficients are evaluated before the
simulation. The tilt follows <a href=\"modelica://FastSmoothBuildings.Types.Tilt\">Types.Tilt</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end convectionCoefficient;
