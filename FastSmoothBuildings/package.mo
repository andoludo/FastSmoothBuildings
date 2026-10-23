within ;
package FastSmoothBuildings "Building models for model predictive control: close to Buildings, translated into an explicit CasADi ODE"
  extends FastSmoothBuildings.Icons.Package;

  constant Real pi = 3.141592653589793;
  constant Real sigma(unit="W/(m2.K4)") = 5.670374419e-8 "Stefan-Boltzmann constant";
  constant Real cpWat(unit="J/(kg.K)") = 4184 "Specific heat capacity of water (Buildings.Media.Water)";
  constant Real rhoWat(unit="kg/m3") = 995.586 "Density of water (Buildings.Media.Water)";
  constant Real cpAir(unit="J/(kg.K)") = 1006 "Specific heat capacity of air";
  constant Real rhoAir(unit="kg/m3") = 1.2 "Density of air";
  constant Real RAir(unit="J/(kg.K)") = 287.0512 "Gas constant of dry air (Buildings.Media.Air)";
  annotation (
    version="0.4.0",
    versionDate="2026-10-23",
    preferredView="info",
    Documentation(info="<html>
<p>
FastSmoothBuildings models buildings and their heating, cooling and ventilation systems as smooth, event-free
explicit ordinary differential equations: close to the
<a href=\"https://github.com/lbl-srg/modelica-buildings\">Modelica Buildings library</a> in closed loop, and
translated by <a href=\"https://github.com/CogniPilot/rumoca\">rumoca</a> into a
<a href=\"https://web.casadi.org\">CasADi</a> model for model predictive control, state estimation and
calibration.
</p>
<p>
Start with the <a href=\"modelica://FastSmoothBuildings.UsersGuide\">User's Guide</a> and the
<a href=\"modelica://FastSmoothBuildings.Examples\">Examples</a>.
</p>
</html>"));
end FastSmoothBuildings;
