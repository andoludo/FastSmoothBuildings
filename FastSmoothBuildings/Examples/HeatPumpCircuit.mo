within FastSmoothBuildings.Examples;
model HeatPumpCircuit "Room heated by an air-to-water heat pump with a buffer and two radiators, in closed loop"
  extends BaseClasses.PartialHydronicRoom;
  FastSmoothBuildings.Hydronics.Radiator radiator1(
    Q_flow_nominal=2500,
    T_a_nominal=318.15,
    T_b_nominal=308.15,
    TAir_nominal=293.15,
    n=1.24,
    fraRad=0.3,
    nEle=1,
    pressureDriven=pressureDriven,
    T_start=293.15) "Low-temperature radiator under the south window, 45/35 degC";
  FastSmoothBuildings.Hydronics.Valve valve1(
    pressureDriven=pressureDriven,
    m_flow_nominal=0.06,
    dpValve_nominal=10000,
    dpFixed_nominal=5000) "Thermostatic valve of radiator1";
  FastSmoothBuildings.Controls.EmissionP emission1(
    schedule=3600*{6, 22},
    THeaSet=294.15,
    THeaSetBack=290.15,
    TZon=zone.TAir) "Proportional room controller of valve1";
  FastSmoothBuildings.Hydronics.Radiator radiator2(
    Q_flow_nominal=2500,
    T_a_nominal=318.15,
    T_b_nominal=308.15,
    TAir_nominal=293.15,
    n=1.24,
    fraRad=0.3,
    nEle=1,
    pressureDriven=pressureDriven,
    T_start=293.15) "Low-temperature radiator under the north window, 45/35 degC";
  FastSmoothBuildings.Hydronics.Valve valve2(
    pressureDriven=pressureDriven,
    m_flow_nominal=0.06,
    dpValve_nominal=10000,
    dpFixed_nominal=5000) "Thermostatic valve of radiator2";
  FastSmoothBuildings.Controls.EmissionP emission2(
    schedule=3600*{6, 22},
    THeaSet=294.15,
    THeaSetBack=290.15,
    TZon=zone.TAir) "Proportional room controller of valve2";
  FastSmoothBuildings.Hydronics.Junction2 returnPipe(pressureDriven=pressureDriven, nPorts_1=2)
    "Return of the two radiators";
  FastSmoothBuildings.Hydronics.Junction split(pressureDriven=pressureDriven)
    "Return: to the heat pump and to the bypass of the three-way valve";
  FastSmoothBuildings.Hydronics.HeatPump heatPump(
    Q_flow_nominal=4000,
    TSet=318.15,
    useStorageTank=true,
    VTan=0.1,
    pressureDriven=pressureDriven,
    m_flow_nominal=0.12,
    y=heatPumpControl.y) "Air-to-water heat pump charging a 100 l buffer";
  FastSmoothBuildings.Controls.BoilerDemand demand(n=1, yMax={collector.yMax}) "Demand of the circuit";
  FastSmoothBuildings.Controls.HeatPumpControl heatPumpControl(
    TSet=318.15,
    demand=demand.y,
    TOut=heatPump.weaBus.TDryBul,
    TBuf=heatPump.T,
    TConOut=heatPump.TConOut) "Heating curve and compressor speed";
  FastSmoothBuildings.Hydronics.Pump pump(
    dp_nominal=30000,
    m_flow_nominal=0.12,
    pressureDriven=pressureDriven,
    y=collector.y) "Pump of the circuit";
  FastSmoothBuildings.Hydronics.Pipe pipe(pressureDriven=pressureDriven, m_flow_nominal=0.12) "Supply pipe";
  FastSmoothBuildings.Controls.CollectorControl collector(nVal=2, yVal={emission1.y, emission2.y},
    dpRel=pump.dp/pump.dp_nominal) "Speed of the pump from the openings of the valves";
  FastSmoothBuildings.Hydronics.ThreeWayValve threeWay(
    pressureDriven=pressureDriven,
    m_flow_nominal=0.12,
    dpValve_nominal=6000,
    dpFixed_nominal={2000, 0}) "Three-way valve, open: the heat pump sets the supply";
  FastSmoothBuildings.Controls.ThreeWayValveControl supplyControl(TColSet=363.15)
    "Supply set point above the heat pump: the valve stays open";
  FastSmoothBuildings.Hydronics.TemperatureSensor supply(pressureDriven=pressureDriven, m_flow_nominal=0.12,
    nPorts_b=2) "Supply temperature, to both radiators";
equation
  connect(heatPump.weaBus, weather.weaBus);
  connect(zone.heaPorAir, radiator1.heatPortCon);
  connect(zone.heaPorRad, radiator1.heatPortRad);
  connect(radiator1.port_b[1], valve1.port_a[1]);
  connect(valve1.y, emission1.y);
  connect(valve1.port_b[1], returnPipe.port_1[1]);
  connect(supply.port_b[1], radiator1.port_a[1]);
  connect(zone.heaPorAir, radiator2.heatPortCon);
  connect(zone.heaPorRad, radiator2.heatPortRad);
  connect(radiator2.port_b[1], valve2.port_a[1]);
  connect(valve2.y, emission2.y);
  connect(valve2.port_b[1], returnPipe.port_1[2]);
  connect(supply.port_b[2], radiator2.port_a[1]);
  connect(returnPipe.port_2[1], split.port_1[1]);
  connect(split.port_2[1], heatPump.port_a[1]);
  connect(split.port_3[1], threeWay.port_3[1]);
  connect(heatPump.port_b[1], pump.port_a[1]);
  connect(pump.port_b[1], pipe.port_a[1]);
  connect(pipe.port_b[1], threeWay.port_1[1]);
  connect(threeWay.y, supplyControl.y);
  connect(threeWay.port_2[1], supply.port_a[1]);
  connect(supplyControl.u, supply.T);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
The circuit of trano's renovated house in one room: an air-to-water heat pump (the table data of a Vitocal 251-A08
scaled to 4 kW) charging a 100 l buffer on a heating curve, a pump following the openings of the valves, two
low-temperature radiators with proportional room controllers. The heat pump runs while the circuit asks for heat
(<a href=\"modelica://FastSmoothBuildings.Controls.BoilerDemand\">BoilerDemand</a>) and the buffer is below its
band; its compressor speed is a smooth PI output above its minimum.
</p>
</html>"));
end HeatPumpCircuit;
