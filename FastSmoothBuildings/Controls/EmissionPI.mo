within FastSmoothBuildings.Controls;
model EmissionPI "Variant default: PI heating loop of Buildings G36 ControlLoops (k = 0.1, Ti = 900 s)"
  extends PartialEmissionControl;
  parameter Real kHea = 0.1 "Gain of the heating loop";
  parameter Real TiHea(unit="s") = 900 "Integral time of the heating loop";
  PI conHea(k=kHea, Ti=TiHea, dY=dY, e=TSet - TZon, enable=1);
equation
  y = conHea.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="PI")}));
end EmissionPI;
