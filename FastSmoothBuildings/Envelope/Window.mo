within FastSmoothBuildings.Envelope;
model Window "Glazing with its frame: panes, gas gaps, optics of the glazing (Buildings), sky and wind outside"
  extends PartialSurface;
  parameter Data.Glazing glazing "Glazing, panes from the outside";
  parameter Real frac = 0 "Frame share of the window area";
  parameter Real hFraExt(unit="W/(m2.K)") = 25 "Exterior film coefficient of the frame";
  parameter Real hFraInt(unit="W/(m2.K)") = 7.7 "Interior film coefficient of the frame";
  parameter Real cGla(unit="J/(kg.K)") = 720 "Specific heat capacity of glass when the glazing gives none";
  parameter Real hWin(unit="m") = sqrt(A) "Height of the window: the aspect ratio of its gas gaps";
  parameter Real wWin(unit="m") = A/hWin "Width of the window";
  parameter Boolean haveOverhang = false "true: an overhang shades the window (Buildings Overhang)"
    annotation (Evaluate=true);
  parameter Real depOve(unit="m") = 0 "Depth of the overhang";
  parameter Real gapOve(unit="m") = 0 "Distance between the top of the window and the overhang";
  parameter Real wLOve(unit="m") = 0 "Extension of the overhang beyond the left edge, seen from outside";
  parameter Real wROve(unit="m") = 0 "Extension of the overhang beyond the right edge, seen from outside";
  parameter Boolean haveSideFins = false "true: side fins shade the window (Buildings SideFins)"
    annotation (Evaluate=true);
  parameter Real depFin(unit="m") = 0 "Depth of the side fins";
  parameter Real gapFin(unit="m") = 0 "Distance between the window edges and the fins";
  parameter Real hFin(unit="m") = 0 "Extension of the fins above the top of the window";
  Real T[glazing.nPan](each unit="K", each start=T_start, each fixed=true) "Pane temperatures, outside first";
  BoundaryConditions.TiltedSurface sol(final azi=azi, final til=til) "Irradiance on the window"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  Real QExt(unit="W") "Heat from the outer pane to the outside air and the sky";
  Real QInt(unit="W") "Heat from the inner pane to the room air";
  Real QFra(unit="W") "Heat through the frame, from the room air to the outside";
  Real cosInc "Cosine of incidence, 0 when the sun is behind the window";
  Real fraSun "Fraction of the glass lit by the direct sun (1 without overhang or side fins)";
protected
  constant Real cosAng[10] = {cos(i*pi/18) for i in 0:9} "Cosine of the tabulated incidence angles";
  Real alt(unit="rad") "Solar altitude";
  Real verAzi(unit="rad") "Angle between the horizontal projection of the sun's rays and the wall normal";
  Real side "Horizontal component of the sun's direction to the left of the normal, seen from outside";
  parameter Integer nPan = glazing.nPan;
  parameter Real AGla(unit="m2") = A*(1 - frac) "Glass area";
  parameter Real CPan[nPan](each unit="J/K") = {AGla*glazing.x[i]*glazing.d[i]*(if glazing.c[i] > 0 then glazing.c[i]
    else cGla) for i in 1:nPan} "Capacity of each pane";
  parameter Real RPan[nPan](each unit="m2.K/W") = {glazing.x[i]/glazing.k[i] for i in 1:nPan}
    "Thermal resistance of each pane";
  parameter Real hGap0[nPan - 1](each unit="W/(m2.K)") = {Functions.gapConductance(
    283.15 + 7.5/max(nPan - 1, 1), 283.15 - 7.5/max(nPan - 1, 1), glazing.xGas[i], glazing.kGas[i],
    glazing.muGas_a[i], glazing.muGas_b[i], glazing.cGas[i], glazing.MGas[i], glazing.epsGap_a[i],
    glazing.epsGap_b[i], hWin) for i in 1:nPan - 1}
    "Conductance of each gap at the reference state of EN 673: mean 10 degC, 15 K across the glazing";
  parameter Real RGap0[nPan - 1](each unit="m2.K/W") = {RPan[i]/2 + 1/hGap0[i] + RPan[i + 1]/2 for i in 1:nPan - 1}
    "Resistance between the centres of two panes at the reference state";
  parameter Real GGap[nPan - 1](each unit="W/K") = {AGla/RGap0[i] for i in 1:nPan - 1}
    "Conductance between two panes at the reference state: the scale of the exchange (calibration)";
  Real hGap[nPan - 1](each unit="W/(m2.K)") "Conductance of each gap at the current temperatures of its panes";
  parameter Real tauCoe[5] = Utilities.polynomialFit(cosAng, glazing.tau[1:10])
    "Direct transmittance in cos(inc)";
  parameter Real absCoe[nPan, 5] = {Utilities.polynomialFit(cosAng, glazing.absPan[i, 1:10]) for i in 1:nPan}
    "Direct absorptance of each pane in cos(inc)";
  parameter Real GFra(unit="W/K") = A*frac/(1/hFraExt + 1/glazing.UFra + 1/hFraInt) "Frame conductance";
  parameter Real cExtPos = Utilities.convectionCoefficient(pi - til, true);
  parameter Real cExtNeg = Utilities.convectionCoefficient(pi - til, false);
  Real QAbs[nPan](each unit="W") "Absorbed solar radiation of each pane";
  Real QIn[nPan + 1](each unit="W")
    "Heat flowing inwards across each interface: outside to the outer pane, between panes, inner pane to the room";
