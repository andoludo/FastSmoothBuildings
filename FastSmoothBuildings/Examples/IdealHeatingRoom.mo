within FastSmoothBuildings.Examples;
model IdealHeatingRoom "Room of BESTEST case 600, heated to 20 degC and cooled to 27 degC by an ideal system"
  extends FreeFloatingRoom;
  FastSmoothBuildings.HVAC.IdealHeatingCoolingPI hvac(
    TSetHea=[0, 293.15],
    TSetCoo=[0, 300.15]) "Ideal heating and cooling, convective, with its PI controllers"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
equation
  connect(hvac.heatPortCon, zone.heaPorAir);
  connect(hvac.heatPortRad, zone.heaPorRad);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
The room of <a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">FreeFloatingRoom</a> with the
ideal system of BESTEST case 600: heating below 20 &deg;C, cooling above 27 &deg;C, without limit. The heating
and cooling meters <code>hvac.EHea</code> and <code>hvac.ECoo</code> give the loads.
</p>
</html>"));
end IdealHeatingRoom;
