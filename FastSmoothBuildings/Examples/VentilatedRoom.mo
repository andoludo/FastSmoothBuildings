within FastSmoothBuildings.Examples;
model VentilatedRoom "Room of BESTEST case 600 with balanced ventilation and heat recovery"
  extends FastSmoothBuildings.Icons.Example;
  BaseClasses.SyntheticWeather weather(TMea=273.15, TAmp=6) "Clear winter days"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  FastSmoothBuildings.Zones.VentilatedZone zone(
    nSurf=7,
    AFlo=48,
    hRoo=2.7,
    ACH=0.1,
    linearizeRadiation=false,
    T_start=293.15) "Room with a supply and an extract duct";
  FastSmoothBuildings.Envelope.OuterWall south(constructionType=Constructions.LightWall(), A=9.6, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=293.15) "South wall";
  FastSmoothBuildings.Envelope.OuterWall north(constructionType=Constructions.LightWall(), A=21.6, azi=pi,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=293.15) "North wall";
  FastSmoothBuildings.Envelope.OuterWall east(constructionType=Constructions.LightWall(), A=16.2, azi=-pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=293.15) "East wall";
  FastSmoothBuildings.Envelope.OuterWall west(constructionType=Constructions.LightWall(), A=16.2, azi=pi/2,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=293.15) "West wall";
  FastSmoothBuildings.Envelope.OuterWall roof(constructionType=Constructions.LightRoof(), A=48, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Ceiling, T_start=293.15) "Roof";
  FastSmoothBuildings.Envelope.Window window(glazing=Constructions.DoubleClear(), A=12, hWin=2, frac=0.001, azi=0,
    til=FastSmoothBuildings.Types.Tilt.Wall, T_start=293.15) "South windows";
  FastSmoothBuildings.Envelope.BoundaryWall floor(constructionType=Constructions.LightFloor(), A=48, outdoorAir=true,
    til=FastSmoothBuildings.Types.Tilt.Floor, T_start=293.15) "Floor over outdoor air";
  FastSmoothBuildings.Zones.InternalGains gains(QCon=0.4*200/48, QRad=0.6*200/48) "200 W, 60 % radiant";
  FastSmoothBuildings.Ventilation.HeatRecoveryUnit unit(
    m_flow_nominal=0.04,
    eps=0.8,
    dpSup_nominal=150,
    dpRet_nominal=150,
    y=0.3 + 0.7*FastSmoothBuildings.Utilities.occupancy(FastSmoothBuildings.Utilities.timeOfDay(time),
      3600*{7, 19}, 600)) "Air handling unit with heat recovery: full speed from 7:00 to 19:00, 30 % otherwise";
  FastSmoothBuildings.Ventilation.Duct supplyDuct(m_flow_nominal=0.04) "Supply duct";
  FastSmoothBuildings.Ventilation.Duct extractDuct(m_flow_nominal=0.04) "Extract duct";
equation
  connect(weather.weaBus, zone.weaBus);
  connect(weather.weaBus, unit.weaBus);
  connect(zone.propsBus[1], south.propsBus_a);
  connect(zone.propsBus[2], north.propsBus_a);
  connect(zone.propsBus[3], east.propsBus_a);
  connect(zone.propsBus[4], west.propsBus_a);
  connect(zone.propsBus[5], roof.propsBus_a);
  connect(zone.propsBus[6], window.propsBus_a);
  connect(zone.propsBus[7], floor.propsBus_a);
  connect(gains.gai, zone.qGai_flow);
  connect(unit.port_b[1], supplyDuct.port_a[1]);
  connect(supplyDuct.port_b[1], zone.ports_a[1]);
  connect(zone.ports_b[1], extractDuct.port_a[1]);
  connect(extractDuct.port_b[1], unit.port_a[1]);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
The room of BESTEST case 600, ventilated by an air handling unit with heat recovery (effectiveness 0.8) through a
supply and an extract duct: 0.04 kg/s from 7:00 to 19:00, 30 % of it otherwise. The supply air is the outdoor air
warmed by the extract air and by the fans; the fans' electricity is metered in <code>unit.EFan</code>.
</p>
</html>"));
end VentilatedRoom;
