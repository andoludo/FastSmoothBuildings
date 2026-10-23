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
end gapConductance;
