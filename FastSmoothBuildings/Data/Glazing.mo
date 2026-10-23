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
end Glazing;