equation
  connect(propsBus_a.wea, sol.weaBus);
  cosInc = Utilities.positivePart(sol.cosInc, 1e-2);
  // shading by an overhang and side fins (Buildings FixedShade): the direct irradiance of the lit fraction of the
  // glass, the diffuse irradiance unchanged
  alt = asin(Utilities.smoothLimitInside(propsBus_a.wea.cosZen, -1, 1, 1e-4));
  verAzi = acos(Utilities.smoothLimitInside(sol.cosInc/Utilities.smoothMax(cos(alt), 1e-3, 1e-4), -1, 1, 1e-4));
  side = cos(propsBus_a.wea.decAng)*sin(propsBus_a.wea.solHouAng)*cos(azi) + (sin(propsBus_a.wea.decAng)
    *cos(propsBus_a.wea.lat) - cos(propsBus_a.wea.decAng)*cos(propsBus_a.wea.solHouAng)*sin(propsBus_a.wea.lat))
    *sin(azi);
  fraSun = if haveOverhang and haveSideFins then Utilities.smoothMax(
      Functions.overhangSunlitFraction(verAzi, alt, side, hWin, wWin, depOve, gapOve, wLOve, wROve)
      + Functions.sideFinsSunlitFraction(verAzi, alt, hWin, wWin, depFin, gapFin, hFin) - 1, 1e-3, 5e-4)
    elseif haveOverhang then Functions.overhangSunlitFraction(verAzi, alt, side, hWin, wWin, depOve, gapOve, wLOve,
      wROve)
    elseif haveSideFins then Functions.sideFinsSunlitFraction(verAzi, alt, hWin, wWin, depFin, gapFin, hFin)
    else 1;
  for i in 1:nPan loop
    QAbs[i] = AGla*(fraSun*sol.HDir*Utilities.polynomial(absCoe[i, :], cosInc) + sol.HDif*glazing.absPan[i, 11]);
  end for;
  QExt = AGla*(4 + 4*sqrt(propsBus_a.wea.winSpe^2 + 0.01))*(T[1] - propsBus_a.wea.TDryBul)
    + Functions.skyExchange(T[1], AGla, til, glazing.absIR_a, propsBus_a.wea.TDryBul, propsBus_a.wea.TBlaSky);
  QInt = Functions.interiorConvection(T[nPan] - propsBus_a.con.T, AGla, cIntPos, cIntNeg, propsBus_a.hConInt);
  QFra = GFra*(propsBus_a.con.T - propsBus_a.wea.TDryBul);
  // one balance per pane, without a branch on the number of panes: a single pane has no gap, and the branch of
  // several panes would index GGap[1] and T[2], which OpenModelica rejects even when the branch is not taken
  QIn[1] = -QExt;
  for i in 1:nPan - 1 loop
    // the long-wave exchange across a gap grows as T^3 and its convection with the temperature difference: a
    // sun-lit glazing at 40 degC conducts a fifth more than at the reference state
    hGap[i] = Functions.gapConductance(T[i], T[i + 1], glazing.xGas[i], glazing.kGas[i], glazing.muGas_a[i],
      glazing.muGas_b[i], glazing.cGas[i], glazing.MGas[i], glazing.epsGap_a[i], glazing.epsGap_b[i], hWin);
    QIn[i + 1] = GGap[i]*RGap0[i]/(RPan[i]/2 + 1/hGap[i] + RPan[i + 1]/2)*(T[i] - T[i + 1]);
  end for;
  QIn[nPan + 1] = QInt - propsBus_a.rad.Q_flow;
  for i in 1:nPan loop
    der(T[i]) = (QAbs[i] + QIn[i] - QIn[i + 1])/CPan[i];
  end for;
  // the room air loses the heat that leaves through the frame and takes the heat of the inner pane
  propsBus_a.con.Q_flow = QFra - QInt;
  propsBus_a.rad.T = T[nPan];
  propsBus_a.A = AGla;
  propsBus_a.epsLw = glazing.absIR_b;
  propsBus_a.absSol = glazing.absPan[nPan, 11];
  propsBus_a.tauSol = glazing.tau[11];
  propsBus_a.isFloor = 0;
  propsBus_a.QTraDir = AGla*fraSun*sol.HDir*Utilities.polynomial(tauCoe, cosInc);
  propsBus_a.QTraDif = AGla*sol.HDif*glazing.tau[11];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-37,-44},{14,-44}}, color={0,0,0}),
      Polygon(points={{14,80},{14,-44},{45,-76},{45,48},{14,80}}, lineColor={0,0,0}, fillColor={215,215,215},
        fillPattern=FillPattern.Solid),
      Polygon(points={{19,69},{19,-42},{39,-62},{39,48},{19,69}}, lineColor={0,0,0}, fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Line(points={{-51,80},{24,80}}, color={0,0,0}),
      Line(points={{-6,-76},{45,-76}}, color={0,0,0}),
      Polygon(points={{-10,80},{-10,-44},{21,-76},{21,48},{-10,80}}, lineColor={0,0,0},
        fillColor={215,215,215}, fillPattern=FillPattern.Solid),
      Polygon(points={{-5,69},{-5,-42},{15,-62},{15,48},{-5,69}}, lineColor={0,0,0}, fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-37,80},{-37,-44},{-6,-76},{-6,48},{-37,80}}, lineColor={0,0,0},
        fillColor={215,215,215}, fillPattern=FillPattern.Solid),
      Polygon(points={{-32,68},{-32,-43},{-12,-63},{-12,47},{-32,68}}, lineColor={0,0,0},
        fillColor={170,213,255}, fillPattern=FillPattern.Solid),
      Line(points={{-17,48},{58,48}}, color={0,0,0}),
      Ellipse(extent={{-113,117},{-82,85}}, lineColor={255,255,0}, fillColor={255,213,170},
        fillPattern=FillPattern.Sphere),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A window of area <code>A</code>: the glazing of
