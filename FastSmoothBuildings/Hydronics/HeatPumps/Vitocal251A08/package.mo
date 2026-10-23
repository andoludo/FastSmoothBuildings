within FastSmoothBuildings.Hydronics.HeatPumps;
package Vitocal251A08 "Viessmann Vitocal 251-A08, EN 14511"
  constant Real TSou[9](each unit="K") = {253.15, 258.15, 266.15, 275.15, 280.15, 283.15, 293.15, 303.15, 308.15}
    "Source temperatures (columns)";
  constant Real TCon[5](each unit="K") = {308.15, 318.15, 328.15, 338.15, 343.15} "Condenser outlet (rows)";
  constant Real QHea[5, 9](each unit="W") = {{4490, 5170, 6470, 6790, 8000, 10210, 12330, 12310, 13090},
    {4230, 4900, 6260, 6780, 8370, 9970, 11520, 13040, 12640}, {3780, 4710, 6030, 6830, 8380, 9940, 11500, 13070,
    13110}, {0, 3170, 4610, 6320, 8140, 9550, 11290, 12100, 12180}, {0, 0, 3830, 5560, 7600, 8700, 11290, 12500,
    12590}} "Heating capacity";
  constant Real PEle[5, 9](each unit="W") = {{2128, 2238, 2396, 1835, 1633, 2006, 1720, 1465, 1558},
    {2299, 2402, 2641, 2173, 2244, 2462, 2110, 1734, 1584}, {2305, 2631, 2899, 2493, 2669, 2915, 2556, 2164, 2081},
    {0, 2032, 2478, 2760, 3095, 3375, 3085, 2521, 2511}, {0, 0, 2201, 2699, 3193, 3398, 3330, 2822, 2817}}
    "Electrical power";
  constant Real mCon_flow_nominal(unit="kg/s") = 5600/5/4184 "Nominal condenser flow of the record";
  annotation (Documentation(info="<html>
<p>
Viessmann Vitocal 251-A08 after EN 14511: heating capacity and electrical power against the source temperature and the condenser outlet temperature.
</p>
</html>"));
end Vitocal251A08;
