within FastSmoothBuildings.Envelope;
model InternalWall "Wall or floor between two zones: side a faces the zone of propsBus_a, side b the other"
  extends PartialOpaque;
  parameter Real epsLw = 0.84 "Long-wave emissivity of both faces (Buildings surBou)";
  parameter Real absSol = 0.84 "Solar absorptance of both faces (Buildings surBou)";
  Interfaces.SurfaceBus propsBus_b "Connection to the zone of side b"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Real T[nLay + 1](each unit="K", each start=T_start, each fixed=true)
    "Temperatures of the layer boundaries, side a first";
  Real QInt_a(unit="W") "Heat from side a to the air of its zone";
  Real QInt_b(unit="W") "Heat from side b to the air of its zone";
protected
  parameter Real cPos_b = Utilities.convectionCoefficient(pi - til, true) "Side b faces the other way";
  parameter Real cNeg_b = Utilities.convectionCoefficient(pi - til, false);
  parameter Real isFloor_b = if abs(sin(til)) < 1e-6 and cos(til) > 0 then 1 else 0;
equation
  QInt_a = Functions.interiorConvection(T[1] - propsBus_a.con.T, A, cIntPos, cIntNeg, propsBus_a.hConInt);
  QInt_b = Functions.interiorConvection(T[nLay + 1] - propsBus_b.con.T, A, cPos_b, cNeg_b, propsBus_b.hConInt);
  Q_a = propsBus_a.rad.Q_flow - QInt_a;
  Q_b = propsBus_b.rad.Q_flow - QInt_b;
  for b in 1:nLay + 1 loop
    TNod[constructionType.nod[b]] = T[b];
    C[constructionType.nod[b]]*der(T[b]) = QNod[constructionType.nod[b]];
  end for;
  propsBus_a.con.Q_flow = -QInt_a;
  propsBus_a.rad.T = T[1];
  propsBus_a.A = A;
  propsBus_a.epsLw = epsLw;
  propsBus_a.absSol = absSol;
  propsBus_a.tauSol = 0;
  propsBus_a.isFloor = isFloor;
  propsBus_a.QTraDir = 0;
  propsBus_a.QTraDif = 0;
  propsBus_b.con.Q_flow = -QInt_b;
  propsBus_b.rad.T = T[nLay + 1];
  propsBus_b.A = A;
  propsBus_b.epsLw = epsLw;
  propsBus_b.absSol = absSol;
  propsBus_b.tauSol = 0;
  propsBus_b.isFloor = isFloor_b;
  propsBus_b.QTraDir = 0;
  propsBus_b.QTraDif = 0;
end InternalWall;
