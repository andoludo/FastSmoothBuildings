within FastSmoothBuildings.Envelope.Validation;
model ShadingFractions "Sunlit fractions of a window under an overhang and between side fins as the sun moves"
  extends FastSmoothBuildings.Icons.Example;
  Real verAzi(unit="rad") = -1.4 + 2.8*time "Sun from 80 degrees right of the wall normal to 80 degrees left";
  Real alt(unit="rad") = 0.05 + 1.1*sin(pi*time) "Solar altitude, highest when the sun faces the wall";
  Real side = sin(verAzi) "Positive when the sun is left of the normal, seen from outside";
  Real fraOverhang = FastSmoothBuildings.Envelope.Functions.overhangSunlitFraction(verAzi, alt, side, 2.0, 3.0, 1.0,
    0.0, 0.5, 0.5) "Window of 3 m by 2 m under an overhang 1 m deep, 0.5 m wider on each side";
  Real fraFins = FastSmoothBuildings.Envelope.Functions.sideFinsSunlitFraction(verAzi, alt, 2.0, 3.0, 1.0, 0.0, 0.0)
    "The same window between two fins 1 m deep";
  annotation (
    experiment(StopTime=1, Interval=0.01, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.overhangSunlitFraction\">overhangSunlitFraction</a> and
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.sideFinsSunlitFraction\">sideFinsSunlitFraction</a>
(Buildings' Overhang and SideFins with smooth minima, maxima and steps) while the sun crosses the sky in front of
the window.
</p>
</html>"));
end ShadingFractions;
