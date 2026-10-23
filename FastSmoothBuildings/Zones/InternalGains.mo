within FastSmoothBuildings.Zones;
model InternalGains "Internal gains of a zone per floor area, from two signals"
  Interfaces.RealInput QCon(unit="W/m2") "Convective internal gains per floor area"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Interfaces.RealInput QRad(unit="W/m2") "Radiant internal gains per floor area"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Interfaces.GainOutputs gai "Internal gains per floor area"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  gai.QCon = QCon;
  gai.QRad = QRad;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,140},{150,100}}, textColor={0,0,255}, textString="%name")}));
end InternalGains;
