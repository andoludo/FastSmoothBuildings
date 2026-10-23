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
end PartialSurface;
