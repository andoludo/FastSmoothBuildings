within FastSmoothBuildings.Envelope.Functions;
function gapConductance
  "Conductance of a vertical gas gap between two panes per unit area: convection of the gas
   (Buildings.HeatTransfer.Windows.BaseClasses.GasConvection and convectionVerticalCavity) and long-wave
   exchange between the two panes, opaque to it, at their temperatures (Buildings exchanges exactly)"
  input Real T_a(unit="K") "Temperature of the pane on the outer side";
  input Real T_b(unit="K") "Temperature of the pane on the inner side";
  input Real x(unit="m") "Thickness of the gap";
  input Real k(unit="W/(m.K)") "Thermal conductivity of the gas";
  input Real mu_a(unit="Pa.s") "Dynamic viscosity of the gas: mu_a + mu_b*T";
  input Real mu_b(unit="Pa.s/K");
  input Real c(unit="J/(kg.K)") "Specific heat capacity of the gas";
  input Real MM(unit="kg/mol") "Molar mass of the gas";
  input Real eps_a "Long-wave emissivity of the face of the outer pane";
  input Real eps_b "Long-wave emissivity of the face of the inner pane";
  input Real h(unit="m") "Height of the gap";
  output Real hGap(unit="W/(m2.K)");
protected
  Real T_m(unit="K") = (T_a + T_b)/2 "Mean temperature of the gas";
  Real rho(unit="kg/m3") "Density of the gas at atmospheric pressure (Buildings.HeatTransfer.Data.Gases)";
  Real Ra "Rayleigh number, at least 100 as Buildings";
  Real Nu "Nusselt number";
algorithm
  rho := 101325*MM/(8.314462618*T_m);
  // |T_a - T_b| regularised at 0.1 K: smooth when both panes are at the same temperature
  Ra := Utilities.smoothMax(rho^2*x^3*9.80665*c*sqrt((T_a - T_b)^2 + 0.01)/(T_m*(mu_a + mu_b*T_m)*k), 100, 10);
  // Wright's correlations of the vertical cavity, blended over 100 around Ra = 1E4 and 5E4 as Buildings,
  // against the correlation of the tall cavity
  Nu := Utilities.smoothMax(
    Utilities.regStep(Ra - 5E4, 0.0673838*Ra^(1/3),
      Utilities.regStep(Ra - 1E4, 0.028154*Ra^0.4134, 1 + 1.7596678E-10*Ra^2.2984755, 100), 100),
    0.242*(Ra*x/h)^0.272, 0.1);
  hGap := Nu*k/x + sigma*(T_a^2 + T_b^2)*(T_a + T_b)/(1/eps_a + 1/eps_b - 1);
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heat transfer coefficient <i>h<sub>gap</sub></i> of a vertical gas gap between two panes, per unit area, at the
temperatures of the panes: convection of the gas and long-wave exchange between the two faces. The window computes
the conductance of each gap with it at every time, so the U-value of the glazing follows the temperatures as in
Buildings.
</p>
<h4>Equations</h4>
<p>
Density of the gas at atmospheric pressure, at the mean temperature <i>T<sub>m</sub></i> = (<i>T<sub>a</sub></i> +
<i>T<sub>b</sub></i>)/2:
</p>
<p>
<i>&rho;</i> = <i>p</i> <i>M</i> / (<i>R</i> <i>T<sub>m</sub></i>), &nbsp;
<i>p</i> = 101325 Pa, <i>R</i> = 8.314462618 J/(mol K).
</p>
<p>
Rayleigh number, with the temperature difference regularised at 0.1 K and bounded below by 100:
</p>
<p>
<i>Ra</i> = smoothMax(<i>&rho;</i><sup>2</sup> <i>x</i><sup>3</sup> <i>g</i> <i>c</i>
&radic;((<i>T<sub>a</sub></i> &minus; <i>T<sub>b</sub></i>)<sup>2</sup> + 0.01) /
(<i>T<sub>m</sub></i> <i>&mu;</i> <i>k</i>), 100, 10), &nbsp; <i>&mu;</i> = <i>&mu;<sub>a</sub></i> +
<i>&mu;<sub>b</sub></i> <i>T<sub>m</sub></i>.
</p>
<p>
Nusselt number: the correlations of Wright (1996) for the vertical cavity, blended over 100 around
<i>Ra</i> = 10<sup>4</sup> and 5&middot;10<sup>4</sup>, against the correlation of the tall cavity of ISO 15099,
</p>
<table summary=\"Nusselt number of the gap\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Range</th><th><i>Nu<sub>1</sub></i></th></tr>
<tr><td><i>Ra</i> &gt; 5&middot;10<sup>4</sup></td><td>0.0673838 <i>Ra</i><sup>1/3</sup></td></tr>
<tr><td>10<sup>4</sup> &lt; <i>Ra</i> &le; 5&middot;10<sup>4</sup></td>
<td>0.028154 <i>Ra</i><sup>0.4134</sup></td></tr>
<tr><td><i>Ra</i> &le; 10<sup>4</sup></td><td>1 + 1.7596678&middot;10<sup>&minus;10</sup>
<i>Ra</i><sup>2.2984755</sup></td></tr>
</table>
<p>
<i>Nu</i> = smoothMax(<i>Nu<sub>1</sub></i>, 0.242 (<i>Ra</i> <i>x</i>/<i>h</i>)<sup>0.272</sup>, 0.1).
</p>
<p>
Conductance, the long-wave part exact for two grey parallel faces opaque to long-wave radiation:
</p>
<p>
<i>h<sub>gap</sub></i> = <i>Nu</i> <i>k</i>/<i>x</i> + <i>&sigma;</i> (<i>T<sub>a</sub></i><sup>2</sup> +
<i>T<sub>b</sub></i><sup>2</sup>) (<i>T<sub>a</sub></i> + <i>T<sub>b</sub></i>) /
(1/<i>&epsilon;<sub>a</sub></i> + 1/<i>&epsilon;<sub>b</sub></i> &minus; 1).
</p>
<h4>Smoothing</h4>
<ul>
<li>|<i>T<sub>a</sub></i> &minus; <i>T<sub>b</sub></i>| is replaced by
&radic;((<i>T<sub>a</sub></i> &minus; <i>T<sub>b</sub></i>)<sup>2</sup> + 0.01): differentiable when both panes
are at the same temperature.</li>
<li>The branches of Wright's correlation are joined by
<a href=\"modelica://FastSmoothBuildings.Utilities.regStep\">regStep</a> over 100 (Buildings joins them the
same way), the bounds by
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothMax\">smoothMax</a>.</li>
</ul>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.HeatTransfer.Windows.BaseClasses.GasConvection</code> with
<code>convectionVerticalCavity</code> for the convection. Buildings solves the long-wave exchange between the panes
with their radiosities; here it is the closed form above, equal for panes opaque to long-wave radiation.
</p>
<h4>Validation</h4>
<p>
The free-floating BESTEST cases with double glazing: the zone temperatures within 0.38 K of Buildings on average
(0.80 K with a constant gap conductance).
</p>
<h4>References</h4>
<ul>
<li>J. L. Wright (1996). A correlation to quantify convective heat transfer between vertical window glazings.
<i>ASHRAE Transactions</i> 102(1), 940&ndash;946.</li>
<li>ISO 15099:2003. Thermal performance of windows, doors and shading devices &mdash; Detailed calculations.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end gapConductance;
