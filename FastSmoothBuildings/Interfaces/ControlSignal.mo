within FastSmoothBuildings.Interfaces;
connector ControlSignal "Control signal of a component (receiving side)"
  RealInput y(unit="1") "Control signal, 0 to 1";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
        points={{-100,100},{100,0},{-100,-100}})}));
end ControlSignal;
