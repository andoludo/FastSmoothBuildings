within FastSmoothBuildings.Utilities;
function quadraticFlow
  "Flow through a quadratic resistance (m_flow_nominal at dp_nominal), regularized below deltaM*m_flow_nominal"
  input Real dp(unit="Pa");
  input Real m_flow_nominal(unit="kg/s");
  input Real dp_nominal(unit="Pa");
  input Real deltaM = 0.1;
  output Real m_flow(unit="kg/s");
algorithm
  m_flow := m_flow_nominal/sqrt(dp_nominal)*dp/(dp^2 + (deltaM^2*dp_nominal)^2)^0.25;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Mass flow rate through a quadratic flow resistance, <i>&Delta;p</i> = <i>&Delta;p<sub>nom</sub></i>
(<i>m&#775;</i>/<i>m&#775;<sub>nom</sub></i>)<sup>2</sup>, regularised at small flows so that it is infinitely
differentiable.
</p>
<h4>Equations</h4>
<p>
<i>m&#775;</i> = <i>m&#775;<sub>nom</sub></i>/&radic;<i>&Delta;p<sub>nom</sub></i> &middot; <i>&Delta;p</i> /
(<i>&Delta;p</i><sup>2</sup> + (<i>&delta;<sub>m</sub></i><sup>2</sup>
<i>&Delta;p<sub>nom</sub></i>)<sup>2</sup>)<sup>1/4</sup>, &nbsp; <i>&delta;<sub>m</sub></i> = <code>deltaM</code>.
</p>
<p>
For |<i>&Delta;p</i>| &gt;&gt; <i>&delta;<sub>m</sub></i><sup>2</sup> <i>&Delta;p<sub>nom</sub></i>, the pressure
drop of the flow <i>&delta;<sub>m</sub></i> <i>m&#775;<sub>nom</sub></i>, the flow tends to
sign(<i>&Delta;p</i>) <i>m&#775;<sub>nom</sub></i> &radic;(|<i>&Delta;p</i>|/<i>&Delta;p<sub>nom</sub></i>); near
<i>&Delta;p</i> = 0 it is linear, <i>m&#775;</i> &asymp; <i>m&#775;<sub>nom</sub></i> <i>&Delta;p</i> /
(<i>&delta;<sub>m</sub></i> <i>&Delta;p<sub>nom</sub></i>). Odd in <i>&Delta;p</i>, C-infinity for
<i>&delta;<sub>m</sub></i> &gt; 0.
</p>
<h4>Use</h4>
<p>
<code>deltaM</code> = 0.1 by default. The boiler computes the flows of its outlets with it when the flows are
pressure-driven.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end quadraticFlow;
