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
end FastSmoothBuildings;
