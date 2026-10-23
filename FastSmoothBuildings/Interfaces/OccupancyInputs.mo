within FastSmoothBuildings.Interfaces;
connector OccupancyInputs "Internal gains of a zone: inputs of building_mpc"
  GainInputs gai "Internal gains per floor area";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(lineColor={255,204,51}, lineThickness=0.5, extent={{-20,-2},{20,2}}),
      Polygon(fillColor={255,215,136}, fillPattern=FillPattern.Solid,
        points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
        smooth=Smooth.Bezier),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-65,15},{-55,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-5,15},{5,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{55,15},{65,25}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{-35,-25},{-25,-15}}),
      Ellipse(fillPattern=FillPattern.Solid, extent={{25,-25},{35,-15}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
The internal gains of a zone as inputs of <code>building_mpc</code>, the model for optimal control: the
<a href=\"modelica://FastSmoothBuildings.Interfaces.GainInputs\">GainInputs</a> <code>gai</code>, convective and
radiant gains per floor area in W/m<sup>2</sup>.
</p>
<h4>Use</h4>
<p>
Declared at the top level of the model, one per zone, <code>gai.QCon</code> and <code>gai.QRad</code> are inputs of
the CasADi function (see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into
CasADi</a>), given by a schedule or a forecast of the occupancy.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end OccupancyInputs;
