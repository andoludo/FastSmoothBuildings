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
    CPan[i]*der(T[i]) = QAbs[i] + QIn[i] - QIn[i + 1];
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
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end Window;
