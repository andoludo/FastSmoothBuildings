within FastSmoothBuildings.Interfaces;
connector Gains "Internal gains per floor area (receiving side)"
  RealInput QCon(unit="W/m2") "Convective internal gains per floor area";
  RealInput QRad(unit="W/m2") "Radiant internal gains per floor area";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}}),
      Polygon(fillColor={255,215,136}, fillPattern=FillPattern.Solid,
        points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
        smooth=Smooth.Bezier),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-65,15},{-55,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-5,15},{5,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{55,15},{65,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-35,-25},{-25,-15}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Receiving side of the internal gains of a zone (<code>qGai_flow</code>): <code>QCon</code>, convective, and
<code>QRad</code>, radiant, per floor area in W/m<sup>2</sup>. Signals, not flow variables.
</p>
<p>
The zone multiplies both by its floor area <code>AFlo</code>: <code>AFlo*QCon</code> enters the heat balance of the
air, <code>AFlo*QRad</code> the radiant star, which shares it among the surfaces in proportion to
<i>&epsilon;<sub>i</sub></i> <i>A<sub>i</sub></i> (see
<a href=\"modelica://FastSmoothBuildings.Zones.PartialZone\">Zones.PartialZone</a>).
</p>
<h4>Use</h4>
<p>
Connect it to the <a href=\"modelica://FastSmoothBuildings.Interfaces.GainOutputs\">GainOutputs</a> of a source, as
<a href=\"modelica://FastSmoothBuildings.Zones.InternalGains\">Zones.InternalGains</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end Gains;
