within FastSmoothBuildings.Utilities;
function timeOfDay "Seconds since midnight, without events"
  input Real t(unit="s");
  output Real tod(unit="s");
algorithm
  tod := noEvent(t - 86400*floor(t/86400));
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Time of day, in seconds since midnight, without the events of <code>floor</code>.
</p>
<h4>Equations</h4>
<p>
<i>t<sub>day</sub></i> = <i>t</i> &minus; 86400 floor(<i>t</i>/86400), inside <code>noEvent</code>.
</p>
<p>
A sawtooth from 0 to 86400 s that drops back to 0 at each midnight (<i>t</i> a multiple of 86400 s), with a slope
of 1 in between: discontinuous at midnight, but without an event.
</p>
<h4>Use</h4>
<p>
The argument of the daily schedules
<a href=\"modelica://FastSmoothBuildings.Utilities.occupancy\">occupancy</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.dayTable\">dayTable</a>: a schedule whose values at 0 and
86400 s are equal stays continuous across midnight. See also
<a href=\"modelica://FastSmoothBuildings.Utilities.Validation.Schedules\">Validation.Schedules</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end timeOfDay;
