within FastSmoothBuildings.Controls.Validation;
model PIControl "A PI controller holding a first-order process, disabled half way"
  extends FastSmoothBuildings.Icons.Example;
  Real x(start=0, fixed=true) "Process, a first-order lag of 60 s on the controller output";
  Real enable = 1 - FastSmoothBuildings.Utilities.regStep(time - 900, 1, 0, 5) "1 until 900 s, then 0";
  FastSmoothBuildings.Controls.PI con(k=2, Ti=60, e=0.6 - x, enable=enable) "Holds the process at 0.6";
equation
  60*der(x) = con.y - x;
  annotation (
    experiment(StopTime=1800, Interval=2, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Controls.PI\">PI</a> with its anti-windup and smooth limits holds a
first-order process at 0.6; from 900 s it is disabled, and its output returns to <code>yReset</code> with the
time constant <code>tauReset</code>.
</p>
</html>"));
end PIControl;
