within FastSmoothBuildings.Utilities;
function dayTable "Linear interpolation in a day table [time of day (s), value], repeated daily"
  input Real tod(unit="s");
  input Real table[:, 2];
  output Real y;
protected
  Integer n = size(table, 1);
  Real w;
algorithm
  y := table[1, 2];
  for i in 1:n - 1 loop
    if tod > table[i, 1] then
      w := min((tod - table[i, 1])/max(table[i + 1, 1] - table[i, 1], 1e-6), 1);
      y := table[i, 2] + w*(table[i + 1, 2] - table[i, 2]);
    end if;
  end for;
  if n > 1 and tod > table[n, 1] then
    y := table[n, 2] + (tod - table[n, 1])/(86400 + table[1, 1] - table[n, 1])*(table[1, 2] - table[n, 2]);
  end if;
end dayTable;
