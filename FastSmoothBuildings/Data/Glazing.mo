within FastSmoothBuildings.Data;
record Glazing
  "Glazing: panes and gas gaps from the outside (Buildings.HeatTransfer.Data.GlazingSystems.Generic), angular
   optics at the incidence angles 0, 10, ..., 90 degrees"
  parameter Integer nPan "Number of panes";
  parameter Real x[nPan](each unit="m") "Thickness of the panes";
  parameter Real k[nPan](each unit="W/(m.K)") "Thermal conductivity of the panes";
  parameter Real d[nPan](each unit="kg/m3") "Density of the panes";
  parameter Real c[nPan](each unit="J/(kg.K)") "Specific heat capacity of the panes";
  parameter Real xGas[nPan - 1](each unit="m") "Thickness of each gas gap";
  parameter Real kGas[nPan - 1](each unit="W/(m.K)") "Thermal conductivity of the gas of each gap";
  parameter Real muGas_a[nPan - 1](each unit="Pa.s") "Dynamic viscosity of the gas: a_mu + b_mu*T";
  parameter Real muGas_b[nPan - 1](each unit="Pa.s/K") "Dynamic viscosity of the gas: a_mu + b_mu*T";
  parameter Real cGas[nPan - 1](each unit="J/(kg.K)") "Specific heat capacity of the gas";
  parameter Real MGas[nPan - 1](each unit="kg/mol") "Molar mass of the gas";
  parameter Real epsGap_a[nPan - 1] "Long-wave emissivity of the pane face on the outer side of each gap";
  parameter Real epsGap_b[nPan - 1] "Long-wave emissivity of the pane face on the inner side of each gap";
  parameter Real tau[11] "Solar transmittance at the 10 incidence angles, then hemispherical";
  parameter Real absPan[nPan, 11] "Solar absorptance of each pane at the 10 incidence angles, then hemispherical";
  parameter Real absIR_a "Long-wave emissivity of the outer pane, outside face";
  parameter Real absIR_b "Long-wave emissivity of the inner pane, room face";
  parameter Real UFra(unit="W/(m2.K)") = 1.4 "Thermal transmittance of the frame";
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
A glazing: its panes and the gas gaps between them, from the outside, and its angular optics, for
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a>.
</p>
<h4>Fields</h4>
<table summary=\"Fields of Glazing\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Field</th><th>Meaning</th></tr>
<tr><td><code>nPan</code></td><td>number of panes; there are <code>nPan</code> &minus; 1 gaps</td></tr>
<tr><td><code>x</code>, <code>k</code>, <code>d</code>, <code>c</code></td>
<td>thickness, thermal conductivity, density and specific heat capacity of each pane (the window takes its
<code>cGla</code> for a <code>c</code> of 0)</td></tr>
<tr><td><code>xGas</code></td><td>thickness of each gap</td></tr>
<tr><td><code>kGas</code>, <code>cGas</code>, <code>MGas</code></td>
<td>thermal conductivity, specific heat capacity and molar mass of the gas of each gap</td></tr>
<tr><td><code>muGas_a</code>, <code>muGas_b</code></td>
<td>dynamic viscosity of the gas, <i>&mu;</i> = <i>&mu;<sub>a</sub></i> + <i>&mu;<sub>b</sub></i> <i>T</i></td></tr>
<tr><td><code>epsGap_a</code>, <code>epsGap_b</code></td>
<td>long-wave emissivity of the pane faces on the outer and on the inner side of each gap</td></tr>
<tr><td><code>tau[11]</code></td><td>solar transmittance of the glazing at the incidence angles 0, 10, ..., 90&deg;,
then the hemispherical value</td></tr>
<tr><td><code>absPan[nPan, 11]</code></td><td>solar absorptance of each pane, at the same angles, then
hemispherical</td></tr>
<tr><td><code>absIR_a</code>, <code>absIR_b</code></td>
<td>long-wave emissivity of the outer face of the outer pane and of the room face of the inner pane</td></tr>
<tr><td><code>UFra</code></td><td>thermal transmittance of the frame</td></tr>
</table>
<p>
The record carries the data of the gas, not resistances: the window computes the conductance of each gap at the
temperatures of its panes
(<a href=\"modelica://FastSmoothBuildings.Envelope.Functions.gapConductance\">gapConductance</a>). A single glazing
has <code>nPan = 1</code> and empty gap arrays.
</p>
<h4>Relation to Buildings</h4>
<p>
<code>Buildings.HeatTransfer.Data.GlazingSystems.Generic</code>.
</p>
<h4>Use</h4>
<p>
<a href=\"modelica://FastSmoothBuildings.Examples.Constructions.DoubleClear\">Examples.Constructions.DoubleClear</a>
and <a href=\"modelica://FastSmoothBuildings.Examples.Constructions.TripleArgon\">TripleArgon</a>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Data</code>.</li>
</ul>
</html>"));
end Glazing;
