within FastSmoothBuildings.Controls;
model BoilerTemperatureControl
  "Firing of a boiler without storage (trano Buildings boiler): P controller (k) on the boiler temperature, while
   there is demand"
  parameter Real TempSet(unit="K") = 353.15 "Boiler temperature set point";
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the part load";
  Interfaces.RealInput T(unit="K") "Boiler water temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput demand "Demand, 0 or 1"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y(unit="1") "Part load ratio"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = demand*Utilities.smoothLimit(k*(TempSet - T), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="boiler"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Firing of a boiler without storage (trano's Buildings boiler): a proportional controller on the boiler water
temperature, while there is demand.
</p>
<h4>Equations</h4>
<p>
<i>y</i> = <i>demand</i> smoothLimit(<i>k</i> (<i>T<sub>empSet</sub></i> &minus; <i>T</i>), 0, 1, <i>dY</i>).
</p>
<p>
The part load ratio is 1 once the boiler is about 1/<i>k</i> below its set point and 0 above it, exactly, by
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>; the demand multiplies it instead of
switching it.
</p>
<h4>Parameters</h4>
<p>
<code>TempSet</code> = 353.15 K, <code>k</code> = 1, <code>dY</code> = 10<sup>&minus;3</sup> (the half-width of the
smooth limits of the part load).
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>, with a demand of
1.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end BoilerTemperatureControl;
