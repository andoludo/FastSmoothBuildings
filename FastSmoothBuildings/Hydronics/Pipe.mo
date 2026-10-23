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
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end Pipe;
