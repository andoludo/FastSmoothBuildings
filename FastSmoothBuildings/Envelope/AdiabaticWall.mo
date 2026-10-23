within FastSmoothBuildings.Envelope;
model AdiabaticWall "Wall without heat flow through its outer surface"
  extends PartialOpaque;
  Real T[nLay + 1](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, outside first";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
equation
  QInt = Functions.interiorConvection(T[nLay + 1] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_a = 0;
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
      Line(points={{-90,80},{-90,-80}}, color={0,0,0}, thickness=1)}));
end AdiabaticWall;
