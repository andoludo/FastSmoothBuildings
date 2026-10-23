within FastSmoothBuildings.Controls;
model EmissionP "Variant PController: P controller (IDEAS LimPID) between 0 and 1"
  extends PartialEmissionControl(k=5);
equation
  y = Utilities.smoothLimit(k*(TSet - TZon), 0, 1, dY);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="P")}));
end EmissionP;
