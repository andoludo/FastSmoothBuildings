within FastSmoothBuildings.Controls;
model EmissionOnOff "Variant onoff: on below the set point minus half the band, off above it plus half the band"
  extends PartialEmissionControl;
  parameter Real bandwidth(unit="K") = 0.1 "Band of the on/off controller (Modelica OnOffController)";
  Hysteresis onOff(uLow=-bandwidth/2, uHigh=bandwidth/2, u=TSet - TZon);
equation
  y = onOff.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="on/off")}));
end EmissionOnOff;
