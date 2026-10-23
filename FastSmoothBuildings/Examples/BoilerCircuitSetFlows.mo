within FastSmoothBuildings.Examples;
model BoilerCircuitSetFlows "The boiler circuit with set flows, as the model of optimal control has them"
  extends BoilerCircuit(pressureDriven=false);
  annotation (
    experiment(StopTime=259200, Interval=900, Tolerance=1e-06),
    Documentation(info="<html>
<p>
<a href=\"modelica://FastSmoothBuildings.Examples.BoilerCircuit\">BoilerCircuit</a> with set flows: the valve sets
the flow of its branch to its signal times its nominal flow, the three-way valve the share of the supply, and the
boiler closes the balance of the circuit. The model of optimal control has these flows; there, the signals are
inputs that the optimizer chooses, here the controllers of the closed loop still give them.
</p>
</html>"));
end BoilerCircuitSetFlows;
