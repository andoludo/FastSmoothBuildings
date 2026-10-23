within FastSmoothBuildings.Zones;
partial model PartialZone
  "Room air, long-wave exchange between its surfaces, distribution of the transmitted solar radiation"
  parameter Integer nSurf(min=1) "Number of surfaces";
  parameter Real AFlo(unit="m2") "Floor area";
  parameter Real hRoo(unit="m") "Height";
  parameter Real V(unit="m3") = AFlo*hRoo "Air volume";
  parameter Real ACH(unit="1/h") = 0 "Air changes per hour by infiltration of outdoor air";
  parameter Real ventilationSchedule[:, 2] = [0, 0]
    "Day schedule of outdoor air brought in on top of the infiltration (night ventilation): time since midnight [s]
     and mass flow rate [kg/s], repeated daily; a step where the table repeats an instant, as trano's Buildings zone";
  parameter Real mSenFac = 1 "Factor for the sensible heat capacity of the air";
  parameter Real T_start(unit="K") = 294.15 "Initial temperature";
  parameter Real hConInt(unit="W/(m2.K)") = 0 "Fixed interior convection coefficient, 0 for the natural law";
  parameter Real hConExt(unit="W/(m2.K)") = 0 "Fixed exterior convection coefficient, 0 for the wind law";
  parameter Real T0Rad(unit="K") = 293.15 "Linearization temperature of the long-wave exchange";
  parameter Boolean linearizeRadiation = true
    "true: the long-wave exchange is linearised at T0Rad (Buildings' default); false: at the current mean surface
     temperature of the zone, close to the exact exchange of Buildings when it does not linearise";
  Interfaces.WeatherBusIn weaBus "Weather"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Interfaces.ZoneSurfaceBus propsBus[nSurf] "Surfaces"
    annotation (Placement(transformation(extent={{90,-20},{110,20}})));
  Interfaces.HeatPort heaPorAir "Convective heat (emitters)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.HeatPort heaPorRad "Radiant heat (emitters), at the mean surface temperature"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Interfaces.Gains qGai_flow "Internal gains"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Real TAir(unit="K", start=T_start, fixed=true) "Zone air temperature";
  Real TRad(unit="K") "Radiant star temperature";
  Real QVen(unit="W") "Heat brought by the ventilation";
  Real TLin(unit="K") "Temperature at which the long-wave exchange is linearised";
  Real mVen_flow(unit="kg/s") "Scheduled outdoor air flow";
  Real rho(unit="kg/m3") "Density of the zone air at the pressure of the site (ideal gas, Buildings.Media.Air)";
protected
  Real G[nSurf](each unit="W/K") "Long-wave conductance of each surface to the star";
  Real QDir(unit="W") "Transmitted direct solar radiation";
  Real QDif(unit="W") "Transmitted diffuse solar radiation";
  Real AFloSur(unit="m2") "Area of the floors";
  Real epsTauA(unit="m2") "Absorbing and transmitting area";
  Real kDif[nSurf] "Share of the diffuse radiation absorbed by each surface";
  Real kDir[nSurf] "Share of the direct radiation absorbed by each surface (floors first)";
equation
  // the mean surface temperature, weighted as the exchange: explicit in the states of the surfaces
  TLin = if linearizeRadiation then T0Rad else sum(propsBus[i].epsLw*propsBus[i].A*propsBus[i].rad.T
    for i in 1:nSurf)/sum(propsBus[i].epsLw*propsBus[i].A for i in 1:nSurf);
  for i in 1:nSurf loop
    connect(weaBus, propsBus[i].wea);
    propsBus[i].hConInt = hConInt;
    propsBus[i].hConExt = hConExt;
    G[i] = 4*sigma*TLin^3*propsBus[i].epsLw*propsBus[i].A;
    propsBus[i].con.T = TAir;
  end for;
  // Long-wave exchange through a radiant star: the exact equivalent of Buildings' linearized radiosity exchange
  // with view factors A_j/sum(A); radiant gains reach the surfaces in proportion to epsilon_i*A_i
  TRad = (sum(G[i]*propsBus[i].rad.T for i in 1:nSurf) + heaPorRad.Q_flow + AFlo*qGai_flow.QRad)/sum(G);
  heaPorRad.T = sum(G[i]*propsBus[i].rad.T for i in 1:nSurf)/sum(G);
  // Transmitted solar radiation (Buildings SolarRadiationExchange): direct radiation on the floors first
  QDir = sum(propsBus[i].QTraDir for i in 1:nSurf);
  QDif = sum(propsBus[i].QTraDif for i in 1:nSurf);
  AFloSur = sum(propsBus[i].isFloor*propsBus[i].A for i in 1:nSurf);
  epsTauA = sum((propsBus[i].absSol + propsBus[i].tauSol)*propsBus[i].A for i in 1:nSurf);
  for i in 1:nSurf loop
    kDif[i] = propsBus[i].absSol*propsBus[i].A/epsTauA;
    kDir[i] = noEvent(if AFloSur > 0 then (if propsBus[i].isFloor > 0.5 then propsBus[i].absSol*propsBus[i].A
      /AFloSur else sum(propsBus[j].isFloor*propsBus[j].A*(1 - propsBus[j].absSol - propsBus[j].tauSol)
      for j in 1:nSurf)/AFloSur*propsBus[i].absSol*propsBus[i].A/sum((1 - propsBus[j].isFloor)*(propsBus[j].absSol
      + propsBus[j].tauSol)*propsBus[j].A for j in 1:nSurf)) else kDif[i]);
    propsBus[i].rad.Q_flow = -(G[i]*(TRad - propsBus[i].rad.T) + kDir[i]*QDir + kDif[i]*QDif);
  end for;
  // Air
  mVen_flow = Utilities.dayTable(Utilities.timeOfDay(time), ventilationSchedule);
  // the infiltration is a volume flow of zone air (Buildings: ACH*V*density(pAtm, TAir)): at 1600 m it carries
  // a fifth less heat than with the density of sea level
  rho = weaBus.pAtm/(RAir*TAir);
  mSenFac*rho*cpAir*V*der(TAir) = sum(propsBus[i].con.Q_flow for i in 1:nSurf) + heaPorAir.Q_flow + AFlo*qGai_flow.QCon
    + (rho*V*ACH/3600 + mVen_flow)*cpAir*(weaBus.TDryBul - TAir) + QVen;
  heaPorAir.T = TAir;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-80,-80},{80,80}}, lineColor={95,95,95}, fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-70,70},{70,-70}}, pattern=LinePattern.None, lineColor={117,148,176},
        fillColor={170,213,255}, fillPattern=FillPattern.Sphere),
      Rectangle(extent={{70,35},{80,-35}}, lineColor={95,95,95}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{73,35},{77,-35}}, lineColor={95,95,95}, fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-30,6},{-11,-5}}, textColor={0,0,0}, textString="air"),
      Text(extent={{-36,-11},{-11,-25}}, textColor={0,0,0}, textString="radiation"),
      Text(extent={{-52,-62},{-27,-76}}, textColor={0,0,0}, textString="surface"),
      Text(extent={{-150,140},{150,100}}, textColor={0,0,255}, textString="%name")}));
end PartialZone;
