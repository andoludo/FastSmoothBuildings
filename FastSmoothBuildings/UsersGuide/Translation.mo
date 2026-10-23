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
<li>equations carry no description strings.</li>
</ul>
<p>
rumoca 0.10.3 from the commit <code>33c21141</code> of its main branch exports connected models to CasADi; the
release 0.10.2 on PyPI does not.
</p>
</html>"));
end Translation;
