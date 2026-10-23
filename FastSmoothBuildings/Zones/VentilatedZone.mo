within FastSmoothBuildings.Zones;
model VentilatedZone "Thermal zone with supply and extract air of a ventilation unit"
  extends PartialZone;
  parameter Integer nPorts_a = 1 "Number of supply air connections";
  parameter Integer nPorts_b = 1 "Number of extract air connections";
  Ventilation.AirInlet ports_a[nPorts_a] "Supply air"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Ventilation.AirOutlet ports_b[nPorts_b] "Extract air, at the zone air temperature"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
equation
  // the extract ducts carry the flows of the supply ones: the fan speed passes through the zone
  for i in 1:nPorts_b loop
    ports_b[i].T = TAir;
    ports_b[i].y = sum(ports_a[j].y for j in 1:nPorts_a)/nPorts_a;
  end for;
  QVen = sum(ports_a[i].m_flow*cpAir*(ports_a[i].T - TAir) for i in 1:nPorts_a);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
A thermal zone with the supply and extract air of a ventilation unit:
<a href=\"modelica://FastSmoothBuildings.Zones.PartialZone\">PartialZone</a> with air ports.
</p>
<h4>Equations</h4>
<p>
<i>Q<sub>Ven</sub></i> = &sum; <i>&#7745;<sub>a,i</sub></i> <i>c<sub>p</sub></i> (<i>T<sub>a,i</sub></i> &minus;
<i>T<sub>Air</sub></i>) over the supply ports <code>ports_a</code>.
</p>
<p>
The extract ports <code>ports_b</code> leave at the zone air temperature and pass on the mean fan speed of the
supply ports, so that the extract ducts downstream run at the speed of the supply ones.
</p>
<h4>Parameters</h4>
<p>
<code>nPorts_a</code> = 1 supply and <code>nPorts_b</code> = 1 extract connections, and those of
<a href=\"modelica://FastSmoothBuildings.Zones.PartialZone\">PartialZone</a>.
</p>
<h4>Use</h4>
<p>
Connect a <a href=\"modelica://FastSmoothBuildings.Ventilation.Duct\">Duct</a> from the supply of a
<a href=\"modelica://FastSmoothBuildings.Ventilation.HeatRecoveryUnit\">HeatRecoveryUnit</a> to <code>ports_a</code>
and another from <code>ports_b</code> back to its extract, as in
<a href=\"modelica://FastSmoothBuildings.Examples.VentilatedRoom\">Examples.VentilatedRoom</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Zones</code>.</li>
</ul>
</html>"));
end VentilatedZone;
