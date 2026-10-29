within FastSmoothBuildings.Controls;
model HeatPumpControl
  "Control of trano's air-to-water heat pump (Buildings model): heating curve, heating season, buffer charged
   between TSupSet - dTHys/2 and TSupSet + dTHys/2, compressor PI on the condenser outlet towards TSupSet + dTHys
   (minimum speed yComMin); the minimum on and off times of the safety control are not modelled"
  parameter Real TSet(unit="K") = 323.15 "Supply temperature at the design outdoor temperature";
  parameter Real TSupMin(unit="K") = 303.15 "Supply temperature at the heating limit";
  parameter Real TOutDes(unit="K") = 265.15 "Design outdoor temperature";
  parameter Real TOutHeaLim(unit="K") = 289.15 "Heating limit";
  parameter Real dTHys(unit="K") = 5 "Band of the buffer charging";
  parameter Real kCom = 0.1 "Gain of the compressor controller";
  parameter Real TiCom(unit="s") = 300 "Integral time of the compressor controller";
  parameter Real yComMin = 0.3 "Minimum compressor speed";
  parameter Real tauSen(unit="s") = 30 "Time constant of the condenser outlet temperature";
  parameter Real dT(unit="K") = 0.1 "Width of the smooth limits of the heating curve";
  parameter Real dY = 1e-3*(1 - yComMin) "Width of the smooth limits of the compressor speed";
  Interfaces.RealInput demand "Demand of the circuits, 0 or 1"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Interfaces.RealInput TOut(unit="K") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,5},{-100,45}})));
  Interfaces.RealInput TBuf(unit="K") "Buffer temperature"
    annotation (Placement(transformation(extent={{-140,-45},{-100,-5}})));
  Interfaces.RealInput TConOut(unit="K") "Condenser outlet temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Interfaces.RealOutput y(unit="1") "Compressor speed"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Real TSupSet(unit="K") "Supply temperature set point (heating curve)";
  Real TCur(unit="K") "Heating curve bounded below by TSupMin";
  Real TCon(unit="K", start=TSet, fixed=true) "Measured condenser outlet temperature";
  Real heaOn "Heating on";
  Hysteresis warOut(uLow=TOutHeaLim - 1, uHigh=TOutHeaLim + 1, u=TOut) "Outside the heating season";
  Hysteresis bufCha(uLow=-dTHys/2, uHigh=dTHys/2, u=TSupSet - TBuf, y_start=1) "Charging the buffer";
  PI conCom(k=kCom, Ti=TiCom, yMin=yComMin, yMax=1, yReset=yComMin, dY=dY, e=TSupSet + dTHys - TCon,
    enable=heaOn);
equation
  // the two bounds in two equations: rumoca after commit 33c2114 (0.10.3 on PyPI) cannot export the nested calls
  TCur = Utilities.smoothMax(TSupMin, TSet + (TSupMin - TSet)*(TOut - TOutDes)/(TOutHeaLim - TOutDes), dT);
  TSupSet = Utilities.smoothMin(TSet, TCur, dT);
  tauSen*der(TCon) = TConOut - TCon;
  heaOn = demand*(1 - warOut.y)*bufCha.y;
  y = heaOn*conCom.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="heat pump"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Control of trano's air-to-water heat pump (Buildings model): a heating curve, a heating season, the charging of the
