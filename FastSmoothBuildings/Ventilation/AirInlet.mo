within FastSmoothBuildings.Ventilation;
connector AirInlet "Air port, inlet: the temperature of the air crossing it and the speed of its fan"
  flow Real m_flow(unit="kg/s") "Mass flow rate into the component";
  Real T(unit="K") "Temperature of the air crossing the port";
  Interfaces.RealInput y(unit="1") "Relative speed of the fan moving the air";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Ellipse(extent={{-100,100},{100,-100}}, lineColor={0,127,255}, fillColor={0,127,255},
        fillPattern=FillPattern.Solid)}));
end AirInlet;
