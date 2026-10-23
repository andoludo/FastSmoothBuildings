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
  annotation (Documentation(info="<html>
<h4>Purpose</h4>
<p>
Linear interpolation in a day table, without the events of a table: rows [time of day (s), value], the time
increasing, evaluated at the time of day <code>tod</code>, typically
<a href=\"modelica://FastSmoothBuildings.Utilities.timeOfDay\">timeOfDay</a>(<code>time</code>).
</p>
<h4>Equations</h4>
<p>
With the rows (<i>t<sub>i</sub></i>, <i>v<sub>i</sub></i>), <i>i</i> = 1 &hellip; <i>n</i>:
</p>
<ul>
<li><i>y</i> = <i>v<sub>1</sub></i> up to <i>t<sub>1</sub></i>;</li>
<li>between <i>t<sub>i</sub></i> and <i>t<sub>i+1</sub></i>, the linear interpolation of <i>v<sub>i</sub></i>
and <i>v<sub>i+1</sub></i>; where the table repeats an instant, the denominator is bounded by 10<sup>&minus;6</sup> s:
a step;</li>
<li>after <i>t<sub>n</sub></i>, a linear return from <i>v<sub>n</sub></i> to <i>v<sub>1</sub></i>, reached at
<i>t<sub>1</sub></i> + 86400 s.</li>
</ul>
<p>
The result is continuous and piecewise linear (C0) apart from the repeated instants, and continuous across
midnight when <i>t<sub>1</sub></i> = 0. A table of one row is a constant.
</p>
<h4>Use</h4>
<p>
The table is a parameter, not a literal matrix in the call, and at the top level of a model the call is an
equation, not the binding of a declaration (see
<a href=\"modelica://FastSmoothBuildings.UsersGuide.Translation\">Translation into CasADi</a>). The zones read
their ventilation schedule with it.
</p>
</html>", revisions="<html>
<ul>
<li>October 2026: moved from trano's <code>FastModel.Utilities</code>.</li>
</ul>
</html>"));
end dayTable;