<a href=\"modelica://FastSmoothBuildings.Data.Glazing\">Data.Glazing</a> on the glass area
<i>A<sub>gla</sub></i> = <i>A</i> (1 &minus; <code>frac</code>), with a temperature state per pane
(<code>T[1]</code> outside to <code>T[nPan]</code> room side), the gas gaps at the temperatures of their panes, the
angular optics of the glazing, an optional overhang and side fins, and a frame without capacity on the rest of the
area.
</p>
<h4>Equations</h4>
<p>
Balance of pane <i>i</i>, of capacity <i>C<sub>i</sub></i> = <i>A<sub>gla</sub></i> <i>x<sub>i</sub></i>
<i>d<sub>i</sub></i> <i>c<sub>i</sub></i> (<code>cGla</code> when the glazing gives no <i>c<sub>i</sub></i>):
</p>
<p>
<i>C<sub>i</sub></i> d<i>T<sub>i</sub></i>/d<i>t</i> = <i>Q<sub>abs,i</sub></i> + <i>Q<sub>in,i</sub></i>
&minus; <i>Q<sub>in,i+1</sub></i>,
</p>
<p>
where <i>Q<sub>in,i</sub></i> flows inwards across interface <i>i</i>: <i>Q<sub>in,1</sub></i> =
&minus;<i>Q<sub>ext</sub></i> from the outside, <i>Q<sub>in,nPan+1</sub></i> = <i>Q<sub>int</sub></i> &minus;
<i>Q<sub>rad</sub></i> to the room (convection to the room air
(<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.interiorConvection\">interiorConvection</a>) minus the
radiation the zone gives to the inner pane), and between panes <i>i</i> and <i>i</i> + 1
</p>
<p>
<i>Q<sub>in,i+1</sub></i> = <i>G<sub>gap,i</sub></i> <i>R<sub>gap0,i</sub></i> /
(<i>R<sub>i</sub></i>/2 + 1/<i>h<sub>gap,i</sub></i> + <i>R<sub>i+1</sub></i>/2)
(<i>T<sub>i</sub></i> &minus; <i>T<sub>i+1</sub></i>),
</p>
<p>
with <i>R<sub>i</sub></i> = <i>x<sub>i</sub></i>/<i>k<sub>i</sub></i> the resistance of a pane and
<i>h<sub>gap,i</sub></i> the conductance of the gap at the current temperatures of its panes
(<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.gapConductance\">gapConductance</a>, with the height
<code>hWin</code>). <i>R<sub>gap0,i</sub></i> is the resistance between the centres of the two panes at the
reference state of EN 673 (mean 10 &deg;C, 15 K across the glazing) and <i>G<sub>gap,i</sub></i> =
<i>A<sub>gla</sub></i>/<i>R<sub>gap0,i</sub></i>: the factor <i>G<sub>gap</sub></i> <i>R<sub>gap0</sub></i> is
<i>A<sub>gla</sub></i>, and <i>G<sub>gap</sub></i> sets the scale of the exchange for a calibration.
</p>
<p>
Outside, the outer pane exchanges with the outdoor air and with sky and ground
(<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.skyExchange\">skyExchange</a>, emissivity
<code>absIR_a</code>):
</p>
<p>
<i>Q<sub>ext</sub></i> = <i>A<sub>gla</sub></i> (4 + 4 &radic;(<i>v</i><sup>2</sup> + 0.01))
(<i>T<sub>1</sub></i> &minus; <i>T<sub>out</sub></i>) + <i>Q<sub>sky</sub></i>,
</p>
<p>
<i>v</i> the wind speed. The frame conducts <i>Q<sub>fra</sub></i> = <i>G<sub>fra</sub></i>
(<i>T<sub>air</sub></i> &minus; <i>T<sub>out</sub></i>) from the room air to the outdoor air, with
<i>G<sub>fra</sub></i> = <i>A</i> <code>frac</code> / (1/<code>hFraExt</code> + 1/<code>UFra</code> +
1/<code>hFraInt</code>).
</p>
<p>
Optics: the transmittance and the absorptance of each pane for the direct sun are quartics in
cos&nbsp;<i>&theta;</i>, fitted by least squares to the values of the glazing at 0, 10, ..., 90&deg;
(<a href=\"modelica://FastSmoothBuildings.Utilities.polynomialFit\">polynomialFit</a>); the diffuse sun takes the
hemispherical values. With <i>f<sub>sun</sub></i> the sunlit fraction of the glass and the irradiance
<i>H<sub>dir</sub></i>, <i>H<sub>dif</sub></i> of
<a href=\"modelica://FastSmoothBuildings.BoundaryConditions.TiltedSurface\">TiltedSurface</a>,
</p>
<p>
<i>Q<sub>abs,i</sub></i> = <i>A<sub>gla</sub></i> (<i>f<sub>sun</sub></i> <i>H<sub>dir</sub></i>
<i>&alpha;<sub>i</sub></i>(cos&nbsp;<i>&theta;</i>) + <i>H<sub>dif</sub></i> <i>&alpha;<sub>i,hem</sub></i>),
&nbsp; <code>QTraDir</code> = <i>A<sub>gla</sub></i> <i>f<sub>sun</sub></i> <i>H<sub>dir</sub></i>
<i>&tau;</i>(cos&nbsp;<i>&theta;</i>), &nbsp; <code>QTraDif</code> = <i>A<sub>gla</sub></i>
<i>H<sub>dif</sub></i> <i>&tau;<sub>hem</sub></i>,
</p>
<p>
cos&nbsp;<i>&theta;</i> bounded below by 0 with
<a href=\"modelica://FastSmoothBuildings.Utilities.positivePart\">positivePart</a> (width 0.01). The transmitted
sun goes to the zone through the bus, which sees the room face of the glazing with the emissivity
<code>absIR_b</code>, the hemispherical absorptance of the inner pane and the hemispherical transmittance.
</p>
<h4>Shading</h4>
<p>
From the weather bus the window computes the solar altitude <i>&beta;</i> = asin(cos&nbsp;<i>&zeta;</i>), the
angle <i>&gamma;</i> between the horizontal projection of the sun's rays and the normal,
cos&nbsp;<i>&gamma;</i> = cos&nbsp;<i>&theta;</i>/cos&nbsp;<i>&beta;</i> (the relation of a vertical window), and
the side of the sun. The sunlit fraction is
</p>
<table summary=\"Sunlit fraction of the window\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Shading</th><th><i>f<sub>sun</sub></i></th></tr>
<tr><td>none</td><td>1</td></tr>
<tr><td><code>haveOverhang</code></td>
<td><i>f<sub>ove</sub></i> from
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.overhangSunlitFraction\">overhangSunlitFraction</a>
</td></tr>
<tr><td><code>haveSideFins</code></td>
<td><i>f<sub>fin</sub></i> from
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.sideFinsSunlitFraction\">sideFinsSunlitFraction</a>
</td></tr>
<tr><td>both</td><td>smoothMax(<i>f<sub>ove</sub></i> + <i>f<sub>fin</sub></i> &minus; 1, 10<sup>&minus;3</sup>,
5&middot;10<sup>&minus;4</sup>)</td></tr>
</table>
<p>
Only the direct sun is shaded; the diffuse sun is not.
</p>
<h4>Parameters</h4>
<ul>
<li><code>frac</code>: the share of the frame in <code>A</code>; 0 by default, no frame.</li>
<li><code>hWin</code>, <code>wWin</code>: the height and width of the window, <i>&radic;A</i> by default; the height
enters the convection of the gaps (the aspect ratio of the cavity) and both enter the shading.</li>
<li><code>haveOverhang</code>, <code>haveSideFins</code>: evaluated; a window without them keeps
<i>f<sub>sun</sub></i> = 1 and none of the shading functions. The geometry (<code>depOve</code>,
<code>gapOve</code>, <code>wLOve</code>, <code>wROve</code>, <code>depFin</code>, <code>gapFin</code>,
<code>hFin</code>) is that of Buildings' <code>Overhang</code> and <code>SideFins</code>; left and right are seen
from outside.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
The glazing data and its angular optics are those of Buildings
(<code>Buildings.HeatTransfer.Data.GlazingSystems.Generic</code>), the gaps follow
<code>Buildings.HeatTransfer.Windows.BaseClasses.GasConvection</code> (see
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.gapConductance\">gapConductance</a>), the overhang and
the side fins <code>Buildings.HeatTransfer.Windows.BaseClasses.Overhang</code> and <code>SideFins</code> with
smooth minima, maxima and steps, and both combine as Buildings combines them. As in Buildings, the diffuse sun is not
shaded.
</p>
<h4>Validation</h4>
<p>
BESTEST cases 610, 630, 910 and 930 (overhangs, and overhangs with side fins): every result inside its band, within
2.2 % of Buildings.
</p>
<h4>Use</h4>
<p>
The windows of <a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">Examples.FreeFloatingRoom</a>
and <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end Window;
