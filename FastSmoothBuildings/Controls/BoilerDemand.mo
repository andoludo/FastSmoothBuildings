within FastSmoothBuildings.Controls;
model BoilerDemand
  "Demand of a production (trano BoilerControl, variant simple): on when a valve of its circuits opens beyond 0.5,
   off when all are below 0.01"
  parameter Integer n = 1 "Number of circuits";
  parameter Real dMax = 1e-3 "Width of the smooth maximum of the openings";
  Interfaces.RealInput yMax[n] "Largest opening of the valves of each circuit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Hysteresis hys(uLow=0.01, uHigh=0.5, u=smoothMaxN(yMax, dMax));
  Interfaces.RealOutput y(unit="1") "Demand"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = hys.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="demand"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end BoilerDemand;
