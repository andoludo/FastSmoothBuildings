within FastSmoothBuildings.Interfaces;
connector GainOutputs "Internal gains per floor area (source side)"
  RealOutput QCon(unit="W/m2") "Convective internal gains per floor area";
  RealOutput QRad(unit="W/m2") "Radiant internal gains per floor area";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}})}));
end GainOutputs;
