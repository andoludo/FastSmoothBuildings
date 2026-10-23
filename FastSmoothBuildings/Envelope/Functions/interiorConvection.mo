within FastSmoothBuildings.Envelope.Functions;
function interiorConvection "Heat from a room surface to the air: natural convection, or a fixed coefficient"
  input Real dT(unit="K") "Surface minus air temperature";
  input Real A(unit="m2");
  input Real cPos;
  input Real cNeg;
  input Real hFix(unit="W/(m2.K)") "Fixed coefficient, 0 for the natural convection law";
  output Real Q_flow(unit="W");
algorithm
  Q_flow := if hFix > 0 then hFix*A*dT else Utilities.naturalConvection(dT, A, cPos, cNeg);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heat flow rate from a room surface to the room air, with <i>&Delta;T</i> the surface minus the air temperature:
</p>
<ul>
<li><i>Q</i> = <i>h<sub>fix</sub></i> <i>A</i> <i>&Delta;T</i> with a fixed coefficient <code>hFix</code> &gt; 0;</li>
<li>otherwise the natural convection of
<a href=\"modelica://FastSmoothBuildings.Utilities.naturalConvection\">naturalConvection</a>,
<i>Q</i> &asymp; <i>A</i> <i>c</i> |<i>&Delta;T</i>|<sup>4/3</sup> sign(<i>&Delta;T</i>), with <i>c</i> =
<code>cPos</code> when the surface is warmer than the air and <code>cNeg</code> when it is colder
(<a href=\"modelica://FastSmoothBuildings.Utilities.convectionCoefficient\">convectionCoefficient</a>).</li>
</ul>
<h4>Use</h4>
<p>
The room faces of every surface of <a href=\"modelica://FastSmoothBuildings.Envelope\">Envelope</a>; the zone sets
<code>hFix</code> from its parameter <code>hConInt</code>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end interiorConvection;
