param nNode;
param nTruck;
param MaxDistance;
param Distance{i in 1..nNode, j in 1..nNode};
param Weight{i in 1..nNode};

var x{i in 1..nNode, j in 1..nNode, k in 1..nTruck} binary;
var y{i in 1..nNode, k in 1..nTruck} binary;
var u{i in 1..nNode, k in 1..nTruck};


maximize weightedSum:
  sum{i in 1..nNode} Weight[i] * sum{k in 1..nTruck} y[i, k];

subject to noneOrOneIn{i in 1..nNode, k in 1..nTruck}:
  sum{j in 1..nNode} x[i, j, k] = y[i, k];

subject to noneOrOneOut{i in 1..nNode, k in 1..nTruck}:
  sum{j in 1..nNode} x[j, i, k] = y[i, k];

subject to noRepeat {i in 1..nNode, k in 1..nTruck}:
  x[i,i,k] = 0;

subject to routeUpperBound:
  sum{k in 1..nTruck} y[1, k] <= nTruck;

subject to noRepeatRoute{i in 2..nNode}:
    sum{k in 1..nTruck} y[i, k] <= 1;



subject to maxDistance{k in 1..nTruck}:
  sum{i in 1..nNode, j in 1..nNode} Distance[i,j] * x[i,j,k] <= MaxDistance;

subject to nonnegX{i in 1..nNode, j in 1..nNode, k in 1..nTruck}:
  x[i,j,k] >= 0;

subject to nonnegY{i in 1..nNode, k in 1..nTruck}:
  y[i, k] >= 0;

subject to startingNode{k in 1..nTruck}:
  u[1, k] = 1;

subject to u2{i in 2..nNode, k in 1..nTruck}:
  u[i, k] >= 2;

subject to u3{i in 2..nNode, k in 1..nTruck}:
  u[i, k] <= nNode;

subject to noSubtour{i in 2..nNode, j in 2..nNode, k in 1..nTruck}:
  u[i, k] - u[j, k] + 1 <= (nNode) *  (1 - x[i,j, k]);