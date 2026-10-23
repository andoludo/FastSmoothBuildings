within FastSmoothBuildings.BoundaryConditions;
model Weather "Weather data, solar position and Perez coefficients for the site"
  parameter Real lat(unit="rad") = 0.8868 "Latitude (Uccle by default)";
  parameter Real lon(unit="rad") = 0.0760 "Longitude (Uccle by default)";
  parameter Real timZon(unit="s") = 3600 "Time zone (offset of the standard time from UTC)";
  parameter Real alt(unit="m") = 100 "Altitude of the site";
  parameter Real pAtm(unit="Pa") = 101325
    "Atmospheric pressure, constant (Buildings' default; the runnable model takes the pressure of the site's
     altitude when the YAML reads the pressure from the weather file)";
  Interfaces.RealInput TDryBul(unit="K") "Outdoor dry-bulb air temperature"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Interfaces.RealInput TBlaSky(unit="K") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Interfaces.RealInput winSpe(unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Interfaces.RealInput winDir(unit="rad") "Wind direction, 0 from the north"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Interfaces.RealInput HDirNor(unit="W/m2") "Direct normal irradiance"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Interfaces.RealInput HDifHor(unit="W/m2") "Diffuse horizontal irradiance"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Interfaces.RealInput HGloHor(unit="W/m2") "Global horizontal irradiance"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Interfaces.WeatherBus weaBus "Weather data and solar position"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Real Bt "Intermediate variable of the equation of time";
  Real eqnTim(unit="s") "Equation of time";
  Real solTim(unit="s") "Solar time";
  Real zen(unit="rad") "Solar zenith angle";
  Real zenLim(unit="rad") "Zenith angle bounded by 90 degrees";
  Real relAirMas "Relative air mass";
  Real skyBri "Sky brightness";
  Real HDifHorBou(unit="W/m2") "Diffuse horizontal irradiance bounded away from 0";
  Real tmp "Intermediate variable of the sky clearness";
  Real skyCle "Sky clearness";
  Real a[8] "Weights of the sky clearness bins";
  Real b[8] "Smooth steps of the sky clearness bins";
  constant Real edges[7] = {1.065, 1.23, 1.50, 1.95, 2.80, 4.50, 6.20} "Sky clearness bin edges";
  constant Real F11[8] = {-0.0083117, 0.1299457, 0.3296958, 0.5682053, 0.8730280, 1.1326077, 1.0601591, 0.6777470};
  constant Real F12[8] = {0.5877285, 0.6825954, 0.4868735, 0.1874525, -0.3920403, -1.2367284, -1.5999137, -0.3272588};
  constant Real F13[8] = {-0.0620636, -0.1513725, -0.2210958, -0.2951290, -0.3616149, -0.4118494, -0.3589221, -0.2504286};
  constant Real F21[8] = {-0.0596012, -0.0189325, 0.0554140, 0.1088631, 0.2255647, 0.2877813, 0.2642124, 0.1561313};
  constant Real F22[8] = {0.0721249, 0.0659650, -0.0639588, -0.1519229, -0.4620442, -0.8230357, -1.1272340, -1.3765031};
  constant Real F23[8] = {-0.0220216, -0.0288748, -0.0260542, -0.0139754, 0.0012448, 0.0558651, 0.1310694, 0.2506212};
equation
  // Weather data
  weaBus.TDryBul = TDryBul;
  weaBus.TBlaSky = TBlaSky;
  weaBus.winSpe = winSpe;
  weaBus.winDir = winDir;
  weaBus.HDirNor = HDirNor;
  weaBus.HDifHor = HDifHor;
  weaBus.HGloHor = HGloHor;
  weaBus.pAtm = pAtm;
  weaBus.lat = lat;
  // Solar position (Buildings.BoundaryConditions.SolarGeometry; the model time is the clock time of the year)
  weaBus.decAng = asin(-sin(23.45*pi/180)*cos((time/86400 + 10)*2*pi/365.25));
  Bt = pi*((time + 86400)/86400 - 81)/182;
  eqnTim = 60*(9.87*sin(2*Bt) - 7.53*cos(Bt) - 1.5*sin(Bt));
  solTim = time - timZon + lon*43200/pi + eqnTim;
  weaBus.solHouAng = (solTim/3600 - 12)*2*pi/24;
  weaBus.cosZen = cos(lat)*cos(weaBus.decAng)*cos(weaBus.solHouAng) + sin(lat)*sin(weaBus.decAng);
  zen = acos(Utilities.smoothLimitInside(weaBus.cosZen, -1, 1, 1e-6));
  // Perez sky model (Buildings.BoundaryConditions.SolarIrradiation.BaseClasses)
  zenLim = Utilities.smoothMin(zen, pi/2, 0.01);
  relAirMas = exp(-0.0001184*alt)/(cos(zenLim) + 0.15*(93.9 - zenLim*180/pi)^(-1.253));
  skyBri = Utilities.smoothMin(HDifHor*relAirMas/(1366.1*(1 + 0.033*cos(2*pi*(solTim/86400 + 1)/365))), 1, 0.025);
  HDifHorBou = Utilities.smoothMax(HDifHor, 0.5e-4, 0.25e-4);
  tmp = 5.534e-6*(180/pi)^3*zen^3;
  skyCle = Utilities.smoothLimitInside(((HDirNor + HDifHorBou)/HDifHorBou + tmp)/(1 + tmp), 1, 8, 0.01);
  for i in 1:7 loop
    b[i] = Utilities.regStep(edges[i] - skyCle, 1, 0, 0.01);
  end for;
  b[8] = Utilities.regStep(skyCle - edges[7], 1, 0, 0.01);
  a[1] = b[1];
  for i in 2:7 loop
    a[i] = b[i] - b[i - 1];
  end for;
  a[8] = b[8];
  weaBus.F1 = Utilities.smoothMax(0, sum(a[i]*(F11[i] + F12[i]*skyBri + F13[i]*zen) for i in 1:8), 0.01);
  weaBus.F2 = sum(a[i]*(F21[i] + F22[i]*skyBri + F23[i]*zen) for i in 1:8);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={124,142,255}, fillColor={124,142,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-73,77},{14,-10}}, lineColor={255,220,220}, lineThickness=1,
        fillPattern=FillPattern.Sphere, fillColor={255,255,0}),
      Polygon(points={{47,53}, {39,21}, {55,26}, {69,25}, {82,19}, {91,-14}, {69,-51}, {5,-55}, {-70,-53},
        {-83,-15}, {-75,12}, {-51,13}, {-39,4}, {-46,35}, {-29,60}, {17,70}, {47,53}}, lineColor={220,220,220},
        lineThickness=0.1, fillPattern=FillPattern.Sphere, smooth=Smooth.Bezier, fillColor={230,230,230}),
      Text(extent={{-98,78},{-60,62}}, textColor={0,0,0}, textString="TDryBul"),
      Text(extent={{-98,58},{-60,42}}, textColor={0,0,0}, textString="TBlaSky"),
      Text(extent={{-98,38},{-60,22}}, textColor={0,0,0}, textString="winSpe"),
      Text(extent={{-98,18},{-60,2}}, textColor={0,0,0}, textString="winDir"),
      Text(extent={{-98,-2},{-60,-18}}, textColor={0,0,0}, textString="HDirNor"),
      Text(extent={{-98,-22},{-60,-38}}, textColor={0,0,0}, textString="HDifHor"),
      Text(extent={{-98,-42},{-60,-58}}, textColor={0,0,0}, textString="HGloHor"),
      Text(extent={{-150,140},{150,100}}, textColor={0,0,255}, textString="%name")}));
end Weather;
