within FastSmoothBuildings.Controls;
model EmissionMonitored
  "Variant MonitoredSetpoint: P controller (IDEAS LimPID) between 0 and 1 towards a set point read from external
   data"
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the output";
  Interfaces.RealInput TSet(unit="K") "Set point"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput TZon(unit="K") "Zone air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y(unit="1") "Valve opening, or share of the power of an ideal emitter"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = Utilities.smoothLimit(k*(TSet - TZon), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="P"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Emission control of a zone, trano's variant <code>MonitoredSetpoint</code>: a proportional controller between 0 and
1 (the IDEAS <code>LimPID</code> of trano's model) towards a set point given as an input (read from external
data), instead of the schedule of
<a href=\"modelica://FastSmoothBuildings.Controls.PartialEmissionControl\">PartialEmissionControl</a>.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = smoothLimit(<i>k</i> (<i>T<sub>Set</sub></i> &minus; <i>T<sub>Zon</sub></i>), 0, 1, <i>dY</i>), exactly
0 and 1 beyond the blends of <a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>.
</p>
<h4>Parameters</h4>
<p>
<code>k</code> = 1 and <code>dY</code> = 10<sup>&minus;3</sup>, the half-width of the smooth limits.
</p>
<h4>Use</h4>
<p>
Sets the power of the ideal heating of the east room of
<a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end EmissionMonitored;
