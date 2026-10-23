within FastSmoothBuildings.Utilities.Validation;
model Schedules "Daily schedules without events over two days"
  extends FastSmoothBuildings.Icons.Example;
  parameter Real schedule[4](each unit="s") = 3600*{7, 12, 13, 19}
    "Occupied from 7:00 to 12:00 and from 13:00 to 19:00";
  parameter Real table[5, 2] = [0, 289.15; 25200, 289.15; 28800, 294.15; 79200, 294.15; 82800, 289.15]
    "Set point: 16 degC at night, 21 degC by day, ramps of an hour";
  Real tod(unit="s") "Time of day";
  Real occupied "1 when occupied, each change over 10 minutes";
  Real TSet(unit="K") "Set point";
equation
  tod = FastSmoothBuildings.Utilities.timeOfDay(time);
  occupied = FastSmoothBuildings.Utilities.occupancy(tod, schedule, 600);
  TSet = FastSmoothBuildings.Utilities.dayTable(tod, table);
  annotation (
    experiment(StopTime=172800, Interval=300, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Utilities.timeOfDay\">timeOfDay</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.occupancy\">occupancy</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.dayTable\">dayTable</a> repeat a day schedule without the
events of a clock or a table. The table is a parameter and the calls are equations: the form rumoca translates (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>).
</p>
</html>"));
end Schedules;
