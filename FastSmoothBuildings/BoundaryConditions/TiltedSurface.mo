within FastSmoothBuildings.BoundaryConditions;
model TiltedSurface "Solar irradiance on a tilted surface: direct, Perez diffuse (sky and ground), incidence"
  parameter Real azi(unit="rad") "Surface azimuth: 0 south, pi/2 west";
  parameter Real til(unit="rad") "Surface tilt: 0 roof, pi/2 wall";
  parameter Real rho = 0.2 "Ground reflectance";
  Interfaces.WeatherBusIn weaBus
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Real cosInc "Cosine of the incidence angle";
  Real HDir(unit="W/m2") "Direct irradiance on the surface";
  Real HDif(unit="W/m2") "Diffuse irradiance on the surface (sky and ground)";
protected
  constant Real bMin = cos(85*pi/180);
equation
  cosInc = cos(til)*(cos(weaBus.decAng)*cos(weaBus.solHouAng)*cos(weaBus.lat) + sin(weaBus.decAng)*sin(weaBus.lat))
    + sin(til)*(sin(azi)*cos(weaBus.decAng)*sin(weaBus.solHouAng) + cos(azi)*(cos(weaBus.decAng)
    *cos(weaBus.solHouAng)*sin(weaBus.lat) - sin(weaBus.decAng)*cos(weaBus.lat)));
  HDir = Utilities.positivePart(cosInc*weaBus.HDirNor, 1e-2);
  HDif = weaBus.HDifHor*(0.5*(1 - weaBus.F1)*(1 + cos(til)) + weaBus.F1*Utilities.smoothMax(0, cosInc, 0.01)
    /Utilities.smoothMax(bMin, weaBus.cosZen, 0.01) + weaBus.F2*sin(til)) + weaBus.HGloHor*0.5*rho*(1 - cos(til));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-80,80},{-20,20}}, lineColor={255,220,220}, fillColor={255,255,0},
        fillPattern=FillPattern.Sphere),
      Polygon(points={{-20,-80},{80,20},{80,-80},{-20,-80}}, lineColor={0,0,0}, fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Line(points={{-30,30},{30,-30}}, color={255,128,0}, arrow={Arrow.None,Arrow.Filled}),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Solar irradiance on a surface of azimuth <code>azi</code> and tilt <code>til</code>, from the weather bus of
<a href=\"modelica://FastSmoothBuildings.BoundaryConditions.Weather\">Weather</a>: the cosine of the incidence angle
<code>cosInc</code>, the direct irradiance <code>HDir</code> and the diffuse irradiance <code>HDif</code> from sky
and ground.
</p>
<h4>Equations</h4>
<p>
With the declination <i>&delta;</i>, the hour angle <i>&omega;</i>, the latitude <i>&phi;</i>, the tilt
<i>s</i> and the azimuth <i>&gamma;</i>,
</p>
<p>
cos&nbsp;<i>&theta;</i> = cos&nbsp;<i>s</i> (cos&nbsp;<i>&delta;</i> cos&nbsp;<i>&omega;</i> cos&nbsp;<i>&phi;</i>
+ sin&nbsp;<i>&delta;</i> sin&nbsp;<i>&phi;</i>) + sin&nbsp;<i>s</i> (sin&nbsp;<i>&gamma;</i>
cos&nbsp;<i>&delta;</i> sin&nbsp;<i>&omega;</i> + cos&nbsp;<i>&gamma;</i> (cos&nbsp;<i>&delta;</i>
cos&nbsp;<i>&omega;</i> sin&nbsp;<i>&phi;</i> &minus; sin&nbsp;<i>&delta;</i> cos&nbsp;<i>&phi;</i>)),
</p>
<p>
<i>H<sub>dir</sub></i> = max(cos&nbsp;<i>&theta;</i> <i>H<sub>dir,nor</sub></i>, 0),
</p>
<p>
and the Perez model, with the coefficients <i>F<sub>1</sub></i>, <i>F<sub>2</sub></i> of the bus and the ground
reflectance <i>&rho;</i>:
</p>
<p>
<i>H<sub>dif</sub></i> = <i>H<sub>dif,hor</sub></i> ((1 &minus; <i>F<sub>1</sub></i>) (1 + cos&nbsp;<i>s</i>)/2 +
<i>F<sub>1</sub></i> max(0, cos&nbsp;<i>&theta;</i>)/max(cos&nbsp;85&deg;, cos&nbsp;<i>&zeta;</i>) +
<i>F<sub>2</sub></i> sin&nbsp;<i>s</i>) + <i>H<sub>glo,hor</sub></i> <i>&rho;</i> (1 &minus; cos&nbsp;<i>s</i>)/2.
</p>
<h4>Smoothing</h4>
<p>
The maximum of <i>H<sub>dir</sub></i> is
<a href=\"modelica://FastSmoothBuildings.Utilities.positivePart\">positivePart</a> (width 0.01), the two others
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a> over 0.01. The irradiance is continuous
when the sun crosses the plane of the surface or the horizon.
</p>
<h4>Use</h4>
<p>
The sun on <a href=\"modelica://FastSmoothBuildings.Envelope.OuterWall\">OuterWall</a>,
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a> and
<a href=\"modelica://FastSmoothBuildings.Electrical.Photovoltaic\">Photovoltaic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.BoundaryConditions</code>.</li>
</ul>
</html>"));
end TiltedSurface;
