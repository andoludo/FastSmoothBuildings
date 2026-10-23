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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Air handling unit of a balanced ventilation (trano's system D): outdoor air through a heat recovery of constant
effectiveness, warmed by constant-pressure fans, and the electricity of the fans metered. The unit is the reference
of its air loop: it sets the speed <code>y</code> that the ducts downstream turn into their flows, and the supply
air temperature.
</p>
<h4>Equations</h4>
<p>
Mixed extract air temperature, regularised by <code>m_flow_small</code> so that it is defined at zero flow (the
mean of the port temperatures):
</p>
<p>
<i>T<sub>Ext</sub></i> = (&sum; <i>&#7745;<sub>i</sub></i> <i>T<sub>i</sub></i> + <i>&#7745;<sub>small</sub></i>
&sum; <i>T<sub>i</sub></i>/<i>n</i>) / (&sum; <i>&#7745;<sub>i</sub></i> + <i>&#7745;<sub>small</sub></i>).
</p>
<p>
Supply air and fans:
</p>
<p>
<i>T<sub>Sup</sub></i> = <i>T<sub>DryBul</sub></i> + <i>&epsilon;</i> (<i>T<sub>Ext</sub></i> &minus;
<i>T<sub>DryBul</sub></i>) + <i>&Delta;T<sub>Fan</sub></i>, &nbsp;
<i>P<sub>Fan</sub></i> = <i>y</i> (<i>P<sub>Sup</sub></i> + <i>P<sub>Ret</sub></i>), &nbsp;
d<i>E<sub>Fan</sub></i>/d<i>t</i> = <i>P<sub>Fan</sub></i>/3.6&middot;10<sup>6</sup> (kWh),
</p>
<p>
with the fan powers at nominal flow <i>P<sub>Sup</sub></i> = <i>&Delta;p<sub>Sup</sub></i>
<i>&#7745;<sub>nominal</sub></i>/(<i>&rho;<sub>Air</sub></i> <i>&eta;<sub>Fan</sub></i>), likewise
<i>P<sub>Ret</sub></i>, and the heating of the supply air by the fans (supply fan after the exchanger, return fan
before it) <i>&Delta;T<sub>Fan</sub></i> = (<i>P<sub>Sup</sub></i> + <i>&epsilon;</i> <i>P<sub>Ret</sub></i>) /
(<i>&#7745;<sub>nominal</sub></i> <i>c<sub>p</sub></i>). The power of constant-pressure fans and the flow are both
proportional to <i>y</i>, so <i>&Delta;T<sub>Fan</sub></i> is the same at every speed.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of HeatRecoveryUnit\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>m_flow_nominal</code></td><td>&nbsp;</td><td>nominal supply flow</td></tr>
<tr><td><code>eps</code></td><td>0.8</td><td>heat recovery effectiveness</td></tr>
<tr><td><code>dpSup_nominal</code>, <code>dpRet_nominal</code></td><td>200 Pa</td>
<td>pressure rises of the supply and return fans</td></tr>
<tr><td><code>etaFan</code></td><td>0.5</td><td>overall efficiency of the fans</td></tr>
<tr><td><code>m_flow_small</code></td><td>10<sup>&minus;6</sup> kg/s</td>
<td>regularisation of the mixed extract temperature</td></tr>
<tr><td><code>nPorts_a</code>, <code>nPorts_b</code></td><td>1</td>
<td>numbers of extract and supply connections</td></tr>
</table>
<h4>Use</h4>
<p>
Connect the weather to <code>weaBus</code>, the supply <code>port_b</code> through a
<a href=\"modelica://FastSmoothBuildings.Ventilation.Duct\">Duct</a> to a
<a href=\"modelica://FastSmoothBuildings.Zones.VentilatedZone\">Zones.VentilatedZone</a> and its extract back through
another duct to <code>port_a</code>, as in
<a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">Examples.VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Ventilation</code>.</li>
</ul>
</html>"));
end HeatRecoveryUnit;
