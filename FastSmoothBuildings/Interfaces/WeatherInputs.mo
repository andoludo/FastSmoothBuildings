within FastSmoothBuildings.Interfaces;
connector WeatherInputs "Weather data: inputs of building_mpc (from a weather file or a forecast)"
  RealInput TDryBul(unit="K") "Outdoor dry-bulb air temperature";
  RealInput TBlaSky(unit="K") "Black-body sky temperature";
  RealInput winSpe(unit="m/s") "Wind speed";
  RealInput winDir(unit="rad") "Wind direction, 0 from the north";
  RealInput HDirNor(unit="W/m2") "Direct normal irradiance";
  RealInput HDifHor(unit="W/m2") "Diffuse horizontal irradiance";
  RealInput HGloHor(unit="W/m2") "Global horizontal irradiance";
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
The weather data as inputs of <code>building_mpc</code>, the model for optimal control, from a weather file or a
forecast: <code>TDryBul</code> and <code>TBlaSky</code> (K), <code>winSpe</code> (m/s), <code>winDir</code> (rad, 0
for a wind from the north), <code>HDirNor</code>, <code>HDifHor</code> and <code>HGloHor</code>
(W/m<sup>2</sup>). Signals, not flow variables.
</p>
<h4>Use</h4>
<p>
Declared at the top level of the model, its variables are inputs of the CasADi function (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>). They are the seven
inputs of <a href=\"modelica://FastSmoothBuildings.BoundaryConditions.Weather\">BoundaryConditions.Weather</a>, which
adds the solar position, the Perez coefficients and the atmospheric pressure of the
<a href=\"modelica://FastSmoothBuildings.Interfaces.WeatherBus\">WeatherBus</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end WeatherInputs;