buffer within a band and a PI controller of the compressor speed on the condenser outlet. The minimum on and off
times of the safety control are not modelled.
</p>
<h4>Equations</h4>
<p>
Heating curve, linear in the outdoor temperature between the design point and the heating limit, bounded by
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a> of width <code>dT</code>:
</p>
<p>
<i>T<sub>SupSet</sub></i> = smoothMin(<i>T<sub>Set</sub></i>, smoothMax(<i>T<sub>SupMin</sub></i>,
<i>T<sub>Set</sub></i> + (<i>T<sub>SupMin</sub></i> &minus; <i>T<sub>Set</sub></i>) (<i>T<sub>Out</sub></i>
&minus; <i>T<sub>OutDes</sub></i>)/(<i>T<sub>OutHeaLim</sub></i> &minus; <i>T<sub>OutDes</sub></i>), <i>dT</i>),
<i>dT</i>).
</p>
<p>
Two <a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a> states and the filtered
measurement:
</p>
<ul>
<li><code>warOut</code>: 1 (outside the heating season) when <i>T<sub>Out</sub></i> rises above
<i>T<sub>OutHeaLim</sub></i> + 1 K, 0 when it falls below <i>T<sub>OutHeaLim</sub></i> &minus; 1 K;</li>
<li><code>bufCha</code>: charging the buffer, from <i>T<sub>Buf</sub></i> &lt; <i>T<sub>SupSet</sub></i> &minus;
<i>dT<sub>Hys</sub></i>/2 until <i>T<sub>Buf</sub></i> &gt; <i>T<sub>SupSet</sub></i> +
<i>dT<sub>Hys</sub></i>/2, charging at the start (<code>y_start</code> = 1);</li>
<li><i>&tau;<sub>Sen</sub></i> d<i>T<sub>Con</sub></i>/d<i>t</i> = <i>T<sub>ConOut</sub></i> &minus;
<i>T<sub>Con</sub></i>, <i>T<sub>Con</sub></i>(0) = <i>T<sub>Set</sub></i>.</li>
</ul>
<p>
Compressor:
</p>
<p>
<i>heaOn</i> = <i>demand</i> (1 &minus; <code>warOut.y</code>) <code>bufCha.y</code>, &nbsp;
<i>y</i> = <i>heaOn</i> <code>conCom.y</code>,
</p>
<p>
<code>conCom</code> a <a href=\"modelica://FastSmoothBuildings.Controls.PI\">PI</a> controller of the error
<i>T<sub>SupSet</sub></i> + <i>dT<sub>Hys</sub></i> &minus; <i>T<sub>Con</sub></i> between
<code>yComMin</code> and 1, enabled by <i>heaOn</i> and relaxed to <code>yComMin</code> while disabled. The
compressor stops through the product with <i>heaOn</i>, whose factors are bistable states that switch within their
time constants: the control has no event.
</p>
<h4>Parameters</h4>
<table summary=\"Parameters of HeatPumpControl\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Name</th><th>Default</th><th>Meaning</th></tr>
<tr><td><code>TSet</code></td><td>323.15 K</td><td>supply temperature at the design outdoor temperature</td></tr>
<tr><td><code>TSupMin</code></td><td>303.15 K</td><td>supply temperature at the heating limit</td></tr>
<tr><td><code>TOutDes</code></td><td>265.15 K</td><td>design outdoor temperature</td></tr>
<tr><td><code>TOutHeaLim</code></td><td>289.15 K</td><td>heating limit</td></tr>
<tr><td><code>dTHys</code></td><td>5 K</td><td>band of the buffer charging</td></tr>
<tr><td><code>kCom</code>, <code>TiCom</code></td><td>0.1, 300 s</td>
<td>gain and integral time of the compressor controller</td></tr>
<tr><td><code>yComMin</code></td><td>0.3</td><td>minimum compressor speed</td></tr>
<tr><td><code>tauSen</code></td><td>30 s</td><td>time constant of the condenser outlet temperature</td></tr>
<tr><td><code>dT</code></td><td>0.1 K</td><td>width of the smooth limits of the heating curve</td></tr>
<tr><td><code>dY</code></td><td>10<sup>&minus;3</sup> (1 &minus; <code>yComMin</code>)</td>
<td>half-width of the smooth limits of the compressor speed</td></tr>
</table>
<p>
The hystereses keep their defaults (<code>tau</code> = 10 s, <code>dU</code> a tenth of their band: 0.2 K for
<code>warOut</code>, <code>dTHys</code>/10 for <code>bufCha</code>), which modifiers such as
<code>bufCha.tau</code> can change. With <code>dT</code> and <code>dY</code>, they are the smoothing that a
calibration can widen.
</p>
<h4>Use</h4>
<p>
In <a href=\"modelica://FastSmoothBuildings.Examples.HeatPumpCircuit\">Examples.HeatPumpCircuit</a>, the demand from
<a href=\"modelica://FastSmoothBuildings.Controls.BoilerDemand\">BoilerDemand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Controls</code>.</li>
</ul>
</html>"));
end HeatPumpControl;
