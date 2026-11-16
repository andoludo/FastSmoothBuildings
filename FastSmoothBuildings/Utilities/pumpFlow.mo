within FastSmoothBuildings.Utilities;
function pumpFlow
  "Flow of a pump relative to its nominal flow at a head relative to its nominal head: the inverse of the decreasing
   curve 1.14 - 0.14 x^n through (0, 1.14), (1, 1) and (2, 0.42), zero beyond the shut-off head"
  input Real h "Head relative to the nominal head, at the speed of the pump";
  output Real x "Flow relative to the nominal flow";
protected
  constant Real a = 1.14 "Head at zero flow, relative";
  constant Real k = 0.14 "Head lost at the nominal flow, relative";
  constant Real n = 2.3625700793847084 "Exponent through (2, 0.42): log2(0.72/0.14)";
  constant Real delta = 1e-4 "Width of the smooth positive part at the shut-off head";
  constant Real xMin = 1e-10 "Floor of the argument of the root";
algorithm
  x := (positivePart(a - h, delta)/k + xMin)^(1/n);
  annotation (Documentation(info="<html>
<p>
The head of the pump relative to its nominal head, <i>h</i>, falls with the flow relative to its nominal flow,
<i>x</i>, as
</p>
<p>
<i>h</i>(<i>x</i>) = <i>a</i> &minus; <i>k</i> <i>x</i><sup><i>n</i></sup>, &nbsp; <i>a</i> = 1.14,
<i>k</i> = 0.14, <i>n</i> = log<sub>2</sub>(0.72/0.14) = 2.3626,
</p>
<p>
through the points (0, 1.14), (1, 1) and (2, 0.42) of
<code>Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y</code>, and decreasing everywhere: each head up to
the shut-off head has one flow. The function returns that flow,
</p>
<p>
<i>x</i> = (positivePart(<i>a</i> &minus; <i>h</i>, 10<sup>&minus;4</sup>)/<i>k</i> +
10<sup>&minus;10</sup>)<sup>1/<i>n</i></sup>.
</p>
<p>
Beyond the shut-off head the positive part tends to 0 and so does the flow: a pump against closed valves passes
nothing and its head stays near the shut-off head. The floor 10<sup>&minus;10</sup> keeps the slope of the root
finite where the positive part rounds to zero (a pump at rest against the head of another one).
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Hydronics.Pump\">Hydronics.Pump</a> with pressure-driven flows, with the
head scaled to its speed by the affinity laws.
</p>
</html>", revisions="<html>
<ul>
<li>November 2026: first version. It replaces the parabola through the same three points, which rises from
1.14 to 1.147 between no flow and 0.18 times the nominal flow: beyond its top the pump kept 0.18 times its nominal
flow whatever the head, and against closed valves the pressures rose without bound.</li>
</ul>
</html>"));
end pumpFlow;
