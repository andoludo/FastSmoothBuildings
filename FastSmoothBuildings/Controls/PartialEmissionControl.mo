within FastSmoothBuildings.Controls;
partial model PartialEmissionControl
  "Emission control of a zone (trano EmissionControl): set point of its day schedule, output y to the valve or
   the ideal emitter"
  parameter Real schedule[:](each unit="s") = 3600*{7, 19} "Day schedule: occupied between pairs of instants";
  parameter Real THeaSet(unit="K") = 294.15 "Set point when occupied";
  parameter Real THeaSetBack(unit="K") = 289.15 "Set point otherwise";
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the output";
  parameter Real dtSet(unit="s") = 60 "Duration of a change of the set point";
  Interfaces.RealInput TZon(unit="K") "Zone air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y(unit="1") "Valve opening, or share of the power of an ideal emitter"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Real TSet(unit="K") "Set point";
equation
  TSet = THeaSetBack + (THeaSet - THeaSetBack)*Utilities.occupancy(Utilities.timeOfDay(time), schedule, dtSet);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end PartialEmissionControl;
