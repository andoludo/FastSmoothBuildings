within FastSmoothBuildings.Controls.Validation;
model Hysteresis "A hysteresis as a fast bistable state, driven by a sine"
  extends FastSmoothBuildings.Icons.Example;
  FastSmoothBuildings.Controls.Hysteresis hys(uLow=-0.5, uHigh=0.5, tau=10, u=sin(2*pi*time/600))
    "Switches on above 0.5, off below -0.5, in about 10 s";
  annotation (
    experiment(StopTime=1200, Interval=2, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Controls.Hysteresis\">Hysteresis</a>: its output is a state that moves
towards 1 above <code>uHigh</code> and towards 0 below <code>uLow</code> with the time constant <code>tau</code>,
and keeps its value in between, without events.
</p>
</html>"));
end Hysteresis;
