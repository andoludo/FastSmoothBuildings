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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Conductance <code>UAEle</code> of each element of a
<a href=\"modelica://FastSmoothBuildings.Hydronics.Radiator\">Radiator</a> such that the radiator gives
<code>Q_flow_nominal</code> at its nominal temperatures and flow.
</p>
<h4>Algorithm</h4>
<p>
The nominal flow is <i>m&#775;</i> = <code>Q_flow_nominal</code> / (<i>c<sub>p</sub></i>
(<code>T_a_nominal</code> &minus; <code>T_b_nominal</code>)). Starting from the conductance of a single element at
the mean water temperature,
</p>
<p>
<i>UA<sub>0</sub></i> = <code>Q_flow_nominal</code> / (((<code>T_a_nominal</code> + <code>T_b_nominal</code>)/2
&minus; ((1 &minus; <i>f</i>) <code>TAir_nominal</code> + <i>f</i> <code>TRad_nominal</code>))<sup><i>n</i></sup>
<code>nEle</code>),
</p>
<p>
80 bisections on [<i>UA<sub>0</sub></i>/10, 10 <i>UA<sub>0</sub></i>] find the conductance at which the
<code>nEle</code> elements in series give <code>Q_flow_nominal</code>. For a given conductance, the water of each
element is at the temperature <i>T<sub>w</sub></i> it leaves with, solved by 80 bisections between
min(<code>TAir_nominal</code>, <code>TRad_nominal</code>) and the temperature of the water entering it:
</p>
<p>
<i>T<sub>w</sub></i> = <i>T<sub>up</sub></i> &minus; <i>Q<sub>ele</sub></i>(<i>T<sub>w</sub></i>) /
(<i>m&#775;</i> <i>c<sub>p</sub></i>), &nbsp;
<i>Q<sub>ele</sub></i> = <i>UA</i> (<i>f</i> max(<i>T<sub>w</sub></i> &minus; <code>TRad_nominal</code>,
0)<sup><i>n</i></sup> + (1 &minus; <i>f</i>) max(<i>T<sub>w</sub></i> &minus; <code>TAir_nominal</code>,
0)<sup><i>n</i></sup>),
</p>
<p>
with <i>f</i> = <code>fraRad</code>, and the water leaving one element enters the next.
</p>
<h4>Relation to Buildings</h4>
<p>
The parameter <code>UAEle</code> of <code>Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</code>.
</p>
<h4>Use</h4>
<p>
Called in the binding of the parameter <code>UAEle</code> of
<a href=\"modelica://FastSmoothBuildings.Hydronics.Radiator\">Radiator</a>. It depends on parameters only, so its
branches and its <code>max</code> cause no event in the model.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics</code>.</li>
</ul>
</html>"));
end radiatorConductance;
