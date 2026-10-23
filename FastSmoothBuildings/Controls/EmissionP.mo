within FastSmoothBuildings.Controls;
model EmissionP "Variant PController: P controller (IDEAS LimPID) between 0 and 1"
  extends PartialEmissionControl(k=5);
equation
  y = Utilities.smoothLimit(k*(TSet - TZon), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="P")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Emission control of a zone, trano's variant <code>PController</code>: a proportional controller between 0 and 1
(the IDEAS <code>LimPID</code> of trano's model) towards the scheduled set point of
<a href=\"modelica://FastSmoothBuildings.Controls.PartialEmissionControl\">PartialEmissionControl</a>.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = smoothLimit(<i>k</i> (<i>T<sub>Set</sub></i> &minus; <i>T<sub>Zon</sub></i>), 0, 1, <i>dY</i>).
</p>
<p>
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a> reaches 0 and 1 exactly and never
leaves them: the output is 1 once the zone is about 1/<i>k</i> below its set point and 0 above it, without an
event.
</p>
<h4>Parameters</h4>
<p>
<code>k</code> = 5 (instead of the 1 of the base class), <code>dY</code> = 10<sup>&minus;3</sup>, and the schedule
and set points of the base class.
</p>
<h4>Use</h4>
<p>
Opens the valves of the radiators of
<a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end EmissionP;
