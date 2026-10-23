within FastSmoothBuildings.HVAC;
model IdealHeatingCoolingPI
  "Ideal heating and cooling of a zone towards day schedules of set points (trano IdealHeatingCooling): a PI
   controller per mode, limited by the capacities"
  parameter Real TSetHea[:, 2] = [0, 293.15] "Heating set point: time of day [s] and set point [K]";
  parameter Real TSetCoo[:, 2] = [0, 300.15] "Cooling set point: time of day [s] and set point [K]";
  parameter Real QHea_flow_max(unit="W") = 1e6 "Heating capacity";
  parameter Real QCoo_flow_max(unit="W") = 1e6 "Cooling capacity";
  parameter Real k = 0.1 "Gain [1/K]";
  parameter Real Ti(unit="s") = 300 "Integral time";
  parameter Real frad = 0 "Radiant share";
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Real QHea_flow(unit="W") "Heating";
  Real QCoo_flow(unit="W") "Cooling, positive when cooling";
  Real EHea(unit="kWh", start=0, fixed=true) "Heating meter";
  Real ECoo(unit="kWh", start=0, fixed=true) "Cooling meter";
  Controls.PI conHea(k=k, Ti=Ti, e=Utilities.dayTable(Utilities.timeOfDay(time), TSetHea) - heatPortCon.T, enable=1);
  Controls.PI conCoo(k=k, Ti=Ti, e=heatPortCon.T - Utilities.dayTable(Utilities.timeOfDay(time), TSetCoo), enable=1);
equation
  // a saturated mode gives exactly no heat: smoothLimit reaches its bounds (when it saturated at dY, each mode
  // leaked dY*capacity, 1 kW with the 1 MW of BESTEST, into the other)
  QHea_flow = conHea.y*QHea_flow_max;
  QCoo_flow = conCoo.y*QCoo_flow_max;
  der(EHea) = QHea_flow/3.6e6;
  der(ECoo) = QCoo_flow/3.6e6;
  heatPortCon.Q_flow = -(1 - frad)*(QHea_flow - QCoo_flow);
  heatPortRad.Q_flow = -frad*(QHea_flow - QCoo_flow);
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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name"),
      Text(extent={{-80,80},{20,40}}, textColor={0,0,0}, textString="PI")}));
end IdealHeatingCoolingPI;
