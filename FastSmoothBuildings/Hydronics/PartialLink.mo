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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Pressure-driven outlets of a component that has no flow resistance in Buildings (a sensor, a pass-through).
With pressure-driven flows every outlet needs a conductance; this class gives it a small linear one.
</p>
<h4>Equations</h4>
<p>
With pressure-driven flows, for each of the <i>n<sub>b</sub></i> = <code>nPorts_b</code> outlets,
</p>
<p>
<code>port_b[j].m_flow</code> = &minus;<i>G<sub>link</sub></i> (<i>p<sub>in</sub></i> &minus;
<i>p<sub>b,j</sub></i>), &nbsp; <i>G<sub>link</sub></i> = <code>m_flow_nominal</code> /
(<i>n<sub>b</sub></i> <code>dpLink</code>),
</p>
<p>
so that the nominal flow, shared evenly by the outlets, passes at the pressure drop <code>dpLink</code>. The
compliance of the inlet node is scaled by the total conductance <code>GHyd</code> =
<i>n<sub>b</sub></i> <i>G<sub>link</sub></i>. With set flows, the class adds nothing to
<a href=\"modelica://FastSmoothBuildings.Hydronics.PartialConserving\">PartialConserving</a>.
</p>
<h4>Parameters</h4>
<p>
<code>dpLink</code> must stay small against the pressure drops of the branches the link feeds. At 1000 Pa, the
manifold of six radiators of the renovated house took a fifth of the head of the living room branch, whose valve
then opened fully a third more often than in Buildings; the default is 100 Pa.
</p>
<h4>Extending classes</h4>
<p>
They give <code>TOut</code>, e.g.
<a href=\"modelica://FastSmoothBuildings.Hydronics.Pipe\">Pipe</a> and
<a href=\"modelica://FastSmoothBuildings.Hydronics.TemperatureSensor\">TemperatureSensor</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end PartialLink;
