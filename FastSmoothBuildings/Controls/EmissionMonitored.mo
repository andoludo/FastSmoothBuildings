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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end EmissionMonitored;
