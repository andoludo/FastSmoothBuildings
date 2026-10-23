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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Wall or floor between two zones: the conduction of
<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a> with side <i>a</i> facing the
zone of <code>propsBus_a</code> and side <i>b</i> the zone of <code>propsBus_b</code>. The layers are given from
side <i>a</i>; all the layer boundaries <code>T[1]</code> (side <i>a</i>) to <code>T[nLay + 1]</code> (side
<i>b</i>) are states.
</p>
<h4>Equations</h4>
<p>
At each face, <i>Q</i> = <i>Q<sub>rad</sub></i> &minus; <i>Q<sub>int</sub></i>: the radiation the zone of that side
gives to the face minus the convection to its air
(<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.interiorConvection\">interiorConvection</a>).
<code>azi</code> and <code>til</code> are those of side <i>a</i>; side <i>b</i> faces the other way, its natural
convection coefficients are taken at the tilt &pi; &minus; <code>til</code>, and it is the floor of its zone when
side <i>a</i> is a ceiling (<code>til</code> = 0).
</p>
<h4>Parameters</h4>
<ul>
<li><code>epsLw</code>, <code>absSol</code>: the long-wave emissivity and the solar absorptance of both faces, 0.84
by default as Buildings' <code>surBou</code>; the emissivities and absorptances of the construction record are not
used.</li>
</ul>
<h4>Use</h4>
<p>
The partition of <a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end InternalWall;
