within FastSmoothBuildings.Interfaces;
connector ControlInput "A control of building_mpc: input between its bounds (a decision of the MPC)"
  RealInput y(min=0, max=1, unit="1") "Control signal, 0 to 1";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
        points={{-100,100},{100,0},{-100,-100}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
A control of <code>building_mpc</code>, the model for optimal control: the input <code>y</code>, dimensionless,
with the bounds <code>min</code> = 0 and <code>max</code> = 1. A signal, not a flow variable.
</p>
<h4>Use</h4>
<p>
Declared at the top level of the model, <code>y</code> is an input of the CasADi function (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>), a decision of the
MPC between its bounds. The same variable as
<a href=\"modelica://FastSmoothBuildings.Interfaces.ControlSignal\">ControlSignal</a>, with the bounds.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end ControlInput;
