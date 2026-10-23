within FastSmoothBuildings.Interfaces;
connector WaterInlet "Water inlet: mass flow rate into the component, temperature of the water crossing it"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the water crossing the port (set by the component the water leaves)";
  RealOutput p(unit="Pa") "Pressure of the inlet node of the component (0 with set flows)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid)}));
end WaterInlet;
