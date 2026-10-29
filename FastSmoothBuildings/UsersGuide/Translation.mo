within FastSmoothBuildings.UsersGuide;
class Translation "Translation into CasADi"
  extends FastSmoothBuildings.Icons.Information;
  annotation (preferredView="info", Documentation(info="<html>
<p>
<a href=\"https://github.com/CogniPilot/rumoca\">rumoca</a> translates a model of the library into a CasADi function
<i>dx/dt</i> = <i>f</i>(<i>t</i>, <i>x</i>, <i>u</i>, <i>p</i>), the inputs <i>u</i> being the top-level inputs
of the model (weather, gains, controls). From Python, with the package <code>fastsmoothbuildings</code>:
</p>
<pre>
import rumoca
import fastsmoothbuildings

session = rumoca.Session(roots=[str(fastsmoothbuildings.LIBRARY)])
model = session.loads(source, model=\"MyBuilding.building\").to_casadi()
</pre>
<p>
The library keeps to what rumoca translates, and a model built from it has to as well:
</p>
<ul>
<li>the sizes of arrays and the subscripts are evaluated from literal parameters only, not from a sum, a function
or the default of a record: the records of the constructions carry their counts and node indices written out;</li>
<li>the model is an explicit ODE: no algebraic loop that rumoca would have to solve, no event;</li>
<li>every function is smooth (see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Smoothing\">Smoothing</a>),
and conditions on parameters only are evaluated before the translation;</li>
<li>equations carry no description strings;</li>
<li>a table given to <a href=\"modelica://FastSmoothBuildings.Utilities.dayTable\">dayTable</a> is a parameter,
not a literal matrix in the call, and at the top level of a model the call is an equation, not the binding of a
declaration: rumoca 0.10.3 expands the loop of the function into extra equations otherwise (the zones and the
ideal systems of the library call it this way).</li>
</ul>
<p>
The release 0.10.3 of rumoca on PyPI keeps \"residual projection stages\" for five more shapes, which its CasADi
target refuses (<code>residual_equations</code>, <code>initialization</code>); the library avoids them:
</p>
<ul>
<li>in a function, a variable set by an if-expression and used by a later statement: one assignment per function,
as <a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimit\">smoothLimit</a> calls
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimitBelow\">smoothLimitBelow</a> and
<a href=\"modelica://FastSmoothBuildings.Utilities.smoothLimitAbove\">smoothLimitAbove</a>;</li>
<li>in a function, a scalar reassigned in a loop (an accumulation, or a value passed to a smooth function): an array
element per step, or one <code>sum</code>;</li>
<li>in an equation, a smooth function of a smooth function (<code>smoothMin(a, smoothMax(b, c))</code>): the inner
value in a variable of its own;</li>
<li>in a <code>for</code> loop of equations, a derivative multiplied by a coefficient
(<code>C[i]*der(T[i]) = Q[i]</code>): the derivative alone, <code>der(T[i]) = Q[i]/C[i]</code>;</li>
<li>a parameter bound to an if-expression whose branch is more than a name or a literal: the branch in a parameter
of its own.</li>
</ul>
<p>
The library translates with rumoca 0.10.3 from PyPI and with the commit <code>33c21141</code> of its main branch;
the release 0.10.2 does not export connected models to CasADi.
</p>
</html>"));
end Translation;
