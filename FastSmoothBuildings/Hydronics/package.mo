within FastSmoothBuildings;
package Hydronics
  "Water circuits after Buildings.Fluid. Two modes, set by the evaluated parameter pressureDriven of every component:
   set flows (each valve sets the flow of its branch, the production closes the balance: the model of optimal
   control), or pressure-driven flows (closed-loop simulation: a pressure node at the inlet of every component, the
   flow of every outlet from its conductance, the pumps on their curves, as the linearized circuits of Buildings)"
end Hydronics;
