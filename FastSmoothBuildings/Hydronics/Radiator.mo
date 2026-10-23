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
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Radiator after EN 442: <code>nEle</code> elements of water and metal in series, each giving heat to the room air
(<code>heatPortCon</code>) and to the room surfaces (<code>heatPortRad</code>) by the power law of EN 442.
</p>
<h4>Equations</h4>
<p>
For element <i>i</i> at the water temperature <i>T<sub>i</sub></i>, with <i>UA</i> = <code>UAEle</code>,
<i>f</i> = <code>fraRad</code>, <i>n</i> the exponent and <i>&delta;</i> = <code>dT0</code>:
</p>
<p>
<i>Q<sub>con,i</sub></i> = (1 &minus; <i>f</i>) <i>UA</i> &Delta;<i>T<sub>con</sub></i>
(&Delta;<i>T<sub>con</sub></i><sup>2</sup> + <i>&delta;</i><sup>2</sup>)<sup>(<i>n</i> &minus; 1)/2</sup>,
&nbsp; &Delta;<i>T<sub>con</sub></i> = <i>T<sub>i</sub></i> &minus; <i>T<sub>air</sub></i>,
</p>
<p>
<i>Q<sub>rad,i</sub></i> = <i>f</i> <i>UA</i> &Delta;<i>T<sub>rad</sub></i>
(&Delta;<i>T<sub>rad</sub></i><sup>2</sup> + <i>&delta;</i><sup>2</sup>)<sup>(<i>n</i> &minus; 1)/2</sup>,
&nbsp; &Delta;<i>T<sub>rad</sub></i> = <i>T<sub>i</sub></i> &minus; <i>T<sub>surf</sub></i>,
</p>
<p>
(<i>C</i>/<code>nEle</code>) d<i>T<sub>i</sub></i>/d<i>t</i> = <code>mTra</code> <i>c<sub>p</sub></i>
(<i>T<sub>i&minus;1</sub></i> &minus; <i>T<sub>i</sub></i>) &minus; <i>Q<sub>con,i</sub></i> &minus;
<i>Q<sub>rad,i</sub></i>,
</p>
<p>
with <i>T<sub>0</sub></i> = <code>TIn</code>; the water leaves at the temperature of the last element,
<code>TOut</code> = <i>T</i><sub><code>nEle</code></sub>. Far from &Delta;<i>T</i> = 0 the law is
&Delta;<i>T</i> |&Delta;<i>T</i>|<sup><i>n</i> &minus; 1</sup>; around it, it is linear, its slope
<i>&delta;</i><sup><i>n</i> &minus; 1</sup> times the conductance, so the derivative stays finite where that of the
exact power law does not. A radiator colder than the room takes heat from it.
</p>
<p>
The heat capacity <i>C</i> = <i>&rho;</i> <code>VWat</code> <i>c<sub>p</sub></i> + 500 J/(kg K)
<code>mDry</code> is shared evenly by the elements. <code>UAEle</code> is computed by
<a href=\"modelica://FastSmoothBuildings.Hydronics.radiatorConductance\">radiatorConductance</a> so that the
radiator gives <code>Q_flow_nominal</code> at the nominal temperatures and at the nominal flow
<code>m_flow_nominal</code> = |<code>Q_flow_nominal</code> / (<i>c<sub>p</sub></i> (<code>T_a_nominal</code>
&minus; <code>T_b_nominal</code>))|.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, what enters leaves. With pressure-driven flows, the outlets have the linear conductance
<code>m_flow_nominal</code>/<code>dp_nominal</code>, shared evenly by the outlet connections.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</code>, its pressure drop linearized.
</p>
<h4>Use</h4>
<p>
Connect <code>heatPortCon</code> to the air and <code>heatPortRad</code> to the radiant node of a zone, and a
<a href=\"modelica://FastSmoothBuildings.Hydronics.Valve\">Valve</a> in series, as in
<a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end Radiator;
