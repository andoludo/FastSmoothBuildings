within FastSmoothBuildings.Envelope;
model OuterWall "Exterior wall or roof: wind and sky at the outside, sun, conduction, room exchanges"
  extends PartialOpaque;
  Real T[nLay + 1](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, outside first";
  BoundaryConditions.TiltedSurface sol(final azi=azi, final til=til) "Irradiance on the outer surface"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  Real QSol(unit="W") "Absorbed solar radiation";
  Real QExt(unit="W") "Heat from the outer surface to the outside air and the sky";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
protected
  parameter Real cExtPos = Utilities.convectionCoefficient(pi - til, true) "Outer face: tilt pi - til";
  parameter Real cExtNeg = Utilities.convectionCoefficient(pi - til, false);
equation
  connect(propsBus_a.wea, sol.weaBus);
  QSol = constructionType.absSol_a*A*(sol.HDir + sol.HDif);
  QExt = Functions.exteriorExchange(T[1], A, til, azi, cExtPos, cExtNeg, constructionType.absIR_a, propsBus_a.hConExt,
    propsBus_a.wea.TDryBul, propsBus_a.wea.TBlaSky, propsBus_a.wea.winSpe, propsBus_a.wea.winDir);
  QInt = Functions.interiorConvection(T[nLay + 1] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_a = QSol - QExt;
  Q_b = propsBus_a.rad.Q_flow - QInt;
  for b in 1:nLay + 1 loop
    TNod[constructionType.nod[b]] = T[b];
    C[constructionType.nod[b]]*der(T[b]) = QNod[constructionType.nod[b]];
  end for;
  propsBus_a.con.Q_flow = -QInt;
  propsBus_a.rad.T = T[nLay + 1];
  propsBus_a.A = A;
  propsBus_a.epsLw = constructionType.absIR_b;
  propsBus_a.absSol = constructionType.absSol_b;
  propsBus_a.tauSol = 0;
  propsBus_a.isFloor = isFloor;
  propsBus_a.QTraDir = 0;
  propsBus_a.QTraDif = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{-68,68}}, lineColor={255,255,0}, fillColor={255,213,170},
        fillPattern=FillPattern.Sphere)}));
end OuterWall;
