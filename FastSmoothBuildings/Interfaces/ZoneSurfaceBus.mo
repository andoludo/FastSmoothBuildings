within FastSmoothBuildings.Interfaces;
connector ZoneSurfaceBus "A surface of a zone, zone side"
  HeatPort con "Convection with the zone air (at the air temperature)";
  HeatPort rad "Long-wave and solar exchange with the room (at the surface temperature)";
  RealInput A(unit="m2") "Area seen from the room";
  RealInput epsLw "Long-wave emissivity of the room side";
  RealInput absSol "Solar absorptance of the room side (diffuse)";
  RealInput tauSol "Solar transmittance back to the outside (windows)";
  RealInput isFloor "1 for a floor, which receives the transmitted direct radiation first";
  RealInput QTraDir(unit="W") "Direct solar radiation transmitted into the room (windows)";
  RealInput QTraDif(unit="W") "Diffuse solar radiation transmitted into the room (windows)";
  RealOutput hConInt(unit="W/(m2.K)") "Fixed interior convection coefficient, 0 for the natural convection law";
  RealOutput hConExt(unit="W/(m2.K)") "Fixed exterior convection coefficient, 0 for the wind-dependent law";
  WeatherBus wea "Weather";
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
end ZoneSurfaceBus;
