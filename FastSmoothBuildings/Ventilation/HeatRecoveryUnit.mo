within FastSmoothBuildings.Ventilation;
model HeatRecoveryUnit
  "Balanced ventilation with a constant-effectiveness heat recovery and constant-pressure fans (trano's system D);
   the reference of its air loop"
  parameter Integer nPorts_a = 1 "Number of extract connections";
  parameter Integer nPorts_b = 1 "Number of supply connections";
  parameter Real m_flow_nominal(unit="kg/s") "Nominal supply flow";
  parameter Real eps = 0.8 "Heat recovery effectiveness";
  parameter Real dpSup_nominal(unit="Pa") = 200 "Pressure rise of the supply fan";
  parameter Real dpRet_nominal(unit="Pa") = 200 "Pressure rise of the return fan";
  parameter Real etaFan = 0.5 "Overall efficiency of the fans";
  parameter Real m_flow_small(unit="kg/s") = 1e-6;
  parameter Real PSup(unit="W") = dpSup_nominal*m_flow_nominal/rhoAir/etaFan "Supply fan power at nominal flow";
  parameter Real PRet(unit="W") = dpRet_nominal*m_flow_nominal/rhoAir/etaFan "Return fan power at nominal flow";
  parameter Real dTFan(unit="K") = (PSup + eps*PRet)/(m_flow_nominal*cpAir)
    "Heating of the supply air by the fans (supply after the exchanger, return before it)";
  AirInlet port_a[nPorts_a] "Extract air"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  AirOutlet port_b[nPorts_b] "Supply air"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Interfaces.RealInput y(unit="1") "Relative speed of the fans"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.WeatherBusIn weaBus "Weather: the outdoor air"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Real TExt(unit="K") "Mixed extract air temperature";
  Real TSup(unit="K") "Supply air temperature";
  Real PFan(unit="W") "Electrical power of the fans";
  Real EFan(unit="kWh", start=0, fixed=true) "Electricity meter of the fans";
equation
  TExt = (sum(port_a[i].m_flow*port_a[i].T for i in 1:nPorts_a) + m_flow_small*sum(port_a[i].T for i in 1:nPorts_a)
    /nPorts_a)/(sum(port_a[i].m_flow for i in 1:nPorts_a) + m_flow_small);
  TSup = weaBus.TDryBul + eps*(TExt - weaBus.TDryBul) + dTFan;
  for i in 1:nPorts_b loop
    port_b[i].T = TSup;
    port_b[i].y = y;
  end for;
  PFan = y*(PSup + PRet);
  der(EFan) = PFan/3.6e6;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,65},{101,55}}, lineColor={0,0,255}, pattern=LinePattern.None,
        fillColor={0,0,255}, fillPattern=FillPattern.Solid),
      Rectangle(extent={{-100,-55},{101,-65}}, lineColor={0,0,255}, pattern=LinePattern.None,
        fillColor={0,127,0}, fillPattern=FillPattern.Solid),
      Rectangle(extent={{-70,78},{70,-80}}, lineColor={0,0,255}, pattern=LinePattern.None,
        fillColor={95,95,95}, fillPattern=FillPattern.Solid),
      Text(extent={{-56,-12},{54,-72}}, textColor={255,255,255}, textString="eps=%eps"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end HeatRecoveryUnit;
