within FastSmoothBuildings.Hydronics;
model Pipe "Pass-through (junctions, sensors, pumps without a power model)"
  extends PartialLink;
equation
  TOut = TIn;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,40},{100,-40}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={192,192,192}),
      Rectangle(extent={{-100,22},{100,-24}}, lineColor={0,0,0}, fillPattern=FillPattern.HorizontalCylinder,
        fillColor={0,127,255}),
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A pass-through: the water leaves at the mixed inlet temperature, <code>TOut</code> = <code>TIn</code>, without
storage or heat loss. It stands for the components that change neither the temperature nor, in Buildings, the
pressure: junctions, sensors, pumps without a power model.
</p>
<h4>Set flows and pressure-driven flows</h4>
<p>
With set flows, what enters leaves. With pressure-driven flows, each outlet has the small linear resistance of
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialLink\">PartialLink</a>: <code>dpLink</code> at the
nominal flow.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end Pipe;
