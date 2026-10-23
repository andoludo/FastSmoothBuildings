within FastSmoothBuildings.Controls;
model EmissionPI "Variant default: PI heating loop of Buildings G36 ControlLoops (k = 0.1, Ti = 900 s)"
  extends PartialEmissionControl;
  parameter Real kHea = 0.1 "Gain of the heating loop";
  parameter Real TiHea(unit="s") = 900 "Integral time of the heating loop";
  PI conHea(k=kHea, Ti=TiHea, dY=dY, e=TSet - TZon, enable=1);
equation
  y = conHea.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="PI")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Emission control of a zone, trano's default variant: the PI heating loop of the G36 control sequences of Buildings
(<code>ControlLoops</code>) towards the scheduled set point of
<a href=\"modelica://FastSmoothBuildings.Controls.PartialEmissionControl\">PartialEmissionControl</a>.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = <code>conHea.y</code>, the output of a <a href=\"modelica://FastSmoothBuildings.Controls.PI\">PI</a>
controller always enabled, with the error <i>e</i> = <i>T<sub>Set</sub></i> &minus; <i>T<sub>Zon</sub></i>, its
output limited to [0, 1] by smooth limits of half-width <code>dY</code> and its integral held back by the
anti-windup.
</p>
<h4>Parameters</h4>
<p>
<code>kHea</code> = 0.1 and <code>TiHea</code> = 900 s, the gain and integral time of the loop; <code>dY</code> =
10<sup>&minus;3</sup>; the gain <code>k</code> of the base class is not used.
</p>
<h4>Use</h4>
<p>
Opens the valve of the radiator of
<a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end EmissionPI;
