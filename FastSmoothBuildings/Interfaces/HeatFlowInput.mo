within FastSmoothBuildings.Interfaces;
connector HeatFlowInput "Heat flow rate of an ideal system: input of building_mpc"
  RealInput Q_flow(unit="W") "Heat flow rate, positive for heating";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
        points={{-100,100},{100,0},{-100,-100}})}));
end HeatFlowInput;
