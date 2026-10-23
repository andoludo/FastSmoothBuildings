within FastSmoothBuildings.Ventilation;
connector AirOutlet "Air port, outlet: the temperature of the air crossing it and the speed of its fan"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the air crossing the port";
  Interfaces.RealOutput y(unit="1") "Relative speed of the fan moving the air";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,127,255}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Air port at the outlet of a component of the ventilation. It carries the mass flow rate into the component (negative
when the air leaves), the temperature of the air crossing it and the relative speed <code>y</code> of the fan that
moves the air.
</p>
<h4>Use</h4>
<p>
The component sets the temperature and the speed of its outlet (<code>y</code> is an output here); connect it to
an <a href=\"modelica://FastSmoothBuildings.Ventilation.AirInlet\">AirInlet</a> downstream. See
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Ventilation</code>.</li>
</ul>
</html>"));
end AirOutlet;
