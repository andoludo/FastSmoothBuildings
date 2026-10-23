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
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Boiler fired at the part load ratio <code>y</code>: a single node of water and metal at the temperature
<code>T</code>, heated by the fuel and losing heat to the boiler room. The water leaves at <code>T</code>.
</p>
<h4>Equations</h4>
<p>
Fuel power and efficiency, the coefficients <code>a</code> padded with zeros to six:
</p>
<p>
<i>Q<sub>fue</sub></i> = <i>y</i> <code>Q_flow_nominal</code> / <i>&eta;<sub>nom</sub></i>,
</p>
<table summary=\"Efficiency curves of the boiler\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th><code>effCur</code></th><th><i>&eta;</i></th><th><i>&eta;<sub>nom</sub></i></th></tr>
<tr><td><code>QuadraticLinear</code></td>
<td><i>a<sub>1</sub></i> + <i>a<sub>2</sub></i> <i>y</i> + <i>a<sub>3</sub></i> <i>y</i><sup>2</sup> +
(<i>a<sub>4</sub></i> + <i>a<sub>5</sub></i> <i>y</i> + <i>a<sub>6</sub></i> <i>y</i><sup>2</sup>) <i>T</i></td>
<td><i>&eta;</i> at <i>y</i> = 1 and <i>T</i> = <code>T_nominal</code></td></tr>
<tr><td><code>Constant</code>, <code>Polynomial</code></td>
<td><i>a<sub>1</sub></i> + <i>a<sub>2</sub></i> <i>y</i> + &hellip; + <i>a<sub>6</sub></i>
<i>y</i><sup>5</sup></td>
<td><i>&eta;</i> at <i>y</i> = 1</td></tr>
</table>
<p>
Energy balance of the water and metal, with the heat capacity <i>C</i> = <i>&rho;</i> <code>VWat</code>
<i>c<sub>p</sub></i> + 500 J/(kg K) <code>mDry</code>:
</p>
<p>
<i>Q<sub>wat</sub></i> = <i>&eta;</i> <i>Q<sub>fue</sub></i> + <code>UA</code> (<code>TAmb</code> &minus;
<i>T</i>), &nbsp;
<i>C</i> d<i>T</i>/d<i>t</i> = <code>mTra</code> <i>c<sub>p</sub></i> (<code>TIn</code> &minus; <i>T</i>) +
<i>Q<sub>wat</sub></i>.
</p>
<p>
The fuel meter <code>EFue</code> integrates <i>Q<sub>fue</sub></i> in kWh: a state, exact whatever the output
interval.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, the boiler is the reference of its circuit: it has no mass balance, the circuit closes it, and its
flows are set by the valves. With pressure-driven flows, each of the <i>n<sub>b</sub></i> outlets passes the flow
of a quadratic resistance, <code>port_b[j].m_flow</code> =
&minus;<a href=\"modelica://FastSmoothBuildings.Utilities.quadraticFlow\">quadraticFlow</a>(<i>p<sub>in</sub></i>
&minus; <i>p<sub>b,j</sub></i>, <code>m_flow_nominal</code>/<i>n<sub>b</sub></i>, <code>dp_nominal</code>,
<code>deltaM</code>), regularized below <code>deltaM</code> times the nominal flow.
</p>
<h4>Parameters</h4>
<ul>
<li><code>UA</code>: heat loss conductance to the boiler room, twice 10<sup>&minus;4</sup>
<code>Q_flow_nominal</code> by default, because <code>BoilerPolynomial</code> of Buildings 13 counts its loss
twice.</li>
<li><code>m_flow_nominal</code>: by default the flow that carries <code>Q_flow_nominal</code> with a 20 K
temperature difference; used with pressure-driven flows only.</li>
<li><code>VWat</code>, <code>mDry</code>: water volume and dry mass, by default proportional to
<code>Q_flow_nominal</code>.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.Boilers.BoilerPolynomial</code>, with the efficiency curves of
<a href=\"modelica://FastSmoothBuildings.Types\">Types.EfficiencyCurves</a>. Buildings 13 injects
<i>&eta;</i> <i>Q<sub>fue</sub></i> and the heat flow of its loss conductance into the water, then conducts that
loss out of the water again: the loss counts twice, which the doubled <code>UA</code> reproduces.
</p>
<h4>Use</h4>
<p>
Fired by
<a href=\"modelica://FastSmoothBuildings.Controls.BoilerTemperatureControl\">Controls.BoilerTemperatureControl</a>
in <a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end Boiler;
