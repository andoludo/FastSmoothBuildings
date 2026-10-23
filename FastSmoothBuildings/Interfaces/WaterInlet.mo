within FastSmoothBuildings.Interfaces;
connector WaterInlet "Water inlet: mass flow rate into the component, temperature of the water crossing it"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the water crossing the port (set by the component the water leaves)";
  RealOutput p(unit="Pa") "Pressure of the inlet node of the component (0 with set flows)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Inlet of a water component of <a href=\"modelica://FastSmoothBuildings.Hydronics\">Hydronics</a>.
</p>
<table summary=\"Variables of WaterInlet\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Variable</th><th>Unit</th><th>Kind</th><th>Meaning</th></tr>
<tr><td><code>m_flow</code></td><td>kg/s</td><td>flow</td><td>Mass flow rate into the component</td></tr>
<tr><td><code>T</code></td><td>K</td><td>potential</td><td>Temperature of the water crossing the port, set by the
component the water leaves (at its outlet)</td></tr>
<tr><td><code>p</code></td><td>Pa</td><td>output</td><td>Pressure of the inlet node of the component, 0 with set
flows</td></tr>
</table>
<p>
The temperature is not a stream variable: a connection equates it with the outlet temperature of the upstream
component.
</p>
<h4>Use</h4>
<p>
Connect it to the <a href=\"modelica://FastSmoothBuildings.Interfaces.WaterOutlet\">WaterOutlet</a> of the upstream
component, which reads <code>p</code> as the pressure downstream. The components of Hydronics have arrays of
ports, one element per connection. With <code>pressureDriven = true</code> the inlet node of the component has a
pressure state; with <code>pressureDriven = false</code> (set flows) <code>p</code> = 0 (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end WaterInlet;
