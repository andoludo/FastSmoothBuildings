within FastSmoothBuildings.Utilities.Validation;
model SmoothFunctions "The smooth functions over a ramp of their argument"
  extends FastSmoothBuildings.Icons.Example;
  Real x = 2*time - 1 "Argument, from -1 to 1";
  Real yStep = FastSmoothBuildings.Utilities.regStep(x, 1, 0, 0.2) "Step from 0 to 1 over [-0.2, 0.2]";
  Real yMax = FastSmoothBuildings.Utilities.smoothMax(x, 0, 0.2) "max(x, 0), blended over [-0.2, 0.2]";
  Real yMin = FastSmoothBuildings.Utilities.smoothMin(x, 0, 0.2) "min(x, 0), blended over [-0.2, 0.2]";
  Real yLimit = FastSmoothBuildings.Utilities.smoothLimit(x, -0.5, 0.5, 0.1)
    "x limited to [-0.5, 0.5], exactly at the bounds beyond 0.1 from them";
  Real yInside = FastSmoothBuildings.Utilities.smoothLimitInside(x, -0.5, 0.5, 0.1)
    "x limited to about [-0.4, 0.4] (blends of 0.1), strictly inside [-0.5, 0.5]";
  Real yPositive = FastSmoothBuildings.Utilities.positivePart(x, 0.1) "max(x, 0), smooth everywhere";
  annotation (
    experiment(StopTime=1, Interval=0.01, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMin\">smoothMin</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a>,
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimitInside\">smoothLimitInside</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.positivePart\">positivePart</a> while their argument goes from
&minus;1 to 1: each meets the function it replaces outside its blend and stays differentiable inside it.
</p>
</html>"));
end SmoothFunctions;
