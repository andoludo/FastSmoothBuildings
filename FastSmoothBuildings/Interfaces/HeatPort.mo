within FastSmoothBuildings.Interfaces;
connector HeatPort "Thermal port: temperature and heat flow rate into the component"
  Real T(unit="K") "Port temperature";
  flow Real Q_flow(unit="W") "Heat flow rate into the component";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={191,0,0}, fillColor={191,0,0},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Purpose</h4>
<p>
Thermal port of the library: the temperature of a node and the heat flow rate through the port.
</p>
<table summary=\"Variables of HeatPort\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Variable</th><th>Unit</th><th>Kind</th><th>Meaning</th></tr>
<tr><td><code>T</code></td><td>K</td><td>potential</td><td>Temperature of the port</td></tr>
<tr><td><code>Q_flow</code></td><td>W</td><td>flow</td><td>Heat flow rate into the component, positive when heat
enters it</td></tr>
</table>
<p>
In a connection the temperatures are equal and the heat flow rates sum to zero: the heat that leaves one component
enters the others (see <a href=\"modelica://FastSmoothBuildings.UsersGuide.Conventions\">Conventions</a>).
</p>
<h4>Use</h4>
<p>
The emitters and ideal systems connect to the ports <code>heaPorAir</code> (convective, at the air temperature) and
<code>heaPorRad</code> (radiant) of a zone; the ports <code>con</code> and <code>rad</code> of
<a href=\"modelica://FastSmoothBuildings.Interfaces.SurfaceBus\">SurfaceBus</a> carry the exchanges between a zone
and its surfaces. Same variables and sign as the heat port of the Modelica Standard Library.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Interfaces</code>.</li>
</ul>
</html>"));
end HeatPort;
