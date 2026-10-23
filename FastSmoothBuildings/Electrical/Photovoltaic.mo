within FastSmoothBuildings.Electrical;
model Photovoltaic "PV array (Buildings PVSimpleOriented): P = A*fAct*eta*eta_DCAC*(HDir + HDif)"
  parameter Real A(unit="m2") "Area of the modules";
  parameter Real eta = 0.12 "Module conversion efficiency";
  parameter Real fAct = 0.9 "Fraction of the area with active cells";
  parameter Real eta_DCAC = 0.9 "Efficiency of the conversion from DC to AC";
  parameter Real til(unit="rad") "Tilt";
  parameter Real azi(unit="rad") "Azimuth: 0 south";
  Interfaces.WeatherBusIn weaBus "Weather"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  BoundaryConditions.TiltedSurface sol(final azi=azi, final til=til) "Irradiance on the modules";
  Real P(unit="W") "Electrical power produced";
  Real EPro(unit="kWh", start=0, fixed=true) "Production meter";
equation
  connect(weaBus, sol.weaBus);
  P = A*fAct*eta*eta_DCAC*(sol.HDir + sol.HDif);
  der(EPro) = P/3.6e6;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Polygon(points={{-80,-52},{-32,63},{78,63},{29,-52},{-80,-52}}, fillColor={205,203,203},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None, lineColor={0,0,0}),
      Polygon(points={{-69,-45},{-57,-19},{-34,-19},{-45,-45},{-69,-45}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-53,-9},{-41,17},{-18,17},{-29,-9},{-53,-9}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-38,27},{-26,53},{-3,53},{-14,27},{-38,27}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-36,-45},{-24,-19},{-1,-19},{-12,-45},{-36,-45}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-20,-9},{-8,17},{15,17},{4,-9},{-20,-9}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-5,27},{7,53},{30,53},{19,27},{-5,27}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{-3,-45},{9,-19},{32,-19},{21,-45},{-3,-45}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{13,-9},{25,17},{48,17},{37,-9},{13,-9}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Polygon(points={{28,27},{40,53},{63,53},{52,27},{28,27}}, fillColor={6,13,150},
        fillPattern=FillPattern.Solid, pattern=LinePattern.None),
      Text(extent={{-150,-104},{150,-64}}, textColor={0,0,0}, textString="%name")}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Electrical power of a photovoltaic array of area <code>A</code>, azimuth <code>azi</code> and tilt <code>til</code>,
proportional to the irradiance on its plane
(<a href=\"modelica://FastSmoothBuildings.BoundaryConditions.TiltedSurface\">TiltedSurface</a>):
</p>
<p>
<i>P</i> = <i>A</i> <i>f<sub>act</sub></i> <i>&eta;</i> <i>&eta;<sub>DC/AC</sub></i> (<i>H<sub>dir</sub></i> +
<i>H<sub>dif</sub></i>),
</p>
<p>
with the fraction of the area with active cells <code>fAct</code>, the module efficiency <code>eta</code> and the
efficiency of the inverter <code>eta_DCAC</code>, all constant. The meter <code>EPro</code> integrates the
production in kWh.
</p>
<h4>Relation to Buildings</h4>
<p>
The power of Buildings' <code>PVSimpleOriented</code>. The model has no electrical connector: the power is the
variable <code>P</code>.
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Examples.Photovoltaics\">Examples.Photovoltaics</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Electrical</code>.</li>
</ul>
</html>"));
end Photovoltaic;
