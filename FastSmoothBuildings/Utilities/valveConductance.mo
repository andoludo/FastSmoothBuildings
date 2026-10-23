within FastSmoothBuildings.Utilities;
function valveConductance
  "Conductance m_flow/dp of a valve with a fixed resistance in series, its flow law linearized as Buildings does
   (linearized=true): m_flow*m_flow_nominal = k^2*dp, 1/k^2 = 1/kFixed^2 + 1/(phi*Kv)^2"
  input Real phi "Valve characteristic";
  input Real m_flow_nominal(unit="kg/s");
  input Real dpValve_nominal(unit="Pa");
  input Real dpFixed_nominal(unit="Pa");
  output Real G(unit="kg/(s.Pa)");
algorithm
  G := 1/(m_flow_nominal*(dpFixed_nominal/m_flow_nominal^2 + dpValve_nominal/(phi*m_flow_nominal)^2));
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Conductance <i>G</i> = <i>m&#775;</i>/<i>&Delta;p</i> of a valve and a fixed resistance in series, the flow law
linearized as Buildings does with <code>linearized = true</code>.
</p>
<h4>Equations</h4>
<p>
<i>G</i> = 1 / (<i>m&#775;<sub>nom</sub></i>
(<i>&Delta;p<sub>fix,nom</sub></i>/<i>m&#775;<sub>nom</sub></i><sup>2</sup>
+ <i>&Delta;p<sub>val,nom</sub></i>/(<i>&phi;</i> <i>m&#775;<sub>nom</sub></i>)<sup>2</sup>)),
</p>
<p>
that is <i>m&#775;</i> <i>m&#775;<sub>nom</sub></i> = <i>k</i><sup>2</sup> <i>&Delta;p</i> with
1/<i>k</i><sup>2</sup> = 1/<i>k<sub>fix</sub></i><sup>2</sup> + 1/(<i>&phi;</i> <i>K<sub>v</sub></i>)<sup>2</sup>,
<i>k<sub>fix</sub></i><sup>2</sup> = <i>m&#775;<sub>nom</sub></i><sup>2</sup>/<i>&Delta;p<sub>fix,nom</sub></i>,
<i>K<sub>v</sub></i><sup>2</sup> = <i>m&#775;<sub>nom</sub></i><sup>2</sup>/<i>&Delta;p<sub>val,nom</sub></i>.
Fully open (<i>&phi;</i> = 1), the valve passes <i>m&#775;<sub>nom</sub></i> under
<i>&Delta;p<sub>val,nom</sub></i> + <i>&Delta;p<sub>fix,nom</sub></i>.
</p>
<h4>Use</h4>
<p>
<i>&phi;</i> must stay positive: the valves give the characteristic of
<a href=\"modelica://FastSmoothBuildings.Utilities.equalPercentage\">equalPercentage</a>, at least its leakage.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end valveConductance;
