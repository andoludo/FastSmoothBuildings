within FastSmoothBuildings.Zones;
model Zone "Thermal zone"
  extends PartialZone;
equation
  QVen = 0;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
A thermal zone without a ventilation system:
<a href=\"modelica://FastSmoothBuildings.Zones.PartialZone\">PartialZone</a> with <code>QVen</code> = 0. Its air
is renewed by the infiltration (<code>ACH</code>) and the scheduled outdoor air (<code>ventilationSchedule</code>)
only.
</p>
<h4>Use</h4>
<p>
Connect the surfaces to <code>propsBus</code>, the weather to <code>weaBus</code>, the internal gains to
<code>qGai_flow</code> and the emitters to <code>heaPorAir</code> and <code>heaPorRad</code>. See
<a href=\"modelica://FastSmoothBuildings.Examples.FreeFloatingRoom\">Examples.FreeFloatingRoom</a> and
<a href=\"modelica://FastSmoothBuildings.Examples.TwoZones\">Examples.TwoZones</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Zones</code>.</li>
</ul>
</html>"));
end Zone;
