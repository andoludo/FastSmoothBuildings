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
end interpolate;
