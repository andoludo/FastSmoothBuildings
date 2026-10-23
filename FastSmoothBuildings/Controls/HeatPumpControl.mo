within FastSmoothBuildings.Controls;
model HeatPumpControl
  "Control of trano's air-to-water heat pump (Buildings model): heating curve, heating season, buffer charged
   between TSupSet - dTHys/2 and TSupSet + dTHys/2, compressor PI on the condenser outlet towards TSupSet + dTHys
   (minimum speed yComMin); the minimum on and off times of the safety control are not modelled"
  parameter Real TSet(unit="K") = 323.15 "Supply temperature at the design outdoor temperature";
  parameter Real TSupMin(unit="K") = 303.15 "Supply temperature at the heating limit";
  parameter Real TOutDes(unit="K") = 265.15 "Design outdoor temperature";
  parameter Real TOutHeaLim(unit="K") = 289.15 "Heating limit";
  parameter Real dTHys(unit="K") = 5 "Band of the buffer charging";
  parameter Real kCom = 0.1 "Gain of the compressor controller";
  parameter Real TiCom(unit="s") = 300 "Integral time of the compressor controller";
  parameter Real yComMin = 0.3 "Minimum compressor speed";
  parameter Real tauSen(unit="s") = 30 "Time constant of the condenser outlet temperature";
  parameter Real dT(unit="K") = 0.1 "Width of the smooth limits of the heating curve";
  parameter Real dY = 1e-3*(1 - yComMin) "Width of the smooth limits of the compressor speed";
  Interfaces.RealInput demand "Demand of the circuits, 0 or 1"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Interfaces.RealInput TOut(unit="K") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,5},{-100,45}})));
  Interfaces.RealInput TBuf(unit="K") "Buffer temperature"
    annotation (Placement(transformation(extent={{-140,-45},{-100,-5}})));
  Interfaces.RealInput TConOut(unit="K") "Condenser outlet temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Interfaces.RealOutput y(unit="1") "Compressor speed"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Real TSupSet(unit="K") "Supply temperature set point (heating curve)";
  Real TCon(unit="K", start=TSet, fixed=true) "Measured condenser outlet temperature";
  Real heaOn "Heating on";
  Hysteresis warOut(uLow=TOutHeaLim - 1, uHigh=TOutHeaLim + 1, u=TOut) "Outside the heating season";
  Hysteresis bufCha(uLow=-dTHys/2, uHigh=dTHys/2, u=TSupSet - TBuf, y_start=1) "Charging the buffer";
  PI conCom(k=kCom, Ti=TiCom, yMin=yComMin, yMax=1, yReset=yComMin, dY=dY, e=TSupSet + dTHys - TCon,
    enable=heaOn);
equation
  TSupSet = Utilities.smoothMin(TSet, Utilities.smoothMax(TSupMin, TSet + (TSupMin - TSet)*(TOut - TOutDes)
    /(TOutHeaLim - TOutDes), dT), dT);
  tauSen*der(TCon) = TConOut - TCon;
  heaOn = demand*(1 - warOut.y)*bufCha.y;
  y = heaOn*conCom.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}, fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(extent={{-90,40},{90,-40}}, textColor={0,0,0}, textString="heat pump"),
      Text(extent={{-150,150},{150,110}}, textColor={0,0,255}, textString="%name")}));
end HeatPumpControl;
