within FastSmoothBuildings.Utilities;
function naturalConvection
  "Heat flow from a surface to the air q = A*c*|dT|^(4/3) (Buildings natural convection), smooth at dT = 0"
  input Real dT(unit="K") "Surface minus air temperature";
  input Real A(unit="m2") "Surface area";
  input Real cPos "Coefficient when the surface is warmer than the air";
  input Real cNeg "Coefficient when the surface is colder than the air";
  input Real dT0(unit="K") = 0.1 "Temperature difference below which the law is regularised";
  output Real Q_flow(unit="W");
algorithm
  Q_flow := A*((cPos + cNeg)/2 + (cPos - cNeg)/2*dT/sqrt(dT^2 + dT0^2))*dT*(dT^2 + dT0^2)^(1/6);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heat flow rate from a surface to the air by natural convection, <i>Q</i> = <i>A</i> <i>c</i>
|&Delta;<i>T</i>|<sup>1/3</sup> &Delta;<i>T</i> as in Buildings, regularised at small temperature differences so
that it is infinitely differentiable.
</p>
<h4>Equations</h4>
<p>
With &Delta;<i>T</i> = <code>dT</code>, the surface minus the air temperature, and
<i>&Delta;T<sub>0</sub></i> = <code>dT0</code>,
</p>
<p>
<i>Q</i> = <i>A</i> ((<i>c<sub>+</sub></i> + <i>c<sub>&minus;</sub></i>)/2 + (<i>c<sub>+</sub></i> &minus;
<i>c<sub>&minus;</sub></i>)/2 &Delta;<i>T</i>/&radic;(&Delta;<i>T</i><sup>2</sup> +
<i>&Delta;T<sub>0</sub></i><sup>2</sup>)) &Delta;<i>T</i> (&Delta;<i>T</i><sup>2</sup> +
<i>&Delta;T<sub>0</sub></i><sup>2</sup>)<sup>1/6</sup>.
</p>
<p>
For |&Delta;<i>T</i>| &gt;&gt; <i>&Delta;T<sub>0</sub></i>, <i>Q</i> tends to <i>A</i> <i>c<sub>+</sub></i>
&Delta;<i>T</i><sup>4/3</sup> when the surface is warmer (<code>cPos</code>) and to &minus;<i>A</i>
<i>c<sub>&minus;</sub></i> |&Delta;<i>T</i>|<sup>4/3</sup> when it is colder (<code>cNeg</code>). At
&Delta;<i>T</i> = 0 the conductance is <i>A</i> (<i>c<sub>+</sub></i> + <i>c<sub>&minus;</sub></i>)/2
<i>&Delta;T<sub>0</sub></i><sup>1/3</sup> instead of 0, and the switch between the two coefficients is spread over
a few <i>&Delta;T<sub>0</sub></i>. C-infinity for <i>&Delta;T<sub>0</sub></i> &gt; 0.
</p>
<h4>Use</h4>
<p>
<code>dT0</code> = 0.1 K by default. The coefficients come from
<a href=\"modelica://FastSmoothBuildings.Utilities.convectionCoefficient\">convectionCoefficient</a>; the interior
convection and the exterior exchange of the surfaces call this function when no fixed coefficient is given.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end naturalConvection;
