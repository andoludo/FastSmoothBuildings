within FastSmoothBuildings.Interfaces;
connector ControlSignal "Control signal of a component (receiving side)"
  RealInput y(unit="1") "Control signal, 0 to 1";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid,
        points={{-100,100},{100,0},{-100,-100}})}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Receiving side of the control signal of a component: the input <code>y</code>, dimensionless, from 0 to 1. A signal,
not a flow variable. No bounds are declared, unlike
<a href=\"modelica://FastSmoothBuildings.Interfaces.ControlInput\">ControlInput</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end ControlSignal;
