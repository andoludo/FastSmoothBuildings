within FastSmoothBuildings.Interfaces;
connector HeatPort "Thermal port: temperature and heat flow rate into the component"
  Real T(unit="K") "Port temperature";
  flow Real Q_flow(unit="W") "Heat flow rate into the component";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid)}));
end HeatPort;
