within FastSmoothBuildings.Hydronics;
model Boiler
  "Boiler (Buildings BoilerPolynomial): water and metal heated by the part load ratio y; with set flows, the
   reference of its circuit (no mass balance)"
  extends PartialFlow(final GHyd=m_flow_nominal/dp_nominal);
  parameter Real m_flow_nominal(unit="kg/s") = Q_flow_nominal/cpWat/20 "Nominal flow (pressure-driven flows)";
  parameter Real dp_nominal(unit="Pa") = 5000 "Pressure drop at the nominal flow (pressure-driven flows)";
  parameter Real deltaM = 0.1 "Regularization of the quadratic flow law below deltaM*m_flow_nominal";
  parameter Real Q_flow_nominal(unit="W") "Nominal heating power";
  parameter Integer effCur = Types.EfficiencyCurves.Constant "Efficiency curve";
  parameter Real a[:] = {0.9} "Coefficients of the efficiency curve (Buildings)";
  parameter Real T_nominal(unit="K") = 353.15 "Temperature used to compute the nominal efficiency";
  parameter Real VWat(unit="m3") = 1.5e-6*Q_flow_nominal "Water volume";
  parameter Real mDry(unit="kg") = 1.5e-3*Q_flow_nominal "Dry mass";
  parameter Real UA(unit="W/K") = 2*1e-4*Q_flow_nominal
    "Heat loss conductance to the boiler room (Buildings 13 BoilerPolynomial counts its UA loss twice)";
  parameter Real TAmb(unit="K") = 288.15 "Temperature of the boiler room";
  parameter Real T_start(unit="K") = 293.15 "Initial water temperature";
  parameter Real C(unit="J/K") = rhoWat*VWat*cpWat + 500*mDry "Heat capacity of the water and of the dry mass";
  Interfaces.RealInput y(unit="1") "Part load ratio, 0 to 1"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Real T(unit="K", start=T_start, fixed=true) "Water temperature";
  Real EFue(unit="kWh", start=0, fixed=true) "Fuel meter";
  Real QFue(unit="W") "Fuel power";
  Real QWat(unit="W") "Heat to the water";
  Real eta "Efficiency";
protected
  parameter Real aPad[6] = cat(1, a, zeros(6 - size(a, 1))) "Coefficients padded with zeros";
  parameter Real eta_nominal = if effCur == Types.EfficiencyCurves.QuadraticLinear then aPad[1] + aPad[2] + aPad[3]
    + (aPad[4] + aPad[5] + aPad[6])*T_nominal else sum(aPad) "Efficiency at nominal conditions";
equation
  // the reference of its circuit: no mass balance (the circuit closes it), the circuit flows set by its valves
  QFue = y*Q_flow_nominal/eta_nominal;
  eta = if effCur == Types.EfficiencyCurves.QuadraticLinear then aPad[1] + aPad[2]*y + aPad[3]*y^2
    + (aPad[4] + aPad[5]*y + aPad[6]*y^2)*T else aPad[1] + aPad[2]*y + aPad[3]*y^2 + aPad[4]*y^3 + aPad[5]*y^4
    + aPad[6]*y^5;
  QWat = eta*QFue + UA*(TAmb - T);
  C*der(T) = mTra*cpWat*(TIn - T) + QWat;
  der(EFue) = QFue/3.6e6;
  TOut = T;
  if pressureDriven then
    for i in 1:nPorts_b loop
      port_b[i].m_flow = -Utilities.quadraticFlow(pIn - port_b[i].p, m_flow_nominal/nPorts_b, dp_nominal, deltaM);
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-70,60},{70,-60}}, lineColor={0,0,255}, pattern=LinePattern.None,
        fillColor={95,95,95}, fillPattern=FillPattern.Solid),
      Rectangle(extent={{-101,5},{100,-4}}, lineColor={0,0,255}, pattern=LinePattern.None, fillColor={0,0,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{0,-4},{100,5}}, lineColor={0,0,255}, pattern=LinePattern.None, fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{0,-34},{-12,-52},{14,-52},{0,-34}}, pattern=LinePattern.None, fillColor={255,255,0},
        fillPattern=FillPattern.Solid, lineColor={0,0,0}),
      Line(points={{-100,80},{-80,80},{-80,-44},{-6,-44}}),
      Text(extent={{-38,146},{-158,96}}, textColor={0,0,0}, textString="y"),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end Boiler;
