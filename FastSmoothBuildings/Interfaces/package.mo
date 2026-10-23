within FastSmoothBuildings;
package Interfaces "Connectors"
  connector RealInput = input Real "Real input signal"
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
          points={{-100,100},{100,0},{-100,-100}})}));
  connector RealOutput = output Real "Real output signal"
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Polygon(lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid,
          points={{-100,100},{100,0},{-100,-100}})}));
  annotation (Documentation(info="<html>
<p>
Connectors: heat ports, water and weather connectors, the buses between zones and surfaces, the inputs of a model for optimal control (weather, gains, controls).
</p>
</html>"));
end Interfaces;
