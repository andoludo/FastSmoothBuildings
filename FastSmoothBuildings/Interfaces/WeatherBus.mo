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
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Source side of the weather: all variables are outputs (signals, no flow variable).
</p>
<ul>
<li>weather data: <code>TDryBul</code> and <code>TBlaSky</code> (K), <code>winSpe</code> (m/s),
<code>winDir</code> (rad, 0 for a wind from the north), the irradiances <code>HDirNor</code>, <code>HDifHor</code>
and <code>HGloHor</code> (W/m<sup>2</sup>), the atmospheric pressure <code>pAtm</code> (Pa);</li>
<li>solar position: the latitude <code>lat</code>, the declination <code>decAng</code> and the hour angle
<code>solHouAng</code> (rad), the cosine of the zenith angle <code>cosZen</code>;</li>
<li>the circumsolar and horizon brightening coefficients <code>F1</code> and <code>F2</code> of the Perez model of
the diffuse irradiance on a tilted surface.</li>
</ul>
<h4>Use</h4>
<p>
The output of <a href=\"modelica://FastSmoothBuildings.BoundaryConditions.Weather\">BoundaryConditions.Weather</a>,
which computes the solar position and the Perez coefficients once for the site; connect it to the
<a href=\"modelica://FastSmoothBuildings.Interfaces.WeatherBusIn\">WeatherBusIn</a> of the zones and the other
components. A zone forwards its weather to its surfaces through the <code>wea</code> of its
<a href=\"modelica://FastSmoothBuildings.Interfaces.ZoneSurfaceBus\">ZoneSurfaceBus</a>, a WeatherBus.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end WeatherBus;
