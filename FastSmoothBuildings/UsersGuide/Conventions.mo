within FastSmoothBuildings.UsersGuide;
class Conventions "Conventions"
  extends FastSmoothBuildings.Icons.Information;
  annotation (preferredView="info", Documentation(info="<html>
<h4>Units and signs</h4>
<ul>
<li>SI units throughout; temperatures in kelvin.</li>
<li>A heat port carries the temperature of its node and the heat flow rate <i>into</i> the component.</li>
<li>A water port carries the mass flow rate into the component (negative when the water leaves), the temperature of
the water crossing it, set by the component the water leaves, and the pressure of the inlet node of the component
downstream (0 with set flows).</li>
<li>An air port of the ventilation carries the mass flow rate into the component, the temperature of the air
crossing it and the relative speed of the fan that moves it.</li>
<li>Internal gains are given per floor area (W/m<sup>2</sup>), split into a convective and a radiant part.</li>
</ul>
<h4>Geometry</h4>
<ul>
<li>Azimuth of a surface: 0 facing south, &pi;/2 facing west.</li>
<li>Tilt: 0 for a roof or a ceiling (the surface faces up),
&pi;/2 for a wall, &pi; for a floor (see <a href=\"modelica://FastSmoothBuildings.Types.Tilt\">Types.Tilt</a>).</li>
<li>Side <i>a</i> of a construction is the outside, side <i>b</i> the room; the layers of a construction and the
panes of a glazing are given from the outside.</li>
</ul>
<h4>Constructions and states</h4>
<p>
Each layer of an opaque construction is split into <code>nSta</code> sublayers of equal thickness, with a node at
each sublayer boundary. The temperatures of the layer boundaries are <code>T</code>, those of the nodes inside the
layers <code>TSub</code>. A model for optimal control uses one sublayer per layer (no <code>TSub</code>); a
closed-loop model up to three, as Buildings: a state copied from one model into the other by its name stays at its
place.
</p>
<p>
The records <a href=\"modelica://FastSmoothBuildings.Data.Construction\">Data.Construction</a> and
<a href=\"modelica://FastSmoothBuildings.Data.Glazing\">Data.Glazing</a> carry the counts of layers, sublayers and
panes, and the indices of the nodes, written out (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>).
</p>
<h4>Water circuits</h4>
<p>
Every component of <a href=\"modelica://FastSmoothBuildings.Hydronics\">Hydronics</a> has the evaluated parameter
<code>pressureDriven</code>:
</p>
<ul>
<li><code>false</code> (set flows): each valve sets the flow of its branch and the production closes the balance;
the model of optimal control;</li>
<li><code>true</code> (pressure-driven flows): a pressure node at the inlet of every component, the flow of every
outlet from its conductance, the pumps on their curves, as the linearized circuits of Buildings; the closed-loop
model.</li>
</ul>
</html>"));
end Conventions;
