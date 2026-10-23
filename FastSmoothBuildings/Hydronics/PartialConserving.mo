within FastSmoothBuildings.Hydronics;
partial model PartialConserving "Mass is conserved: what enters leaves"
  extends PartialFlow;
equation
  if not pressureDriven then
    m_flow + sum(port_b[i].m_flow for i in 1:nPorts_b) = 0;
  end if;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialFlow\">PartialFlow</a> with the mass balance of the
component: with set flows, what enters leaves,
</p>
<p>
<code>m_flow</code> + &sum;<sub><i>j</i></sub> <code>port_b[j].m_flow</code> = 0.
</p>
<p>
With pressure-driven flows, the balance is the equation of the pressure of the inlet node in
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialFlow\">PartialFlow</a>: inflow and outflow differ only
by the mass held in its small compliance.
</p>
<h4>Extending classes</h4>
<p>
They give <code>TOut</code> and, with pressure-driven flows, the flows of the outlets.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end PartialConserving;
