within FastSmoothBuildings.Envelope;
partial model PartialSurface "A surface of a zone: area, orientation and its bus"
  parameter Real A(unit="m2") "Area seen from the room";
  parameter Real azi(unit="rad") = 0 "Azimuth: 0 south, pi/2 west";
  parameter Real til(unit="rad") "Tilt: 0 roof (ceiling), pi/2 wall, pi floor";
  parameter Real T_start(unit="K") = 294.15 "Initial temperature";
  Interfaces.SurfaceBus propsBus_a "Connection to the zone"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  parameter Real cIntPos = Utilities.convectionCoefficient(til, true) "Interior natural convection, surface warmer";
  parameter Real cIntNeg = Utilities.convectionCoefficient(til, false) "Interior natural convection, surface colder";
  parameter Real isFloor = if abs(sin(til)) < 1e-6 and cos(til) < 0 then 1 else 0;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Base class of every surface of a zone: the area <code>A</code> seen from the room, the azimuth <code>azi</code>, the
tilt <code>til</code> (see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>), the
initial temperature <code>T_start</code> and the bus <code>propsBus_a</code> to the zone.
</p>
<p>
It computes, from the tilt, the coefficients of the interior natural convection
(<a href=\"modelica://FastSmoothBuildings.Utilities.convectionCoefficient\">convectionCoefficient</a>):
<code>cIntPos</code> when the surface is warmer than the air, <code>cIntNeg</code> when it is colder; and
<code>isFloor</code>, 1 for a surface of tilt &pi; (a floor), 0 otherwise.
</p>
<h4>Extending classes</h4>
<p>
They provide the states of the surface and the equations of the bus: the temperature of the room face
(<code>propsBus_a.rad.T</code>), the heat flow rates of its ports <code>con</code> and <code>rad</code>, and the
properties the zone reads, <code>A</code>, <code>epsLw</code>, <code>absSol</code>, <code>tauSol</code>,
<code>isFloor</code>, <code>QTraDir</code> and <code>QTraDif</code>
(<a href=\"modelica://FastSmoothBuildings.Interfaces.SurfaceBus\">SurfaceBus</a>):
<a href=\"modelica://FastSmoothBuildings.Envelope.PartialOpaque\">PartialOpaque</a> and
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope</code>.</li>
</ul>
</html>"));
end PartialSurface;
