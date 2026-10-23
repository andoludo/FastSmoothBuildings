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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end ThreeWayValveControl;
