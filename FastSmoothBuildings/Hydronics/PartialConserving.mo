within FastSmoothBuildings.Hydronics;
partial model PartialConserving "Mass is conserved: what enters leaves"
  extends PartialFlow;
equation
  if not pressureDriven then
    m_flow + sum(port_b[i].m_flow for i in 1:nPorts_b) = 0;
  end if;
end PartialConserving;
