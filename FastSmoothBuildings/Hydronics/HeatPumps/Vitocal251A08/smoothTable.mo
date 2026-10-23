within FastSmoothBuildings.Hydronics.HeatPumps.Vitocal251A08;
function smoothTable
  "Quadratic in the condenser temperature through the rows at 35, 45 and 55 degC, linear between the source
   columns with the kinks smoothed over dTSou: a differentiable version of the table"
  input Real TConOut(unit="K");
  input Real TSource(unit="K");
  input Boolean heating "true: heating capacity, false: electrical power";
  input Real dTSou(unit="K") = 1 "Smoothing of the kinks of the interpolation in the source temperature";
  output Real y;
protected
  Real v[9] "Value at each source temperature";
  Real L[3] "Lagrange basis in the condenser temperature";
algorithm
  L[1] := (TConOut - TCon[2])*(TConOut - TCon[3])/((TCon[1] - TCon[2])*(TCon[1] - TCon[3]));
  L[2] := (TConOut - TCon[1])*(TConOut - TCon[3])/((TCon[2] - TCon[1])*(TCon[2] - TCon[3]));
  L[3] := (TConOut - TCon[1])*(TConOut - TCon[2])/((TCon[3] - TCon[1])*(TCon[3] - TCon[2]));
  for j in 1:9 loop
    v[j] := if heating then L[1]*QHea[1, j] + L[2]*QHea[2, j] + L[3]*QHea[3, j] else L[1]*PEle[1, j]
      + L[2]*PEle[2, j] + L[3]*PEle[3, j];
  end for;
  y := v[1] + (v[2] - v[1])/(TSou[2] - TSou[1])*(TSource - TSou[1]);
  for i in 2:8 loop
    y := y + ((v[i + 1] - v[i])/(TSou[i + 1] - TSou[i]) - (v[i] - v[i - 1])/(TSou[i] - TSou[i - 1]))
      *Utilities.positivePart(TSource - TSou[i], dTSou);
  end for;
end smoothTable;
