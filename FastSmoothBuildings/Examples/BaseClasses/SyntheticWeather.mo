within FastSmoothBuildings.Examples.BaseClasses;
model SyntheticWeather "Clear days: a daily cycle of the outdoor temperature, the sun from the solar position"
  parameter Real TMea(unit="K") = 275.15 "Mean outdoor temperature";
  parameter Real TAmp(unit="K") = 5 "Amplitude of the daily cycle of the outdoor temperature, warmest at 15:00";
  parameter Real dTSky(unit="K") = 15 "Black-body sky below the outdoor temperature";
  parameter Real HDirNorMax(unit="W/m2") = 700 "Direct normal irradiance with the sun high";
  parameter Real HDifHorMax(unit="W/m2") = 150 "Diffuse horizontal irradiance with the sun at the zenith";
  parameter Real winSpe(unit="m/s") = 3 "Wind speed";
  parameter Real lat(unit="rad") = 0.8868 "Latitude (Uccle)";
  parameter Real lon(unit="rad") = 0.0760 "Longitude (Uccle)";
  parameter Real timZon(unit="s") = 3600 "Time zone";
  Real sunUp "1 with the sun more than 3 degrees above the horizon, 0 below the horizon";
  Real cosZen "Cosine of the solar zenith angle, 0 below the horizon";
  FastSmoothBuildings.BoundaryConditions.Weather weaDat(
    lat=lat,
    lon=lon,
    timZon=timZon,
    TDryBul=TMea + TAmp*sin(2*pi*(time/86400 - 9/24)),
    TBlaSky=TMea + TAmp*sin(2*pi*(time/86400 - 9/24)) - dTSky,
    winSpe=winSpe,
    winDir=0,
    HDirNor=HDirNorMax*sunUp,
    HDifHor=HDifHorMax*cosZen,
    HGloHor=(HDifHorMax + HDirNorMax*sunUp)*cosZen) "Weather data and solar position";
  FastSmoothBuildings.Interfaces.WeatherBus weaBus "Weather data and solar position"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  cosZen = FastSmoothBuildings.Utilities.positivePart(weaDat.weaBus.cosZen, 0.01);
  sunUp = FastSmoothBuildings.Utilities.regStep(weaDat.weaBus.cosZen - 0.05, 1, 0, 0.05);
  connect(weaDat.weaBus, weaBus);
  annotation (Documentation(info="<html>
<p>
The weather of clear days, without a weather file: the outdoor temperature follows a sine around
<code>TMea</code>, warmest at 15:00; the direct irradiance is on while the sun is above the horizon (a smooth step
of the cosine of the zenith angle computed by
<a href=\"modelica://FastSmoothBuildings.BoundaryConditions.Weather\">BoundaryConditions.Weather</a>), the
diffuse and global irradiances follow the cosine of the zenith angle.
</p>
</html>"));
end SyntheticWeather;
