within FastSmoothBuildings.Hydronics;
model HeatPump
  "Air-to-water heat pump (Buildings ModularReversible AirToWaterTableData2D, Vitocal 251-A08 scaled to its
   capacity) charging a mixed buffer; with set flows, the reference of its circuit (no mass balance)"
  extends PartialFlow(final GHyd=GLink);
  parameter Real m_flow_nominal(unit="kg/s") = Q_flow_nominal/cpWat/5 "Nominal flow of the heating circuit";
  parameter Real dpLink(unit="Pa") = 100
    "Pressure drop at the nominal flow (pressure-driven flows; the heating side of Buildings has none)";
  final parameter Real GLink(unit="kg/(s.Pa)") = m_flow_nominal/dpLink;
  parameter Real Q_flow_nominal(unit="W") "Heating capacity at the design outdoor and supply temperatures"
    annotation (Evaluate=true);
  parameter Real TSet(unit="K") = 318.15 "Supply temperature at design conditions"
    annotation (Evaluate=true);
  parameter Real TOutDes(unit="K") = 265.15 "Design outdoor temperature"
    annotation (Evaluate=true);
  parameter Boolean useStorageTank = false "Buffer tank; a hydraulic separator otherwise";
  parameter Real VTan(unit="m3") = 0.1 "Volume of the buffer tank";
  parameter Real hTan(unit="m") = 0.8 "Height of the buffer tank";
  parameter Real dIns(unit="m") = 0.1 "Insulation thickness of the buffer tank";
  parameter Real kIns(unit="W/(m.K)") = 0.04 "Insulation conductivity";
  parameter Real TAmb(unit="K") = 288.15 "Temperature around the buffer";
  parameter Real tauCon(unit="s") = 30 "Time constant of the condenser";
  parameter Real dTSou(unit="K") = 1 "Smoothing of the table interpolation in the source temperature";
  parameter Real scaFac = Q_flow_nominal/HeatPumps.Vitocal251A08.interpolate(TSet, TOutDes, true)
    "Scaling of the table data to the capacity";
  parameter Real mCon_flow(unit="kg/s") = HeatPumps.Vitocal251A08.mCon_flow_nominal*scaFac "Condenser flow";
  parameter Real dTCon(unit="K") = Q_flow_nominal/cpWat/mCon_flow "Condenser outlet above the buffer at full speed";
  parameter Real VWat(unit="m3") = if useStorageTank then VTan else 1.5e-5*Q_flow_nominal "Water volume";
  parameter Real UATan(unit="W/K") = kIns/dIns*(2*pi*sqrt(VTan/(pi*hTan))*hTan + 2*pi*VTan/(pi*hTan))
    "Heat loss conductance of the buffer tank (its own parameter: rumoca after commit 33c2114, 0.10.3 on PyPI, cannot
     export it inside the if-expression of UA)";
  parameter Real UA(unit="W/K") = if useStorageTank then UATan else 0 "Heat loss conductance of the buffer";
  parameter Real C(unit="J/K") = (rhoWat*VWat + mCon_flow*tauCon)*cpWat "Heat capacity of the buffer and condenser";
  parameter Real T_start(unit="K") = TSet "Initial buffer temperature";
  Interfaces.RealInput y(unit="1") "Compressor speed, 0 to 1"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Interfaces.WeatherBusIn weaBus "Weather: the source is the outdoor air"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Real T(unit="K", start=T_start, fixed=true) "Buffer temperature";
  Real EEle(unit="kWh", start=0, fixed=true) "Electricity meter";
  Real QCon(unit="W") "Heat to the water";
  Real PEle(unit="W") "Electrical power of the compressor";
  Real COP(unit="1") "Coefficient of performance QCon/PEle at the current condenser and source temperatures";
  Real TConOut(unit="K") "Condenser outlet temperature";
equation
  TConOut = T + dTCon*y;
  QCon = y*scaFac*HeatPumps.Vitocal251A08.smoothTable(TConOut, weaBus.TDryBul, true, dTSou);
  PEle = y*scaFac*HeatPumps.Vitocal251A08.smoothTable(TConOut, weaBus.TDryBul, false, dTSou);
  // QCon and PEle both scale with y: their ratio is defined at every speed, also when the compressor is off
  COP = HeatPumps.Vitocal251A08.smoothTable(TConOut, weaBus.TDryBul, true, dTSou)
    /HeatPumps.Vitocal251A08.smoothTable(TConOut, weaBus.TDryBul, false, dTSou);
  C*der(T) = mTra*cpWat*(TIn - T) + QCon + UA*(TAmb - T);
  der(EEle) = PEle/3.6e6;
  TOut = T;
  if pressureDriven then
    for i in 1:nPorts_b loop
      port_b[i].m_flow = -GLink/nPorts_b*(pIn - port_b[i].p);
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-102,100},{100,-100}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-16,60},{16,-60}}, fillColor={170,213,255}, fillPattern=FillPattern.Solid,
        lineColor={0,0,0}, origin={0,-64}, rotation=90),
      Rectangle(extent={{-16,60},{16,-60}}, fillColor={238,46,47}, fillPattern=FillPattern.Solid,
        lineColor={0,0,0}, origin={0,60}, rotation=90),
      Line(points={{-9,40},{9,40},{-5,-2},{9,-40},{-9,-40}}, color={0,0,0}, origin={-3,-60}, rotation=-90),
      Line(points={{9,40},{-9,40},{5,-2},{-9,-40},{9,-40}}, color={0,0,0}, origin={-5,56}, rotation=-90),
      Rectangle(extent={{-60,42},{60,-46}}, fillColor={0,0,0}, fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Line(points={{-42,72},{34,72}}, color={0,0,0}, arrow={Arrow.None,Arrow.Filled}, thickness=0.5),
      Line(points={{-38,0},{38,0}}, color={0,0,0}, arrow={Arrow.None,Arrow.Filled}, thickness=0.5,
        origin={0,-74}, rotation=180),
      Text(extent={{-96,28},{-74,10}}, textColor={0,0,127}, textString="y"),
      Rectangle(extent={{34,42},{38,-46}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{14,22},{58,-20}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{36,22},{18,-10},{54,-10},{36,22}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-46,42},{-42,-46}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-44,2},{-54,-10},{-34,-10},{-44,2}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-44,2},{-54,12},{-34,12},{-44,2}}, lineColor={0,0,0}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Air-to-water heat pump at the compressor speed <code>y</code>, its performance from the table of the Viessmann
