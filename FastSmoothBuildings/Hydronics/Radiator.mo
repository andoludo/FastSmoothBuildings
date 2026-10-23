within FastSmoothBuildings.Hydronics;
model Radiator "EN 442 radiator (Buildings RadiatorEN442_2): nEle water and metal elements in series"
  extends PartialConserving(final GHyd=m_flow_nominal/dp_nominal);
  parameter Real dp_nominal(unit="Pa") = 2000 "Pressure drop at the nominal flow, linearized (pressure-driven flows)";
  parameter Real Q_flow_nominal(unit="W") "Nominal heating power"
    annotation (Evaluate=true);
  parameter Real T_a_nominal(unit="K") "Water inlet temperature at nominal conditions"
    annotation (Evaluate=true);
  parameter Real T_b_nominal(unit="K") "Water outlet temperature at nominal conditions"
    annotation (Evaluate=true);
  parameter Real TAir_nominal(unit="K") = 293.15 "Air temperature at nominal conditions"
    annotation (Evaluate=true);
  parameter Real TRad_nominal(unit="K") = TAir_nominal "Radiative temperature at nominal conditions"
    annotation (Evaluate=true);
  parameter Real n = 1.24 "Exponent of the EN 442 power law"
    annotation (Evaluate=true);
  parameter Real fraRad = 0.35 "Radiant share of the heat output"
    annotation (Evaluate=true);
  parameter Integer nEle = 5 "Number of elements"
    annotation (Evaluate=true);
  parameter Real VWat(unit="m3") = 5.8e-6*abs(Q_flow_nominal) "Water volume";
  parameter Real mDry(unit="kg") = 0.0263*abs(Q_flow_nominal) "Dry mass lumped to the water";
  parameter Real T_start(unit="K") = 293.15 "Initial water temperature";
  parameter Real dT0(unit="K") = 0.05 "Regularisation of the power law around a zero temperature difference";
  parameter Real UAEle(unit="W/K") = radiatorConductance(Q_flow_nominal, T_a_nominal, T_b_nominal, TAir_nominal,
    TRad_nominal, fraRad, n, nEle) "Conductance of each element";
  parameter Real C(unit="J/K") = rhoWat*VWat*cpWat + 500*mDry "Heat capacity of the water and of the dry mass";
  final parameter Real m_flow_nominal(unit="kg/s") = abs(Q_flow_nominal/cpWat/(T_a_nominal - T_b_nominal))
    "Nominal flow";
  Real T[nEle](each unit="K", each start=T_start, each fixed=true) "Water temperature of each element";
  Interfaces.HeatPort heatPortCon "Convective heat to the room air"
    annotation (Placement(transformation(extent={{-30,62},{-10,82}})));
  Interfaces.HeatPort heatPortRad "Radiative heat to the room surfaces"
    annotation (Placement(transformation(extent={{10,62},{30,82}})));
  Real Q_flow(unit="W") "Heat output";
protected
  Real QCon[nEle](each unit="W") "Convective heat output of each element";
  Real QRad[nEle](each unit="W") "Radiative heat output of each element";
  Real TUp[nEle](each unit="K") "Temperature of the water entering each element";
equation
  for i in 1:nEle loop
    TUp[i] = if i == 1 then TIn else T[max(i - 1, 1)];
    QCon[i] = (1 - fraRad)*UAEle*(T[i] - heatPortCon.T)*((T[i] - heatPortCon.T)^2 + dT0^2)^((n - 1)/2);
    QRad[i] = fraRad*UAEle*(T[i] - heatPortRad.T)*((T[i] - heatPortRad.T)^2 + dT0^2)^((n - 1)/2);
    der(T[i]) = (mTra*cpWat*(TUp[i] - T[i]) - QCon[i] - QRad[i])*nEle/C;
  end for;
  TOut = T[nEle];
  if pressureDriven then
    for i in 1:nPorts_b loop
      port_b[i].m_flow = -GHyd/nPorts_b*(pIn - port_b[i].p);
    end for;
  end if;
  Q_flow = sum(QCon) + sum(QRad);
  heatPortCon.Q_flow = -sum(QCon);
  heatPortRad.Q_flow = -sum(QRad);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-95,6},{106,-4}}, lineColor={0,0,255}, pattern=LinePattern.None, fillColor={0,0,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-102,-4},{-2,6}}, lineColor={0,0,255}, pattern=LinePattern.None, fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-80,60},{80,-60}}, lineColor={0,0,0}, fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Line(points={{-66,30},{66,30}}),
      Line(points={{-66,2},{66,2}}),
      Line(points={{-66,-30},{66,-30}}),
      Line(points={{-66,60},{-66,-60}}),
      Line(points={{66,60},{66,-60}}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end Radiator;
