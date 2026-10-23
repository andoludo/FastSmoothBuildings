within FastSmoothBuildings.Zones;
model InternalGains "Internal gains of a zone per floor area, from two signals"
  Interfaces.RealInput QCon(unit="W/m2") "Convective internal gains per floor area"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Interfaces.RealInput QRad(unit="W/m2") "Radiant internal gains per floor area"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Interfaces.GainOutputs gai "Internal gains per floor area"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  gai.QCon = QCon;
  gai.QRad = QRad;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-150,140},{150,100}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Internal gains of a zone from two signals: the convective and the radiant gains per floor area, passed to the
gains connector <code>gai</code>.
</p>
<h4>Equations</h4>
<p>
<code>gai.QCon</code> = <code>QCon</code>, &nbsp; <code>gai.QRad</code> = <code>QRad</code>, in W/m<sup>2</sup>.
</p>
<h4>Use</h4>
<p>
Connect <code>gai</code> to <code>qGai_flow</code> of a zone, which multiplies the gains by its floor area: the
convective part heats the air, the radiant part reaches the surfaces through the radiant star. See
<a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Zones</code>.</li>
</ul>
</html>"));
end InternalGains;
