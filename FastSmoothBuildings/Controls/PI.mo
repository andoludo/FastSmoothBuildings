within FastSmoothBuildings.Controls;
model PI
  "PI controller with limits and anti-windup (Modelica LimPID: back-calculation with Ni), its integral relaxed to
   the reset value while disabled"
  parameter Real k "Gain";
  parameter Real Ti(unit="s") "Integral time";
  parameter Real yMin = 0;
  parameter Real yMax = 1;
  parameter Real Ni = 0.9 "Anti-windup gain";
  parameter Real yReset = yMin "Output after a reset";
  parameter Real tauReset(unit="s") = 30 "Time constant of the reset while disabled";
  parameter Real dY = 1e-3*(yMax - yMin) "Width of the smooth limits";
  Interfaces.RealInput e "Control error"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput enable "1: integrate, 0: reset"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=90, origin={0,-120})));
  Real I(start=yReset/k, fixed=true) "Integral of the error";
  Real yUnl "Unlimited output";
  Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  yUnl = k*(e + I);
  y = Utilities.smoothLimit(yUnl, yMin, yMax, dY);
  der(I) = enable*(e/Ti + (y - yUnl)/(k*Ni*Ti)) + (1 - enable)*(yReset/k - e - I)/tauReset;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(points={{-80,82},{-88,60},{-72,60},{-80,82}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,68},{-80,-100}}, color={192,192,192}),
      Line(points={{-90,-80},{70,-80}}, color={192,192,192}),
      Polygon(points={{74,-80},{52,-72},{52,-88},{74,-80}}, lineColor={192,192,192}, fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,-80},{-80,-22}}, color={0,0,0}),
      Line(points={{-80,-22},{6,56}}, color={0,0,0}),
      Line(points={{6,56},{68,56}}, color={0,0,0}),
      Text(extent={{-26,-22},{74,-62}}, textColor={0,0,0}, textString="PI"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end PI;
