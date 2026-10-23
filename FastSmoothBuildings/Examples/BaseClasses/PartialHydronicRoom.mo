within FastSmoothBuildings.Examples.BaseClasses;
partial model PartialHydronicRoom "Room of 100 m2 with insulated cavity walls and triple glazing, to heat with water"
  extends FastSmoothBuildings.Icons.Example;
  parameter Boolean pressureDriven = true
    "true: pressure-driven flows (closed loop); false: set flows (the model of optimal control)"
    annotation (Evaluate=true);
  SyntheticWeather weather(TMea=270.15, TAmp=4, HDirNorMax=500) "Clear winter days around -3 degC"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  FastSmoothBuildings.Zones.Zone zone(nSurf=6, AFlo=100, hRoo=2.5, ACH=0.2, T_start=293.15) "Room"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  FastSmoothBuildings.Envelope.OuterWall south(constructionType=FastSmoothBuildings.Examples.Constructions.CavityWall(),
    A=15, azi=0, til=FastSmoothBuildings.Types.Tilt.Wall, T_start=291.15) "South wall";
  FastSmoothBuildings.Envelope.OuterWall west(constructionType=FastSmoothBuildings.Examples.Constructions.CavityWall(),
    A=30, azi=pi/2, til=FastSmoothBuildings.Types.Tilt.Wall, T_start=291.15) "West wall";
  FastSmoothBuildings.Envelope.OuterWall north(constructionType=FastSmoothBuildings.Examples.Constructions.CavityWall(),
    A=48, azi=pi, til=FastSmoothBuildings.Types.Tilt.Wall, T_start=291.15) "North wall";
  FastSmoothBuildings.Envelope.Window southWindow(glazing=FastSmoothBuildings.Examples.Constructions.TripleArgon(),
    A=5, frac=0.1, azi=0, til=FastSmoothBuildings.Types.Tilt.Wall, T_start=291.15) "South window";
  FastSmoothBuildings.Envelope.Window northWindow(glazing=FastSmoothBuildings.Examples.Constructions.TripleArgon(),
    A=2, frac=0.1, azi=pi, til=FastSmoothBuildings.Types.Tilt.Wall, T_start=291.15) "North window";
  FastSmoothBuildings.Envelope.BoundaryWall floor(constructionType=FastSmoothBuildings.Examples.Constructions.ConcreteSlab(),
    A=50, TGro=283.15, til=FastSmoothBuildings.Types.Tilt.Floor, T_start=290.15) "Slab on the ground";
  FastSmoothBuildings.Zones.InternalGains gains(QCon=1.5, QRad=1.5) "Internal gains, 300 W";
equation
  connect(weather.weaBus, zone.weaBus);
  connect(zone.propsBus[1], south.propsBus_a);
  connect(zone.propsBus[2], west.propsBus_a);
  connect(zone.propsBus[3], north.propsBus_a);
  connect(zone.propsBus[4], southWindow.propsBus_a);
  connect(zone.propsBus[5], northWindow.propsBus_a);
  connect(zone.propsBus[6], floor.propsBus_a);
  connect(gains.gai, zone.qGai_flow);
  annotation (Documentation(info="<html>
<p>
The room of trano's single-zone hydronic test: 100 m<sup>2</sup>, insulated cavity walls whose layers are split
into sublayers as Buildings splits them, 7 m<sup>2</sup> of triple glazing, a concrete slab on the ground. The
examples that extend it heat it with water.
</p>
</html>"));
end PartialHydronicRoom;
