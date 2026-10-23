within FastSmoothBuildings.Envelope.Functions;
function exteriorExchange
  "Heat from an outer surface to the outside: natural and wind-driven convection (Buildings TemperatureWind)
   or a fixed coefficient, and long-wave exchange with sky and ground"
  input Real T(unit="K") "Surface temperature";
  input Real A(unit="m2");
  input Real til(unit="rad");
  input Real azi(unit="rad");
  input Real cPos;
  input Real cNeg;
  input Real eps "Long-wave emissivity";
  input Real hFix(unit="W/(m2.K)") "Fixed convection coefficient, 0 for the wind-dependent law";
  input Real TOut(unit="K");
  input Real TBlaSky(unit="K");
  input Real v(unit="m/s") "Wind speed";
  input Real dir(unit="rad") "Wind direction, 0 from the north";
  input Real R = 1.67 "Surface roughness factor (rough)";
  output Real Q_flow(unit="W");
protected
  Real W "Wind direction modifier: 1 windward, 0.5 leeward, 0.75 without wind";
  Real hF(unit="W/(m2.K)") "Forced convection coefficient";
algorithm
  W := 0.75 + (0.5*(0.5 + 0.5*(cos(azi + pi - dir) - cos(1.7453292519943295))
    /sqrt((cos(azi + pi - dir) - cos(1.7453292519943295))^2 + 0.0025)) - 0.25)
    *(0.5 + 0.5*(v - 0.25)/sqrt((v - 0.25)^2 + 0.015625));
  hF := 2.537*W*R*2/A^0.25*(v^2 + 0.0625)^0.25;
  Q_flow := (if hFix > 0 then hFix*A*(T - TOut) else Utilities.naturalConvection(T - TOut, A, cPos, cNeg)
    + A*hF*(T - TOut)) + skyExchange(T, A, til, eps, TOut, TBlaSky);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heat flow rate <i>Q</i> from an outer surface to the outside: convection with the outdoor air and long-wave
exchange with sky and ground. Used by
<a href=\"modelica://FastSmoothBuildings.Envelope.OuterWall\">OuterWall</a>.
</p>
<h4>Equations</h4>
<p>
With a fixed coefficient <code>hFix</code> &gt; 0,
</p>
<p>
<i>Q</i> = <i>h<sub>fix</sub></i> <i>A</i> (<i>T</i> &minus; <i>T<sub>out</sub></i>) + <i>Q<sub>sky</sub></i>;
</p>
<p>
otherwise natural and forced convection,
</p>
<p>
<i>Q</i> = <i>Q<sub>nat</sub></i> + <i>A</i> <i>h<sub>F</sub></i> (<i>T</i> &minus; <i>T<sub>out</sub></i>) +
<i>Q<sub>sky</sub></i>, &nbsp;
<i>h<sub>F</sub></i> = 2.537 <i>W</i> <i>R</i> (2/<i>A</i><sup>1/4</sup>)
(<i>v</i><sup>2</sup> + 0.25<sup>2</sup>)<sup>1/4</sup>,
</p>
<p>
<i>Q<sub>nat</sub></i> from
<a href=\"modelica://FastSmoothBuildings.Utilities.naturalConvection\">naturalConvection</a> with the coefficients
<code>cPos</code> and <code>cNeg</code> of the outer face, <i>Q<sub>sky</sub></i> from
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.skyExchange\">skyExchange</a>, <i>R</i> the roughness
factor (1.67, rough) and <i>W</i> the wind direction modifier:
</p>
<p>
<i>W</i> = 0.75 + (0.5 <i>s<sub>dir</sub></i> &minus; 0.25) <i>s<sub>v</sub></i>,
</p>
<p>
<i>s<sub>dir</sub></i> a smooth step from 0 to 1 when cos(<code>azi</code> + &pi; &minus; <code>dir</code>) rises
above cos&nbsp;100&deg; (the wind blows on the surface; width 0.05), <i>s<sub>v</sub></i> a smooth step from 0 to
1 when the wind speed <i>v</i> rises above 0.25 m/s (width 0.125 m/s). <i>W</i> is 1 on the windward side, 0.5 on
the leeward side and 0.75 without wind.
</p>
<h4>Smoothing</h4>
<ul>
<li>The steps of <i>W</i> are <i>x</i>/&radic;(<i>x</i><sup>2</sup> + <i>&delta;</i><sup>2</sup>) ramps.</li>
<li>&radic;<i>v</i> is regularised as (<i>v</i><sup>2</sup> + 0.25<sup>2</sup>)<sup>1/4</sup>: finite derivative
without wind.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
The <code>TemperatureWind</code> law of the exterior convection of Buildings, with smooth steps;
2/<i>A</i><sup>1/4</sup>
is &radic;(<i>P</i>/<i>A</i>) for a square surface of perimeter <i>P</i> = 4 &radic;<i>A</i>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end exteriorExchange;
