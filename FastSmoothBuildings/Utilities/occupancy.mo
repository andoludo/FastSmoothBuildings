within FastSmoothBuildings.Utilities;
function occupancy
  "1 between the pairs of instants of a day schedule {on, off, on, off, ...} [s] (Buildings OccupancySchedule
   with firstEntryOccupied), each change a smooth step over dt"
  input Real tod(unit="s") "Time of day";
  input Real schedule[:](each unit="s");
  input Real dt(unit="s") = 60;
  output Real y;
algorithm
  y := 0;
  for k in 1:div(size(schedule, 1), 2) loop
    y := y + regStep(tod - schedule[2*k - 1], 1, 0, dt/2) - regStep(tod - schedule[2*k], 1, 0, dt/2);
  end for;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Occupancy from a day schedule of instants {on, off, on, off, &hellip;} in seconds since midnight: 1 between the
instants of each pair, 0 outside, each change a smooth step without events.
</p>
<h4>Equations</h4>
<p>
With the schedule <i>s</i> and <i>&Delta;t</i> = <code>dt</code>,
</p>
<p>
<i>y</i> = &sum;<sub><i>k</i></sub> [regStep(<i>t<sub>day</sub></i> &minus; <i>s</i><sub>2<i>k</i>&minus;1</sub>,
1, 0, <i>&Delta;t</i>/2) &minus; regStep(<i>t<sub>day</sub></i> &minus; <i>s</i><sub>2<i>k</i></sub>, 1, 0,
<i>&Delta;t</i>/2)],
</p>
<p>
over the complete pairs (a last unpaired instant is ignored). Each change is a
<a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a> over
<i>&Delta;t</i> centred on its instant: C1, with the value 1/2 at the instant itself. The result stays in [0, 1]
when the instants increase and are at least <i>&Delta;t</i> apart, and is continuous across midnight when they lie
between <i>&Delta;t</i>/2 and 86400 s &minus; <i>&Delta;t</i>/2.
</p>
<h4>Relation to Buildings</h4>
<p>
The schedule of <code>Buildings.Controls.SetPoints.OccupancySchedule</code> with
<code>firstEntryOccupied = true</code>; the result is a Real between 0 and 1 instead of a Boolean.
</p>
<h4>Use</h4>
<p>
Call it with <code>tod</code> =
<a href=\"modelica://FastSmoothBuildings.Utilities.timeOfDay\">timeOfDay</a>(<code>time</code>);
<code>dt</code> = 60 s by default. See
<a href=\"modelica://FastSmoothBuildings.Utilities.Validation.Schedules\">Validation.Schedules</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end occupancy;
