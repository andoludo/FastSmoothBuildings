within FastSmoothBuildings.Interfaces;
connector HeatFlowInput "Heat flow rate of an ideal system: input of building_mpc"
  RealInput Q_flow(unit="W") "Heat flow rate, positive for heating";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
        points={{-100,100},{100,0},{-100,-100}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
The heat flow rate <code>Q_flow</code> (W) of an ideal system, positive for heating, as an input of
<code>building_mpc</code>, the model for optimal control.
A signal, not a flow variable.
</p>
<h4>Use</h4>
<p>
Declared at the top level of the model, <code>Q_flow</code> is an input of the CasADi function (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end HeatFlowInput;
