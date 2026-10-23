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
      Text(extent={{-150,-110},{150,-150}}, textColor={0,0,255}, textString="%name")}));
end TemperatureSensor;
