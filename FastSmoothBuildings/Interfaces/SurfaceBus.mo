within FastSmoothBuildings.Interfaces;
connector SurfaceBus "A surface of a zone, surface side: heat exchanges, properties, weather"
  HeatPort con "Convection with the zone air (at the air temperature)";
  HeatPort rad "Long-wave and solar exchange with the room (at the surface temperature)";
  RealOutput A(unit="m2") "Area seen from the room";
  RealOutput epsLw "Long-wave emissivity of the room side";
  RealOutput absSol "Solar absorptance of the room side (diffuse)";
  RealOutput tauSol "Solar transmittance back to the outside (windows)";
  RealOutput isFloor "1 for a floor, which receives the transmitted direct radiation first";
  RealOutput QTraDir(unit="W") "Direct solar radiation transmitted into the room (windows)";
  RealOutput QTraDif(unit="W") "Diffuse solar radiation transmitted into the room (windows)";
  RealInput hConInt(unit="W/(m2.K)") "Fixed interior convection coefficient, 0 for the natural convection law";
  RealInput hConExt(unit="W/(m2.K)") "Fixed exterior convection coefficient, 0 for the wind-dependent law";
  WeatherBusIn wea "Weather";
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
end SurfaceBus;
