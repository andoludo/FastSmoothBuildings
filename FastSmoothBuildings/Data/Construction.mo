within FastSmoothBuildings.Data;
record Construction
  "Opaque construction: layers from the outside (side a) to the inside (side b), each split into nSta[i] sublayers
   of equal thickness (Buildings.HeatTransfer.Data.OpaqueConstructions.Generic and its nSta)"
  parameter Integer nLay "Number of layers";
  parameter Real x[nLay](each unit="m") "Thickness";
  parameter Real k[nLay](each unit="W/(m.K)") "Thermal conductivity";
  parameter Real c[nLay](each unit="J/(kg.K)") "Specific heat capacity";
  parameter Real d[nLay](each unit="kg/m3") "Density";
  // the sublayers are written out, without defaults: rumoca sizes arrays and evaluates subscripts from literal
  // parameters only
  parameter Integer nSta[nLay]
    "Sublayers of each layer: the states Buildings gives it, at most 3 (FastSmoothBuildings); 1, a node at each layer
     boundary (FastSmoothBuildingsMPC, whose states are decision variables of the optimal control)";
  parameter Integer nNod "Number of sublayers, the sum of nSta";
  parameter Integer lay[nNod] "Layer of each sublayer, from the outside";
  parameter Integer nod[nLay + 1] "Node of each layer boundary, from the outside (nod[1] = 1)";
  parameter Integer sub[nNod - nLay] "Nodes inside the layers, from the outside";
  parameter Real absIR_a = 0.84 "Long-wave emissivity of side a (outside)";
  parameter Real absIR_b = 0.84 "Long-wave emissivity of side b (inside)";
  parameter Real absSol_a = 0.84 "Solar absorptance of side a (outside)";
  parameter Real absSol_b = 0.84 "Solar absorptance of side b (inside)";
end Construction;
