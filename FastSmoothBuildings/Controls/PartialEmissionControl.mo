within FastSmoothBuildings.Controls;
partial model PartialEmissionControl
  "Emission control of a zone (trano EmissionControl): set point of its day schedule, output y to the valve or
   the ideal emitter"
  parameter Real schedule[:](each unit="s") = 3600*{7, 19} "Day schedule: occupied between pairs of instants";
  parameter Real THeaSet(unit="K") = 294.15 "Set point when occupied";
  parameter Real THeaSetBack(unit="K") = 289.15 "Set point otherwise";
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the output";
  parameter Real dtSet(unit="s") = 60 "Duration of a change of the set point";
  Interfaces.RealInput TZon(unit="K") "Zone air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y(unit="1") "Valve opening, or share of the power of an ideal emitter"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Real TSet(unit="K") "Set point";
equation
  TSet = THeaSetBack + (THeaSet - THeaSetBack)*Utilities.occupancy(Utilities.timeOfDay(time), schedule, dtSet);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Base class of the emission controls of a zone (trano's <code>EmissionControl</code>): the heating set point
<code>TSet</code> from a day schedule, the zone air temperature <code>TZon</code> as input and the output
<code>y</code>, the opening of a valve or the share of the power of an ideal emitter. An extending class gives the
equation of <code>y</code>.
</p>
<h4>Equations</h4>
<p>
<i>T<sub>Set</sub></i> = <i>T<sub>HeaSetBack</sub></i> + (<i>T<sub>HeaSet</sub></i> &minus;
<i>T<sub>HeaSetBack</sub></i>) occupancy(timeOfDay(<i>t</i>), <code>schedule</code>, <code>dtSet</code>).
</p>
<p>
<a href=\"modelica://FastSmoothBuildings.Utilities.occupancy\">occupancy</a> is 1 between the pairs of instants of
<code>schedule</code> and 0 otherwise, each change a smooth step over <code>dtSet</code>: the set point changes
without an event.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of PartialEmissionControl\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>schedule</code></td><td>3600 {7, 19} s</td><td>occupied between pairs of instants of the day</td></tr>
<tr><td><code>THeaSet</code></td><td>294.15 K</td><td>set point when occupied</td></tr>
<tr><td><code>THeaSetBack</code></td><td>289.15 K</td><td>set point otherwise</td></tr>
<tr><td><code>k</code></td><td>1</td><td>gain</td></tr>
<tr><td><code>dY</code></td><td>10<sup>&minus;3</sup></td><td>half-width of the smooth limits of the output</td></tr>
<tr><td><code>dtSet</code></td><td>60 s</td><td>duration of a change of the set point</td></tr>
</table>
<p>
<code>dY</code> and <code>dtSet</code> are smoothing widths that a calibration can widen.
</p>
<h4>Use</h4>
<p>
Extended by <a href=\"modelica://FastSmoothBuildings.Controls.EmissionP\">EmissionP</a>,
<a href=\"modelica://FastSmoothBuildings.Controls.EmissionPI\">EmissionPI</a> and
<a href=\"modelica://FastSmoothBuildings.Controls.EmissionOnOff\">EmissionOnOff</a>;
<a href=\"modelica://FastSmoothBuildings.Controls.EmissionMonitored\">EmissionMonitored</a> reads its set point as an
input instead.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end PartialEmissionControl;
