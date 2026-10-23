within FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08;
function interpolate "Linear interpolation in the table, as CombiTable2Ds (rows: condenser, columns: source)"
  input Real TConOut(unit="K");
  input Real TSource(unit="K");
  input Boolean heating "true: heating capacity, false: electrical power";
  output Real y;
protected
  Real row[5] "Values of each row at the source temperature";
  Real w;
algorithm
  for r in 1:5 loop
    row[r] := if heating then QHea[r, 1] else PEle[r, 1];
    for j in 1:8 loop
      if TSource > TSou[j] then
        w := min((TSource - TSou[j])/(TSou[j + 1] - TSou[j]), 1);
        row[r] := if heating then QHea[r, j] + w*(QHea[r, j + 1] - QHea[r, j]) else PEle[r, j]
          + w*(PEle[r, j + 1] - PEle[r, j]);
      end if;
    end for;
  end for;
  y := row[1];
  for r in 1:4 loop
    if TConOut > TCon[r] then
      w := min((TConOut - TCon[r])/(TCon[r + 1] - TCon[r]), 1);
      y := row[r] + w*(row[r + 1] - row[r]);
    end if;
  end for;
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Heating capacity (<code>heating = true</code>) or electrical power of the Vitocal 251-A08 at a condenser outlet
temperature and a source temperature, by linear interpolation in the table: first along the source temperature
<code>TSou</code> in each row, then along the condenser outlet temperature <code>TCon</code> between the rows.
Beyond the first and last breakpoints of either axis the value is held at the edge of the table.
</p>
<h4>Use</h4>
<p>
The value of the table at design conditions, for the scaling <code>scaFac</code> of
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPump\">HeatPump</a>. It is evaluated from parameters only;
the model itself uses the differentiable
<a href=\"modelica://FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08.smoothTable\">smoothTable</a>.
</p>
<h4>Relation to Buildings</h4>
<p>
Within the table, the linear interpolation of <code>CombiTable2Ds</code> (rows: condenser, columns: source).
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Hydronics.HeatPumps.Vitocal251A08</code>.</li>
</ul>
</html>"));
end interpolate;
