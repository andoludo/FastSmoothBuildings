within FastSmoothBuildings.Interfaces;
connector WaterOutlet "Water outlet: mass flow rate into the component, temperature of the water crossing it"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component (negative when water leaves)";
  Real T(unit="K") "Temperature of the water crossing the port (set by the component)";
  RealInput p(unit="Pa") "Pressure of the inlet node of the component downstream";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,127,255}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end WaterOutlet;
