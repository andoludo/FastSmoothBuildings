within FastSmoothBuildings;
package UsersGuide "User's Guide"
  extends FastSmoothBuildings.Icons.Information;
  annotation (preferredView="info", Documentation(info="<html>
<p>
FastSmoothBuildings models a building and its systems as one explicit ordinary differential equation
<i>dx/dt</i> = <i>f</i>(<i>t</i>, <i>x</i>, <i>u</i>, <i>p</i>), smooth in its states, inputs and parameters.
The same classes give two models of a building:
</p>
<ul>
<li>a <b>closed-loop model</b>, with the controllers of the library and pressure-driven water circuits, to simulate
the building as Buildings would, and to calibrate it on measurements;</li>
<li>a <b>model for optimal control</b>, with the controls of the systems (valve openings, pump speeds, compressor
and burner loads) as inputs and set flows in the water circuits, that rumoca translates into CasADi for model
predictive control and state estimation.</li>
</ul>
<p>
The pages of this guide:
</p>
<ul>
<li><a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>: units, signs, geometry,
constructions and the names of the states;</li>
<li><a href=\"modelica://FastSmoothBuildings.UsersGuide.Smoothing\">Smoothing</a>: how switches, limits and
schedules stay differentiable;</li>
<li><a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>: what keeps a model
translatable by rumoca;</li>
<li><a href=\"modelica://FastSmoothBuildings.UsersGuide.ReleaseNotes\">Release notes</a>,
<a href=\"modelica://FastSmoothBuildings.UsersGuide.License\">License</a>,
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Contact\">Contact</a>.</li>
</ul>
</html>"));
end UsersGuide;
