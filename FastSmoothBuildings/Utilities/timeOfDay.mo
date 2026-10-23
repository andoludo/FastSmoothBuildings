within FastSmoothBuildings.Utilities;
function timeOfDay "Seconds since midnight, without events"
  input Real t(unit="s");
  output Real tod(unit="s");
algorithm
  tod := noEvent(t - 86400*floor(t/86400));
end timeOfDay;
