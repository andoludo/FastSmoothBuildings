within FastSmoothBuildings.Envelope.Functions;
function skyExchange "Long-wave exchange with sky and ground (Buildings SkyRadiationExchange)"
  input Real T(unit="K") "Surface temperature";
  input Real A(unit="m2");
  input Real til(unit="rad");
  input Real eps "Long-wave emissivity";
  input Real TOut(unit="K");
  input Real TBlaSky(unit="K");
  output Real Q_flow(unit="W") "Heat from the surface";
protected
  Real vieFacSky = (pi - til)/pi;
  Real TEnv;
algorithm
  TEnv := (vieFacSky*TBlaSky^4 + (1 - vieFacSky)*TOut^4)^0.25;
  // exact grey-body exchange with the environment, sigma*eps*A*(T^4 - TEnv^4), written as a conductance times
  // the temperature difference: a sun-lit surface at 60 degC loses a quarter more than the linearisation at TEnv
  Q_flow := sigma*eps*A*(T^2 + TEnv^2)*(T + TEnv)*(T - TEnv);
end skyExchange;
