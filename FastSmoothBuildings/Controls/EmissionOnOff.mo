within FastSmoothBuildings.Controls;
model EmissionOnOff "Variant onoff: on below the set point minus half the band, off above it plus half the band"
  extends PartialEmissionControl;
  parameter Real bandwidth(unit="K") = 0.1 "Band of the on/off controller (Modelica OnOffController)";
  Hysteresis onOff(uLow=-bandwidth/2, uHigh=bandwidth/2, u=TSet - TZon);
equation
  y = onOff.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="on/off")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Emission control of a zone, trano's variant <code>onoff</code>: on when the zone falls below its scheduled set point
minus half the band, off when it rises above the set point plus half the band. The switch is a
<a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a>, a bistable state, so the thermostat
has no event. It behaves as the <code>OnOffController</code> of the Modelica Standard Library with its
<code>bandwidth</code>.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = <code>onOff.y</code>, the hysteresis of <i>u</i> = <i>T<sub>Set</sub></i> &minus;
<i>T<sub>Zon</sub></i> with <code>uLow</code> = &minus;<code>bandwidth</code>/2 and <code>uHigh</code> =
<code>bandwidth</code>/2.
</p>
<h4>Parameters</h4>
<p>
<code>bandwidth</code> = 0.1 K. The hysteresis keeps its defaults, <code>onOff.tau</code> = 10 s and
<code>onOff.dU</code> = <code>bandwidth</code>/10; a modifier can lengthen and widen them for a calibration.
</p>
<h4>Use</h4>
<p>
Switches the ideal heater of the west room of
<a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end EmissionOnOff;
