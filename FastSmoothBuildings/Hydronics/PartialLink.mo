within FastSmoothBuildings.Hydronics;
partial model PartialLink
  "Pressure-driven outlets of a component without resistance in Buildings: a small linear one, dpLink at the
   nominal flow of each outlet. It must stay small against the branches it feeds: at 1000 Pa, the manifold of six
   radiators of the renovated house took a fifth of the head of the living room branch, whose valve then opened
   fully a third more often than in Buildings"
  extends PartialConserving(final GHyd=nPorts_b*GLink);
  parameter Real m_flow_nominal(unit="kg/s") = 0.15 "Nominal flow";
  parameter Real dpLink(unit="Pa") = 100 "Pressure drop at the nominal flow (pressure-driven flows)";
  final parameter Real GLink(unit="kg/(s.Pa)") = m_flow_nominal/nPorts_b/dpLink "Conductance of each outlet";
equation
  if pressureDriven then
    for i in 1:nPorts_b loop
      port_b[i].m_flow = -GLink*(pIn - port_b[i].p);
    end for;
  end if;
end PartialLink;
