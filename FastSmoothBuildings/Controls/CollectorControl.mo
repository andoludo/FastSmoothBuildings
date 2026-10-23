within FastSmoothBuildings.Controls;
model CollectorControl
  "Collector control of a pump (trano CollectorControl): on when a valve opens beyond 0.5, off when all are
   below 0.01, the speed from a P controller holding the head at dp_nominal"
  parameter Integer nVal = 1 "Number of valves";
  parameter Real k = 1 "Gain";
  parameter Real dY = 1e-3 "Width of the smooth limits of the speed";
  parameter Real dMax = 1e-3 "Width of the smooth maximum of the openings";
  Interfaces.RealInput yVal[nVal] "Openings of the valves of the circuit"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput dpRel "Head of the pump relative to its nominal head"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput yMax "Largest opening (the boiler control reads it)"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Hysteresis hysPum(uLow=0.01, uHigh=0.5, u=yMax);
  Interfaces.RealOutput y(unit="1") "Speed of the pump"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  yMax = smoothMaxN(yVal, dMax);
  y = Utilities.smoothLimit(k*(hysPum.y - dpRel), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="collector"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end CollectorControl;
