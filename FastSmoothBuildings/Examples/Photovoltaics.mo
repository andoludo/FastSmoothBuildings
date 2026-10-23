within FastSmoothBuildings.Examples;
model Photovoltaics "Photovoltaic arrays facing south and west under clear winter days"
  extends FastSmoothBuildings.Icons.Example;
  BaseClasses.SyntheticWeather weather "Clear winter days"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  FastSmoothBuildings.Electrical.Photovoltaic south(A=20, eta=0.2, til=0.6, azi=0) "20 m2 facing south, tilted 34 degrees";
  FastSmoothBuildings.Electrical.Photovoltaic westArray(A=20, eta=0.2, til=0.6, azi=pi/2) "20 m2 facing west, tilted 34 degrees";
equation
  connect(weather.weaBus, south.weaBus);
  connect(weather.weaBus, westArray.weaBus);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
Two arrays of 20 m<sup>2</sup>, efficiency 0.2, tilted 34&deg;, one facing south, one facing west: the power of
each follows the irradiance on its plane; the production meters <code>EPro</code> give the energy of each day.
</p>
</html>"));
end Photovoltaics;
