within FastSmoothBuildings.Envelope.Validation;
model GapConductance "Conductance of a 12 mm gas gap against the temperatures of its panes"
  extends FastSmoothBuildings.Icons.Example;
  Real T_b(unit="K") = 263.15 + 40*time "Inner pane, from -10 to 30 degC";
  Real T_a(unit="K") = T_b - 15 "Outer pane, 15 K colder";
  Real hAir(unit="W/(m2.K)") = FastSmoothBuildings.Envelope.Functions.gapConductance(T_a, T_b, 0.012, 0.025, 3.723e-6,
    4.94e-8, 1006, 0.02897, 0.84, 0.84, 2.0) "Air between two clear panes";
  Real hLowE(unit="W/(m2.K)") = FastSmoothBuildings.Envelope.Functions.gapConductance(T_a, T_b, 0.012, 0.025,
    3.723e-6, 4.94e-8, 1006, 0.02897, 0.84, 0.04, 2.0) "Air, a low-emissivity coating on the inner pane";
  Real hArgon(unit="W/(m2.K)") = FastSmoothBuildings.Envelope.Functions.gapConductance(T_a, T_b, 0.016, 0.0174,
    3.379e-6, 6.451e-8, 522, 0.039931494, 0.84, 0.04, 2.0) "16 mm of argon, a low-emissivity coating";
  annotation (
    experiment(StopTime=1, Interval=0.01, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.gapConductance\">gapConductance</a> of three gaps of
a window 2 m high while the panes warm from &minus;25/&minus;10 &deg;C to 15/30 &deg;C: the long-wave part grows
with the cube of the temperature, the low-emissivity coating removes most of it.
</p>
</html>"));
end GapConductance;
