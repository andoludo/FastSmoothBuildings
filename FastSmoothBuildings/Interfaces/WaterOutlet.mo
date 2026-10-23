within FastSmoothBuildings.Interfaces;
connector WaterOutlet "Water outlet: mass flow rate into the component, temperature of the water crossing it"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component (negative when water leaves)";
  Real T(unit="K") "Temperature of the water crossing the port (set by the component)";
  RealInput p(unit="Pa") "Pressure of the inlet node of the component downstream";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,127,255}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Outlet of a water component of <a href=\"modelica://FastSmoothBuildings.Hydronics\">Hydronics</a>.
</p>
<table summary=\"Variables of WaterOutlet\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Variable</th><th>Unit</th><th>Kind</th><th>Meaning</th></tr>
<tr><td><code>m_flow</code></td><td>kg/s</td><td>flow</td><td>Mass flow rate into the component, negative when the
water leaves it</td></tr>
<tr><td><code>T</code></td><td>K</td><td>potential</td><td>Temperature of the water crossing the port, set by the
component (its outlet temperature)</td></tr>
<tr><td><code>p</code></td><td>Pa</td><td>input</td><td>Pressure of the inlet node of the component
downstream</td></tr>
</table>
<h4>Use</h4>
<p>
Connect it to the <a href=\"modelica://FastSmoothBuildings.Interfaces.WaterInlet\">WaterInlet</a> of the downstream
component. With pressure-driven flows the component computes the flow of the outlet from the pressure of its own
inlet node and <code>p</code>; with set flows <code>p</code> = 0 (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end WaterOutlet;
