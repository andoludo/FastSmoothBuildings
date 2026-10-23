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
end occupancy;
