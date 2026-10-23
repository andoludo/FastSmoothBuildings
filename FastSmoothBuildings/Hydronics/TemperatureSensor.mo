within FastSmoothBuildings.Hydronics;
model TemperatureSensor "Pass-through: T is the water temperature"
  extends PartialLink;
  Interfaces.RealOutput T(unit="K") "Measured temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90, origin={0,110})));
equation
  TOut = TIn;
  T = TIn;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-100,0},{92,0}}, color={0,128,255}),
      Ellipse(extent={{-20,-58},{20,-20}}, lineColor={0,0,0}, lineThickness=0.5, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Line(points={{-40,60},{-12,60}}),
      Line(points={{-40,30},{-12,30}}),
      Line(points={{-40,0},{-12,0}}),
      Rectangle(extent={{-12,60},{12,-24}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},{12,60},{-12,60}},
        lineColor={0,0,0}, lineThickness=0.5),
      Text(extent={{102,140},{-18,90}}, textColor={0,0,0}, textString="T"),
      Line(points={{-12,60},{-12,-25}}, thickness=0.5),
      Line(points={{12,60},{12,-24}}, thickness=0.5),
      Line(points={{0,100},{0,50}}, color={0,0,127}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A pass-through that measures the water temperature: <code>T</code> = <code>TOut</code> = <code>TIn</code>, the
mixed inlet temperature, without delay.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, what enters leaves. With pressure-driven flows, each outlet has the small linear resistance of
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialLink\">PartialLink</a>: <code>dpLink</code> at the
nominal flow <code>m_flow_nominal</code>, which should be the flow of the branch the sensor sits in.
</p>
<h4>Use</h4>
<p>
The supply temperature of a circuit, read by the controller of a
<a href=\"modelica://FastSmoothBuildings.Hydronics.ThreeWayValve\">ThreeWayValve</a>, as in
<a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end TemperatureSensor;
