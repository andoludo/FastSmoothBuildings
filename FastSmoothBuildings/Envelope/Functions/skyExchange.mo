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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Long-wave heat flow rate from an outer surface to sky and ground, for
<a href=\"modelica://FastSmoothBuildings.Envelope.OuterWall\">OuterWall</a> and
<a href=\"modelica://FastSmoothBuildings.Envelope.Window\">Window</a>.
</p>
<h4>Equations</h4>
<p>
With the sky view factor <i>F</i> = (&pi; &minus; <code>til</code>)/&pi; (1 for a roof, 1/2 for a wall), the
environment temperature
</p>
<p>
<i>T<sub>env</sub></i> = (<i>F</i> <i>T<sub>sky</sub></i><sup>4</sup> + (1 &minus; <i>F</i>)
<i>T<sub>out</sub></i><sup>4</sup>)<sup>1/4</sup>,
</p>
<p>
the ground being at the outdoor air temperature, and the exact grey-body exchange
</p>
<p>
<i>Q</i> = <i>&sigma;</i> <i>&epsilon;</i> <i>A</i> (<i>T</i><sup>4</sup> &minus; <i>T<sub>env</sub></i><sup>4</sup>)
= <i>&sigma;</i> <i>&epsilon;</i> <i>A</i> (<i>T</i><sup>2</sup> + <i>T<sub>env</sub></i><sup>2</sup>)
(<i>T</i> + <i>T<sub>env</sub></i>) (<i>T</i> &minus; <i>T<sub>env</sub></i>),
</p>
<p>
written as the second form, a conductance times the temperature difference. A linearisation at
<i>T<sub>env</sub></i> understates the loss of a sun-lit surface at 60 &deg;C by a quarter.
</p>
<h4>Relation to Buildings</h4>
<p>
The view factor and the environment temperature of Buildings' <code>SkyRadiationExchange</code>.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Envelope.Functions</code>.</li>
</ul>
</html>"));
end skyExchange;
