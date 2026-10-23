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
end Interfaces;
