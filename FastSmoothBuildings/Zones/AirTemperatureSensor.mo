within FastSmoothBuildings.Zones;
model AirTemperatureSensor "Air temperature of a zone, without heat flow (the data bus reads it)"
  Interfaces.HeatPort port "Air of the zone"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.RealOutput T(unit="K") "Air temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  port.Q_flow = 0;
  T = port.T;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-20,-80},{20,-40}}, lineColor={0,0,0}, fillColor={191,0,0}, fillPattern=FillPattern.Solid),
      Rectangle(extent={{-12,60},{12,-44}}, lineColor={0,0,0}, fillColor={191,0,0}, fillPattern=FillPattern.Solid),
      Text(extent={{-150,140},{150,100}}, textColor={0,0,255}, textString="%name")}));
end AirTemperatureSensor;
