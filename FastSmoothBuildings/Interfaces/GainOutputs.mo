within FastSmoothBuildings.Interfaces;
connector GainOutputs "Internal gains per floor area (source side)"
  RealOutput QCon(unit="W/m2") "Convective internal gains per floor area";
  RealOutput QRad(unit="W/m2") "Radiant internal gains per floor area";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Source side of the internal gains: <code>QCon</code>, convective, and <code>QRad</code>, radiant, per floor area in
W/m<sup>2</sup>. Signals, not flow variables.
</p>
<h4>Use</h4>
<p>
The output of <a href=\"modelica://FastSmoothBuildings.Zones.InternalGains\">Zones.InternalGains</a>; connect it to
the <a href=\"modelica://FastSmoothBuildings.Interfaces.Gains\">Gains</a> <code>qGai_flow</code> of a zone, which
multiplies the gains by its floor area.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end GainOutputs;
