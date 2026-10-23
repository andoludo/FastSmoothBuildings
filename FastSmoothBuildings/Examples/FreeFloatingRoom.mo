within FastSmoothBuildings.Examples;
model FreeFloatingRoom "Room of BESTEST case 600FF under clear winter days, without heating"
  extends FastSmoothBuildings.Icons.Example;
  BaseClasses.SyntheticWeather weather(TMea=273.15, TAmp=6) "Clear winter days"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  FastSmoothBuildings.Zones.Zone zone(
    nSurf=7,
    AFlo=48,
    hRoo=2.7,
    ACH=0.414,
    linearizeRadiation=false,
    T_start=293.15) "Room of 8 m by 6 m, 2.7 m high"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  FastSmoothBuildings.Envelope.OuterWall south(
    constructionType=Constructions.LightWall(),
    A=9.6,
    azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall,
    T_start=293.15) "South wall, beside the window"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  FastSmoothBuildings.Envelope.OuterWall north(
    constructionType=Constructions.LightWall(),
    A=21.6,
    azi=pi,
    til=FastSmoothBuildings.Types.Tilt.Wall,
    T_start=293.15) "North wall"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  FastSmoothBuildings.Envelope.OuterWall east(
    constructionType=Constructions.LightWall(),
    A=16.2,
    azi=-pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall,
    T_start=293.15) "East wall"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FastSmoothBuildings.Envelope.OuterWall west(
    constructionType=Constructions.LightWall(),
    A=16.2,
    azi=pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall,
    T_start=293.15) "West wall"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  FastSmoothBuildings.Envelope.OuterWall roof(
    constructionType=Constructions.LightRoof(),
    A=48,
    azi=0,
    til=FastSmoothBuildings.Types.Tilt.Ceiling,
    T_start=293.15) "Roof"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  FastSmoothBuildings.Envelope.Window window(
    glazing=Constructions.DoubleClear(),
    A=12,
    hWin=2,
    frac=0.001,
    azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall,
    T_start=293.15) "Two south windows of 3 m by 2 m"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  FastSmoothBuildings.Envelope.BoundaryWall floor(
    constructionType=Constructions.LightFloor(),
    A=48,
    outdoorAir=true,
    til=FastSmoothBuildings.Types.Tilt.Floor,
    T_start=293.15) "Floor over outdoor air"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  FastSmoothBuildings.Zones.InternalGains gains(QCon=0.4*200/48, QRad=0.6*200/48)
    "200 W, 60 % radiant, as BESTEST"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(weather.weaBus, zone.weaBus);
  connect(zone.propsBus[1], south.propsBus_a);
  connect(zone.propsBus[2], north.propsBus_a);
  connect(zone.propsBus[3], east.propsBus_a);
  connect(zone.propsBus[4], west.propsBus_a);
  connect(zone.propsBus[5], roof.propsBus_a);
  connect(zone.propsBus[6], window.propsBus_a);
  connect(zone.propsBus[7], floor.propsBus_a);
  connect(gains.gai, zone.qGai_flow);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
The room of BESTEST case 600FF (ASHRAE Standard 140): light walls and roof, a floor insulated from the outdoor air,
12 m<sup>2</sup> of clear double glazing facing south, 200 W of internal gains, 0.414 air changes per hour, no
heating. Three clear winter days around 0 &deg;C: the sun through the windows warms the room by day, the room cools
at night.
</p>
</html>"));
end FreeFloatingRoom;
