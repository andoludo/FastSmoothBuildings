within FastSmoothBuildings.Hydronics;
model HeatMeter "Pass-through: Q_flow is the heat the water carries above the temperature TExt (Buildings HeatMeter)"
  extends PartialLink;
  Interfaces.RealInput TExt(unit="K") "Temperature of the other pipe of the circuit (the return, for a supply)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={-60,120})));
  Interfaces.RealOutput T(unit="K") "Measured temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90, origin={0,110})));
  Real Q_flow(unit="W") "Heat flow rate (a variable, as the heat of a radiator: the translation keeps it)";
equation
  TOut = TIn;
  T = TIn;
  Q_flow = m_flow*cpWat*(TIn - TExt);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-100,0},{92,0}}, color={0,128,255}),
      Ellipse(extent={{-20,-58},{20,-20}}, lineColor={0,0,0}, lineThickness=0.5, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(extent={{-12,60},{12,-24}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},{12,60},{-12,60}},
        lineColor={0,0,0}, lineThickness=0.5),
      Text(extent={{-18,140},{-98,90}}, textColor={0,0,0}, textString="TExt"),
      Line(points={{-12,60},{-12,-25}}, thickness=0.5),
      Line(points={{12,60},{12,-24}}, thickness=0.5),
      Line(points={{0,100},{0,50}}, color={0,0,127}),
      Line(points={{-60,100},{-60,0}}, color={0,0,127}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A pass-through that meters the heat the water carries: the flow through the meter times the difference between
its temperature and the temperature <code>TExt</code> of the other pipe of the circuit. On the supply of a
generator, with <code>TExt</code> the return temperature, <code>Q_flow</code> is the heat the generator delivers
to the circuit.
</p>
<h4>Equations</h4>
<p>
<code>Q_flow</code> = <code>m_flow</code> <i>c<sub>p</sub></i> (<code>TIn</code> &minus; <code>TExt</code>),
&nbsp; <code>T</code> = <code>TOut</code> = <code>TIn</code>,
</p>
<p>
with <code>m_flow</code> the flow entering the meter and <i>c<sub>p</sub></i> = 4184 J/(kg K). The water passes
without delay and without loss.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, what enters leaves. With pressure-driven flows, each outlet has the small linear resistance of
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialLink\">PartialLink</a>: <code>dpLink</code> at the
nominal flow <code>m_flow_nominal</code>, which should be the flow of the branch the meter sits in.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.Fluid.Sensors.HeatMeter</code>: the same equation, with the same input <code>TExt</code>, without
the dynamics of its temperature sensor. <code>Q_flow</code> is a variable of the meter, not an output connector as
in Buildings: no controller reads it, and the translation into CasADi keeps the variables of a model, not the
outputs of its components. The meter also gives its
temperature <code>T</code>, as
<a href=\"modelica://FastSmoothBuildings.Hydronics.TemperatureSensor\">TemperatureSensor</a>, so that it replaces
one.
</p>
<h4>Use</h4>
<p>
The supply of <a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">Examples.BoilerCircuit</a>,
with the temperature of the water leaving the valve of the radiator as <code>TExt</code>: the heat that measured
data of a heat meter is compared with.
</p>
</html>", revisions="<html>
<ul>
<li>November 2026: first version, for the comparison of a simulated house with its heat meter.</li>
</ul>
</html>"));
end HeatMeter;
