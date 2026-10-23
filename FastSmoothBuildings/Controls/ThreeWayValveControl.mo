within FastSmoothBuildings.Controls;
model ThreeWayValveControl
  "Three-way valve control (trano ThreeWayValveControl): P controller on the supply temperature measured
   downstream (filtered by tauSen)"
  parameter Real TColSet(unit="K") = 363.15 "Supply temperature set point";
  parameter Real k = 1 "Gain";
  parameter Real tauSen(unit="s") = 10 "Time constant of the temperature measurement";
  parameter Real dY = 1e-3 "Width of the smooth limits of the opening";
  Interfaces.RealInput u(unit="K") "Measured supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y(unit="1") "Opening of the supply path"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Real TMea(unit="K", start=TColSet - 30, fixed=true) "Filtered measurement";
equation
  tauSen*der(TMea) = u - TMea;
  y = Utilities.smoothLimit(k*(TColSet - TMea), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="3WV"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Control of a three-way valve (trano's <code>ThreeWayValveControl</code>): a proportional controller on the supply
temperature measured downstream, the measurement filtered by a first-order sensor.
</p>
<h4>Equations</h4>
<p>
<i>&tau;<sub>Sen</sub></i> d<i>T<sub>Mea</sub></i>/d<i>t</i> = <i>u</i> &minus; <i>T<sub>Mea</sub></i>, &nbsp;
<i>T<sub>Mea</sub></i>(0) = <i>T<sub>ColSet</sub></i> &minus; 30 K,
</p>
<p>
<i>y</i> = smoothLimit(<i>k</i> (<i>T<sub>ColSet</sub></i> &minus; <i>T<sub>Mea</sub></i>), 0, 1, <i>dY</i>),
exactly 0 and 1 beyond the blends of
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>.
</p>
<h4>Parameters</h4>
<p>
<code>TColSet</code> = 363.15 K, <code>k</code> = 1, <code>tauSen</code> = 10 s, <code>dY</code> =
10<sup>&minus;3</sup> (the half-width of the smooth limits of the opening).
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end ThreeWayValveControl;
