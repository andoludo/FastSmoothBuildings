within FastSmoothBuildings.Ventilation;
connector AirOutlet "Air port, outlet: the temperature of the air crossing it and the speed of its fan"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the air crossing the port";
  Interfaces.RealOutput y(unit="1") "Relative speed of the fan moving the air";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,127,255}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end AirOutlet;
