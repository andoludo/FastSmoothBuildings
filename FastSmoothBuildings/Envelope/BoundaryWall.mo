within FastSmoothBuildings.Envelope;
model BoundaryWall "Floor on ground or over outdoor air: the outer surface is held at a temperature"
  extends PartialOpaque(final stateAtSurface_a=false);
  parameter Boolean outdoorAir = false "true: the outer surface at the outdoor air temperature";
  parameter Real TGro(unit="K") = 283.15 "Ground temperature";
  Real T[nLay](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, the outer surface excluded";
  Real QInt(unit="W") "Heat from the inner surface to the room air";
equation
  TNod[1] = if outdoorAir then propsBus_a.wea.TDryBul else TGro;
  // the outer surface is held at its temperature: its balance is not solved
  Q_a = 0;
  QInt = Functions.interiorConvection(T[nLay] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  Q_b = propsBus_a.rad.Q_flow - QInt;
  for b in 2:nLay + 1 loop
    TNod[constructionType.nod[b]] = T[b - 1];
    C[constructionType.nod[b]]*der(T[b - 1]) = QNod[constructionType.nod[b]];
  end for;
  propsBus_a.con.Q_flow = -QInt;
  propsBus_a.rad.T = T[nLay];
  propsBus_a.A = A;
  propsBus_a.epsLw = constructionType.absIR_b;
  propsBus_a.absSol = constructionType.absSol_b;
  propsBus_a.tauSol = 0;
  propsBus_a.isFloor = isFloor;
  propsBus_a.QTraDir = 0;
  propsBus_a.QTraDif = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-80},{-80,-100}}, lineColor={127,0,0}, fillColor={127,0,0},
        fillPattern=FillPattern.Backward)}));
end BoundaryWall;