Vitocal 251-A08
(<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08\">HeatPumps.Vitocal251A08</a>)
scaled to <code>Q_flow_nominal</code>. It charges a mixed buffer at the temperature <code>T</code>, a storage tank
or a hydraulic separator, from which the heating circuit draws at <code>T</code>. The source is the outdoor air of
the weather bus.
</p>
<h4>Equations</h4>
<p>
With <i>Q<sub>tab</sub></i> and <i>P<sub>tab</sub></i> the heating capacity and electrical power of the table, as
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08.smoothTable\">smoothTable</a> gives
them at the condenser outlet temperature and the outdoor dry-bulb temperature <i>T<sub>sou</sub></i>:
</p>
<p>
<i>T<sub>con,out</sub></i> = <i>T</i> + <code>dTCon</code> <i>y</i>,
</p>
<p>
<i>Q<sub>con</sub></i> = <i>y</i> <i>s</i> <i>Q<sub>tab</sub></i>(<i>T<sub>con,out</sub></i>,
<i>T<sub>sou</sub></i>), &nbsp; <i>P<sub>ele</sub></i> = <i>y</i> <i>s</i>
<i>P<sub>tab</sub></i>(<i>T<sub>con,out</sub></i>, <i>T<sub>sou</sub></i>), &nbsp;
<code>COP</code> = <i>Q<sub>tab</sub></i>/<i>P<sub>tab</sub></i>,
</p>
<p>
<i>C</i> d<i>T</i>/d<i>t</i> = <code>mTra</code> <i>c<sub>p</sub></i> (<code>TIn</code> &minus; <i>T</i>) +
<i>Q<sub>con</sub></i> + <code>UA</code> (<code>TAmb</code> &minus; <i>T</i>).
</p>
<p>
Both <i>Q<sub>con</sub></i> and <i>P<sub>ele</sub></i> scale with <i>y</i>, so the <code>COP</code> is defined at
every speed, also with the compressor off. The electricity meter <code>EEle</code> integrates
<i>P<sub>ele</sub></i> in kWh.
</p>
<h4>Parameters</h4>
<ul>
<li><code>scaFac</code> (<i>s</i>): <code>Q_flow_nominal</code> over the capacity of the table at the supply
temperature <code>TSet</code> and the outdoor temperature <code>TOutDes</code>, by the linear interpolation of
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08.interpolate\">interpolate</a>.</li>
<li><code>mCon_flow</code>: the condenser flow of the record scaled by <code>scaFac</code>;
<code>dTCon</code> = <code>Q_flow_nominal</code>/(<i>c<sub>p</sub></i> <code>mCon_flow</code>), the rise of the
condenser outlet above the buffer at full speed.</li>
<li><code>useStorageTank</code>: with a tank, the water volume is <code>VTan</code> and the heat loss conductance
that of a cylinder of volume <code>VTan</code> and height <code>hTan</code> (side and both ends) insulated by
<code>dIns</code> of conductivity <code>kIns</code>; without, a hydraulic separator without loss, of
1.5&middot;10<sup>&minus;5</sup> m<sup>3</sup> per W of <code>Q_flow_nominal</code>.</li>
<li><code>C</code>: heat capacity of the buffer water and of the water in the condenser, taken as
<code>mCon_flow</code> <code>tauCon</code>.</li>
<li><code>dTSou</code>: width over which the kinks of the table in the source temperature are smoothed.</li>
</ul>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, the heat pump is the reference of its circuit: it has no mass balance, the circuit closes it. With
pressure-driven flows, its outlets have the small linear conductance <code>m_flow_nominal</code>/<code>dpLink</code>,
shared evenly by the outlet connections; the heating side of Buildings has no resistance.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.HeatPumps.ModularReversible.AirToWaterTableData2D</code> with the Vitocal 251-A08 data,
scaled to its capacity.
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>: a buffer and two
radiators in closed loop.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end HeatPump;
