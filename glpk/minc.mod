/* Wojciech Kowalik */

param n>0 integer;
set N := {1..n};

var x {N}>=0;

param a {i in N, j in N} := 1/(i+j-1);
param b {i in N} := sum{j in N} 1/(i+j-1);
param c {i in N} := sum{j in N} 1/(i+j-1);

minimize Product: sum{i in N} (c[i]*x[i]);

s.t. Solution{i in N} : sum {j in N} a[i,j]*x[j] = b[i];

solve;
printf "Solution:\n";
printf "[ ";
printf {i in N} "%.3f ", x[i];
printf "]\n";
printf "Error: %.3f", (sqrt(sum{i in N} ((1.0-x[i])*(1.0-x[i])))/sqrt(n));
printf "\n";

/* data */

data;

param n := 8;

end;
