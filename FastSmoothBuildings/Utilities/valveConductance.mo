within FastSmoothBuildings.Utilities;
function valveConductance
  "Conductance m_flow/dp of a valve with a fixed resistance in series, its flow law linearized as Buildings does
   (linearized=true): m_flow*m_flow_nominal = k^2*dp, 1/k^2 = 1/kFixed^2 + 1/(phi*Kv)^2"
  input Real phi "Valve characteristic";
  input Real m_flow_nominal(unit="kg/s");
  input Real dpValve_nominal(unit="Pa");
  input Real dpFixed_nominal(unit="Pa");
  output Real G(unit="kg/(s.Pa)");
algorithm
  G := 1/(m_flow_nominal*(dpFixed_nominal/m_flow_nominal^2 + dpValve_nominal/(phi*m_flow_nominal)^2));
end valveConductance;
