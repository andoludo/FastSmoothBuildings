within FastSmoothBuildings.HVAC;
model IdealHeater
  "Ideal emitter (trano radiator variants ideal and idealbus): Q_flow_nominal times the control y, split between
   the room air and its radiant star"
  parameter Real Q_flow_nominal(unit="W") "Nominal power";
  parameter Real fraRad = 0 "Radiant share";
  Interfaces.RealInput y(unit="1") "Share of the nominal power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Real Q_flow(unit="W") "Heat flow rate";
equation
  // no heat at y <= 0, the nominal power at y >= 1: smoothLimit reaches its bounds exactly
  Q_flow = Q_flow_nominal*Utilities.smoothLimit(y, 0, 1, 1e-3);
  heatPortCon.Q_flow = -(1 - fraRad)*Q_flow;
  heatPortRad.Q_flow = -fraRad*Q_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-60,-20},{40,-20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-60,20},{40,20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-80,0},{-60,-20}}, color={191,0,0}, thickness=0.5),
      Line(points={{-80,0},{-60,20}}, color={191,0,0}, thickness=0.5),
      Polygon(points={{40,0},{40,40},{70,20},{40,0}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{40,-40},{40,0},{70,-20},{40,-40}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{70,40},{90,-40}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end IdealHeater;
