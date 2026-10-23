within FastSmoothBuildings.Interfaces;
connector WeatherBus "Weather data and solar position (source side)"
  RealOutput TDryBul(unit="K") "Outdoor dry-bulb air temperature";
  RealOutput TBlaSky(unit="K") "Black-body sky temperature";
  RealOutput winSpe(unit="m/s") "Wind speed";
  RealOutput winDir(unit="rad") "Wind direction, 0 from the north";
  RealOutput HDirNor(unit="W/m2") "Direct normal irradiance";
  RealOutput HDifHor(unit="W/m2") "Diffuse horizontal irradiance";
  RealOutput HGloHor(unit="W/m2") "Global horizontal irradiance";
  RealOutput lat(unit="rad") "Latitude";
  RealOutput decAng(unit="rad") "Solar declination";
  RealOutput solHouAng(unit="rad") "Solar hour angle";
  RealOutput cosZen "Cosine of the solar zenith angle";
  RealOutput F1 "Circumsolar brightening coefficient of the Perez model";
  RealOutput F2 "Horizon brightening coefficient of the Perez model";
  RealOutput pAtm(unit="Pa") "Atmospheric pressure";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}}),
      Polygon(fillColor={255,215,136}, fillPattern=FillPattern.Solid,
        points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
        smooth=Smooth.Bezier),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-65,15},{-55,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-5,15},{5,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{55,15},{65,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-35,-25},{-25,-15}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}));
end WeatherBus;
