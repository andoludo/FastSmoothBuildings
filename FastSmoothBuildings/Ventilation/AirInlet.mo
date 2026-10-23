within FastSmoothBuildings.Ventilation;
connector AirInlet "Air port, inlet: the temperature of the air crossing it and the speed of its fan"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the air crossing the port";
  Interfaces.RealInput y(unit="1") "Relative speed of the fan moving the air";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Air port at the inlet of a component of the ventilation. It carries the mass flow rate into the component, the
temperature of the air crossing it and the relative speed <code>y</code> of the fan that moves the air.
</p>
<h4>Use</h4>
<p>
Connect it to an <a href=\"modelica://FastSmoothBuildings.Ventilation.AirOutlet\">AirOutlet</a> upstream: the outlet
sets the temperature and the speed (<code>y</code> is an input here, an output there), and the component that reads
the speed sets the flow, as <a href=\"modelica://FastSmoothBuildings.Ventilation.Duct\">Duct</a> does. The convention
is that of <a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Ventilation</code>.</li>
</ul>
</html>"));
end AirInlet;
