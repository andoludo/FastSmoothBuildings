within FastSmoothBuildings;
package Examples "Examples: rooms, water circuits, ventilation and ideal systems"
  extends FastSmoothBuildings.Icons.ExamplesPackage;
  annotation (Documentation(info="<html>
<p>
Buildings and systems assembled from the classes of the library, simulated over clear winter days
(<a href=\"modelica://FastSmoothBuildings.Examples.BaseClasses.SyntheticWeather\">SyntheticWeather</a>). Each
example is a closed model: OpenModelica simulates it, rumoca translates it into CasADi, and the tests of the
repository compare both with reference results.
</p>
</html>"));
end Examples;
