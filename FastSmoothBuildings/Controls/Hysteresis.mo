within FastSmoothBuildings.Controls;
model Hysteresis
  "y goes to 1 when u rises above uHigh and back to 0 when u falls below uLow (CDL Hysteresis), as a bistable
   state switching within tau"
  parameter Real uLow "Threshold of the switch to 0";
  parameter Real uHigh "Threshold of the switch to 1";
  parameter Real tau(unit="s") = 10 "Switching time";
  parameter Real dU = (uHigh - uLow)/10 "Half-width of the smooth transition of the switch";
  parameter Real y_start = 0 "Initial output";
  Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real y(start=y_start, fixed=true);
equation
  tau*der(y) = Utilities.regStep(u - (uHigh + (uLow - uHigh)*y), 1, 0, dU) - y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}, fillColor={210,210,210},
        fillPattern=FillPattern.Solid, borderPattern=BorderPattern.Raised),
      Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,68},{-80,-29}}, color={192,192,192}),
      Polygon(points={{92,-29},{70,-21},{70,-37},{92,-29}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-79,-29},{84,-29}}, color={192,192,192}),
      Line(points={{-79,-29},{41,-29}}),
      Line(points={{-15,-21},{1,-29},{-15,-36}}),
      Line(points={{41,51},{41,-29}}),
      Line(points={{33,3},{41,22},{50,3}}),
      Line(points={{-49,51},{81,51}}),
      Line(points={{-4,59},{-19,51},{-4,43}}),
      Line(points={{-59,29},{-49,11},{-39,29}}),
      Line(points={{-49,51},{-49,-29}}),
      Text(extent={{-92,-49},{-9,-92}}, textColor={192,192,192}, textString="%uLow"),
      Text(extent={{2,-49},{91,-92}}, textColor={192,192,192}, textString="%uHigh"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end Hysteresis;
