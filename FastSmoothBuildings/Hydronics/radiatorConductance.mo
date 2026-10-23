within FastSmoothBuildings.Hydronics;
function radiatorConductance
  "UAEle of Buildings RadiatorEN442_2: the conductance of each element giving the nominal power (bisections)"
  input Real Q_flow_nominal(unit="W");
  input Real T_a_nominal(unit="K");
  input Real T_b_nominal(unit="K");
  input Real TAir_nominal(unit="K");
  input Real TRad_nominal(unit="K");
  input Real fraRad;
  input Real n;
  input Integer nEle;
  output Real UAEle(unit="W/K");
protected
  Real m_flow;
  Real UALow;
  Real UAHigh;
  Real TUp;
  Real TLow;
  Real THigh;
  Real TWat;
  Real Q;
  Real QEle;
  Real residual;
algorithm
  m_flow := Q_flow_nominal/cpWat/(T_a_nominal - T_b_nominal);
  UAEle := Q_flow_nominal/((T_a_nominal + T_b_nominal)/2 - ((1 - fraRad)*TAir_nominal + fraRad*TRad_nominal))^n/nEle;
  UALow := UAEle/10;
  UAHigh := UAEle*10;
  for iteration in 1:80 loop
    UAEle := (UALow + UAHigh)/2;
    // power of the radiator: the water of each element is at the temperature it leaves with
    TUp := T_a_nominal;
    Q := 0;
    for i in 1:nEle loop
      TLow := min(TAir_nominal, TRad_nominal);
      THigh := TUp;
      for k in 1:80 loop
        TWat := (TLow + THigh)/2;
        QEle := UAEle*(fraRad*max(TWat - TRad_nominal, 0)^n + (1 - fraRad)*max(TWat - TAir_nominal, 0)^n);
        residual := TWat - TUp + QEle/m_flow/cpWat;
        if residual > 0 then
          THigh := TWat;
        else
          TLow := TWat;
        end if;
      end for;
      Q := Q + UAEle*(fraRad*max(TWat - TRad_nominal, 0)^n + (1 - fraRad)*max(TWat - TAir_nominal, 0)^n);
      TUp := TWat;
    end for;
    if Q > Q_flow_nominal then
      UAHigh := UAEle;
    else
      UALow := UAEle;
    end if;
  end for;
end radiatorConductance;
