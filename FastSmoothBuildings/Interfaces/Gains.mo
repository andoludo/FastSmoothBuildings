within FastSmoothBuildings.Interfaces;
connector Gains "Internal gains per floor area (receiving side)"
  RealInput QCon(unit="W/m2") "Convective internal gains per floor area";
  RealInput QRad(unit="W/m2") "Radiant internal gains per floor area";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}}),
      Polygon(fillColor={255,215,136}, fillPattern=FillPattern.Solid,
        points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
        smooth=Smooth.Bezier),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-65,15},{-55,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-5,15},{5,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{55,15},{65,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-35,-25},{-25,-15}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}));
end Gains;
