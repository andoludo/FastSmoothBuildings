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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end TiltedSurface;
