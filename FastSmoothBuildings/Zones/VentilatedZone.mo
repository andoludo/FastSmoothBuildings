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
end VentilatedZone;
