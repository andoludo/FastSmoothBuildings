within FastSmoothBuildings.Examples;
model TwoZones "Two rooms side by side, over the ground, with ideal heaters and their room controllers"
  extends FastSmoothBuildings.Icons.Example;
  BaseClasses.SyntheticWeather weather(TMea=272.15, TAmp=4) "Clear winter days"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  FastSmoothBuildings.Zones.Zone west(nSurf=7, AFlo=20, hRoo=2.5, ACH=0.3, T_start=292.15) "West room"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  FastSmoothBuildings.Zones.Zone east(nSurf=7, AFlo=20, hRoo=2.5, ACH=0.3, T_start=292.15) "East room"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  FastSmoothBuildings.Envelope.OuterWall westSouth(constructionType=Constructions.CavityWall(), A=7, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "South wall of the west room";
  FastSmoothBuildings.Envelope.OuterWall westWest(constructionType=Constructions.CavityWall(), A=12.5, azi=pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "West wall";
  FastSmoothBuildings.Envelope.OuterWall westNorth(constructionType=Constructions.CavityWall(), A=10, azi=pi,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "North wall of the west room";
  FastSmoothBuildings.Envelope.Window westWindow(glazing=Constructions.TripleArgon(), A=3, frac=0.2, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "South window of the west room";
  FastSmoothBuildings.Envelope.OuterWall eastSouth(constructionType=Constructions.CavityWall(), A=7, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "South wall of the east room";
  FastSmoothBuildings.Envelope.OuterWall eastEast(constructionType=Constructions.CavityWall(), A=12.5, azi=-pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "East wall";
  FastSmoothBuildings.Envelope.OuterWall eastNorth(constructionType=Constructions.CavityWall(), A=10, azi=pi,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "North wall of the east room";
  FastSmoothBuildings.Envelope.Window eastWindow(glazing=Constructions.TripleArgon(), A=3, frac=0.2, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=290.15) "South window of the east room";
  FastSmoothBuildings.Envelope.InternalWall partition(constructionType=Constructions.CavityWall(), A=12.5, azi=pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=292.15) "Wall between the rooms: side a in the west room";
  FastSmoothBuildings.Envelope.BoundaryWall westFloor(constructionType=Constructions.ConcreteSlab(), A=20, TGro=283.15,
    til=FastSmoothBuildings.Types.Tilt.Floor, T_start=288.15) "Floor of the west room on the ground";
  FastSmoothBuildings.Envelope.BoundaryWall eastFloor(constructionType=Constructions.ConcreteSlab(), A=20, TGro=283.15,
    til=FastSmoothBuildings.Types.Tilt.Floor, T_start=288.15) "Floor of the east room on the ground";
  FastSmoothBuildings.Envelope.AdiabaticWall westCeiling(constructionType=Constructions.ConcreteSlab(), A=20,
    til=FastSmoothBuildings.Types.Tilt.Ceiling, T_start=292.15) "Ceiling of the west room, a heated storey above";
  FastSmoothBuildings.Envelope.AdiabaticWall eastCeiling(constructionType=Constructions.ConcreteSlab(), A=20,
    til=FastSmoothBuildings.Types.Tilt.Ceiling, T_start=292.15) "Ceiling of the east room, a heated storey above";
  FastSmoothBuildings.Zones.InternalGains westGains(QCon=2, QRad=2) "Internal gains of the west room";
  FastSmoothBuildings.Zones.InternalGains eastGains(QCon=2, QRad=2) "Internal gains of the east room";
  FastSmoothBuildings.Zones.AirTemperatureSensor westSensor "Air temperature of the west room";
  FastSmoothBuildings.Controls.EmissionOnOff westControl(
    schedule=3600*{7, 22},
    THeaSet=294.15,
    THeaSetBack=289.15,
    TZon=westSensor.T) "On/off thermostat of the west room";
  FastSmoothBuildings.HVAC.IdealHeater westHeater(Q_flow_nominal=1500, fraRad=0.3, y=westControl.y)
    "Heater of the west room";
  FastSmoothBuildings.Controls.EmissionMonitored eastControl(
    TSet=289.15 + 5*FastSmoothBuildings.Utilities.occupancy(FastSmoothBuildings.Utilities.timeOfDay(time),
      3600*{6, 9, 17, 23}, 60),
    TZon=east.TAir) "Proportional control of the east room on a set point given as a signal";
  FastSmoothBuildings.HVAC.IdealHeatingCooling eastHeater(fraRad=0.3, Q_flow=1500*eastControl.y)
    "Heater of the east room";
equation
  connect(weather.weaBus, west.weaBus);
  connect(weather.weaBus, east.weaBus);
  connect(west.propsBus[1], westSouth.propsBus_a);
  connect(west.propsBus[2], westWest.propsBus_a);
  connect(west.propsBus[3], westNorth.propsBus_a);
  connect(west.propsBus[4], westWindow.propsBus_a);
  connect(west.propsBus[5], partition.propsBus_a);
  connect(west.propsBus[6], westFloor.propsBus_a);
  connect(west.propsBus[7], westCeiling.propsBus_a);
  connect(east.propsBus[1], eastSouth.propsBus_a);
  connect(east.propsBus[2], eastEast.propsBus_a);
  connect(east.propsBus[3], eastNorth.propsBus_a);
  connect(east.propsBus[4], eastWindow.propsBus_a);
  connect(east.propsBus[5], partition.propsBus_b);
  connect(east.propsBus[6], eastFloor.propsBus_a);
  connect(east.propsBus[7], eastCeiling.propsBus_a);
  connect(westGains.gai, west.qGai_flow);
  connect(eastGains.gai, east.qGai_flow);
  connect(westSensor.port, west.heaPorAir);
  connect(westHeater.heatPortCon, west.heaPorAir);
  connect(westHeater.heatPortRad, west.heaPorRad);
  connect(eastHeater.heatPortCon, east.heaPorAir);
  connect(eastHeater.heatPortRad, east.heaPorRad);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
Two rooms of 20 m<sup>2</sup> side by side, joined by an internal wall, on a slab on the ground and under a heated
storey. The west room has an ideal heater driven by an on/off thermostat (a fast bistable state, without events),
the east room one driven by a proportional controller whose set point is a signal: 21 &deg;C from 6:00 to 9:00
and from 17:00 to 23:00, 16 &deg;C otherwise.
</p>
</html>"));
end TwoZones;
