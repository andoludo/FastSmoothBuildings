within FastSmoothBuildings.Utilities;
function quadraticFlow
  "Flow through a quadratic resistance (m_flow_nominal at dp_nominal), regularized below deltaM*m_flow_nominal"
  input Real dp(unit="Pa");
  input Real m_flow_nominal(unit="kg/s");
  input Real dp_nominal(unit="Pa");
  input Real deltaM = 0.1;
  output Real m_flow(unit="kg/s");
algorithm
  m_flow := m_flow_nominal/sqrt(dp_nominal)*dp/(dp^2 + (deltaM^2*dp_nominal)^2)^0.25;
end quadraticFlow;
