within FastSmoothBuildings.Examples;
model BoilerCircuit "Room heated by a gas boiler and a radiator, in closed loop with pressure-driven flows"
  extends BaseClasses.PartialHydronicRoom;
  FastSmoothBuildings.Hydronics.Radiator radiator(
    Q_flow_nominal=2500,
    T_a_nominal=353.15,
    T_b_nominal=333.15,
    TAir_nominal=293.15,
    TRad_nominal=293.15,
    n=1.24,
    fraRad=0.3,
    nEle=1,
    VWat=0.0145,
    mDry=65.75,
    pressureDriven=pressureDriven,
    dp_nominal=2000,
    T_start=293.15) "Radiator, EN 442";
  FastSmoothBuildings.Hydronics.Valve valve(
    pressureDriven=pressureDriven,
    m_flow_nominal=0.06,
    dpValve_nominal=10000,
    dpFixed_nominal=5000) "Thermostatic valve of the radiator";
  FastSmoothBuildings.Controls.EmissionPI emission(
    schedule=3600*{7, 22},
    THeaSet=294.15,
    THeaSetBack=289.15,
    TZon=zone.TAir) "Room controller: 21 degC from 7:00 to 22:00, 16 degC otherwise";
  FastSmoothBuildings.Hydronics.Junction split(
    pressureDriven=pressureDriven,
    dp_nominal={5000, -1, -1},
    m_flow_nominal=0.15*{1, -1, -1}) "Return: to the boiler and to the bypass of the three-way valve";
  FastSmoothBuildings.Controls.BoilerTemperatureControl boilerControl(TempSet=353.15, T=boiler.T, demand=1)
    "Firing of the boiler";
  FastSmoothBuildings.Hydronics.Boiler boiler(
    Q_flow_nominal=2579,
    effCur=FastSmoothBuildings.Types.EfficiencyCurves.Constant,
    a={0.9},
    T_nominal=353.15,
    pressureDriven=pressureDriven,
    m_flow_nominal=0.0461,
    dp_nominal=5580,
    y=boilerControl.y) "Gas boiler";
  FastSmoothBuildings.Hydronics.Pump pump(
    dp_nominal=30000,
    m_flow_nominal=0.15,
    pressureDriven=pressureDriven,
    y=collector.y) "Pump of the circuit";
  FastSmoothBuildings.Controls.CollectorControl collector(nVal=1, yVal={emission.y},
    dpRel=pump.dp/pump.dp_nominal) "Speed of the pump from the opening of the valve";
  FastSmoothBuildings.Hydronics.ThreeWayValve threeWay(
    pressureDriven=pressureDriven,
    m_flow_nominal=0.15,
    dpValve_nominal=6000,
    dpFixed_nominal={2000, 0}) "Mixing valve of the supply";
  FastSmoothBuildings.Controls.ThreeWayValveControl supplyControl(TColSet=363.15)
    "Supply set point above the boiler: the valve stays open, as in trano's circuits";
  FastSmoothBuildings.Hydronics.TemperatureSensor supply(pressureDriven=pressureDriven, m_flow_nominal=0.15)
    "Supply temperature";
equation
  connect(zone.heaPorAir, radiator.heatPortCon);
  connect(zone.heaPorRad, radiator.heatPortRad);
  connect(radiator.port_b[1], valve.port_a[1]);
  connect(valve.y, emission.y);
  connect(valve.port_b[1], split.port_1[1]);
  connect(split.port_2[1], boiler.port_a[1]);
  connect(split.port_3[1], threeWay.port_3[1]);
  connect(boiler.port_b[1], pump.port_a[1]);
  connect(pump.port_b[1], threeWay.port_1[1]);
  connect(threeWay.y, supplyControl.y);
  connect(threeWay.port_2[1], supply.port_a[1]);
  connect(supplyControl.u, supply.T);
  connect(supply.port_b[1], radiator.port_a[1]);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
The circuit of trano's single-zone hydronic test, in closed loop: a gas boiler held at 80 &deg;C, a pump whose
speed follows the opening of the valve, a three-way valve (open: its set point is above the boiler), a radiator and its
valve, opened by a PI room controller (21 &deg;C by day, 16 &deg;C at night). The flows follow the pressures of
the circuit: a pressure node at the inlet of every component, the pump on its curve.
</p>
</html>"));
end BoilerCircuit;
