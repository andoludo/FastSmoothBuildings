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
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A surface of a zone, surface side (<code>propsBus_a</code> of the walls and windows of
<a href=\"modelica://FastSmoothBuildings.Envelope\">Envelope</a>): the heat exchanges with the room, the properties
the zone needs to share them, and the weather.
</p>
<table summary=\"Variables of the surface bus\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Variable</th><th>Unit</th><th>Set by</th><th>Meaning</th></tr>
<tr><td><code>con.T</code></td><td>K</td><td>zone</td><td>Air temperature of the zone</td></tr>
<tr><td><code>con.Q_flow</code></td><td>W</td><td>surface</td><td>Convective heat flow rate (flow variable)</td></tr>
<tr><td><code>rad.T</code></td><td>K</td><td>surface</td><td>Temperature of the room face of the surface</td></tr>
<tr><td><code>rad.Q_flow</code></td><td>W</td><td>zone</td><td>Long-wave and solar heat flow rate (flow
variable)</td></tr>
<tr><td><code>A</code></td><td>m<sup>2</sup></td><td>surface</td><td>Area seen from the room</td></tr>
<tr><td><code>epsLw</code></td><td>1</td><td>surface</td><td>Long-wave emissivity of the room side</td></tr>
<tr><td><code>absSol</code></td><td>1</td><td>surface</td><td>Diffuse solar absorptance of the room side</td></tr>
<tr><td><code>tauSol</code></td><td>1</td><td>surface</td><td>Solar transmittance back to the outside (windows)
</td></tr>
<tr><td><code>isFloor</code></td><td>1</td><td>surface</td><td>1 for a floor, 0 otherwise</td></tr>
<tr><td><code>QTraDir</code>, <code>QTraDif</code></td><td>W</td><td>surface</td><td>Direct and diffuse solar
radiation transmitted into the room (windows)</td></tr>
<tr><td><code>hConInt</code>, <code>hConExt</code></td><td>W/(m<sup>2</sup>K)</td><td>zone</td><td>Fixed interior and
exterior convection coefficients, 0 for the natural convection and wind-dependent laws</td></tr>
<tr><td><code>wea</code></td><td></td><td>zone</td><td>Weather, forwarded by the zone</td></tr>
</table>
<p>
The heat flow rates are positive into the component that holds the port, so the convective and radiant heat
gained by the surface is <code>con.Q_flow</code> + <code>rad.Q_flow</code> on the surface side, the opposite on the
zone side. The zone shares the long-wave exchange through a radiant star with the weights
<code>epsLw*A</code>, the transmitted diffuse radiation in proportion to <code>absSol*A</code> (with
<code>tauSol*A</code> lost back to the outside), and the transmitted direct radiation on the floors first.
</p>
<h4>Use</h4>
<p>
Connect it to one element of the
<a href=\"modelica://FastSmoothBuildings.Interfaces.ZoneSurfaceBus\">ZoneSurfaceBus</a> array
<code>propsBus</code> of a zone, which has the same variables with the opposite causality.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end SurfaceBus;
