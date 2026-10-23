within FastSmoothBuildings;
package Controls
  "Controllers of the closed-loop model: the controls of trano's Buildings models without events (smooth limits
   and set point changes, hysteresis as fast bistable states, anti-windup PI). The width of every smooth transition
   and the switching time of every hysteresis are parameters (dU, dY, dMax, dT, dtSet, tau), at values that
   reproduce the switching controllers by default; wider transitions and slower switches give a controller that
   collocation and gradient-based calibration can follow"
end Controls;
