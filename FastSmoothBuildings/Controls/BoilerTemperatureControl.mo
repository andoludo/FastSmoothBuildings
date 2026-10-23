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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end BoilerTemperatureControl;
