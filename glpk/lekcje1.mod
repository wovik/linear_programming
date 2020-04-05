/* Wojciech Kowalik */

set Lekcje;
param start{Lekcje, {1..4}};
param end  {Lekcje, {1..4}};
param pref {Lekcje, {1..4}}, integer;
param days {Lekcje, {1..4}}, integer;

var choice {Lekcje, {1..4}}, binary;
s.t. one{l in Lekcje}: 1 = sum{i in {1..4}} choice[l, i];

s.t. time{d in 1..5,t in 0..47}:
    sum{l in Lekcje, i in 1..4: days[l,i] = d && start[l,i] <= t/2 && end[l,i] > t/2} choice[l,i] <= 1;

/* trening */

var tr{1..3}, binary;
s.t. ilTr: sum{i in 1..3} tr[i] >= 1;
s.t. time1{t in 26..29}: tr[1] + sum{l in Lekcje, i in 1..4: days[l,i] = 1 && start[l,i] <= t/2 && end[l,i] > t/2} choice[l,i] <= 1;           /* 1 trening */
s.t. time2{t in 22..25}: tr[2] + sum{l in Lekcje, i in 1..4: days[l,i] = 3 && start[l,i] <= t/2 && end[l,i] > t/2} choice[l,i] <= 1;           /* 2 trening */
s.t. time3{t in 26..29}: tr[3] + sum{l in Lekcje, i in 1..4: days[l,i] = 3 && start[l,i] <= t/2 && end[l,i] > t/2} choice[l,i] <= 1;           /* 3 trening */

/* 4 godziny ćwiczeń */

s.t. cwicz{d in 1..5}: sum{l in Lekcje, i in 1..4: days[l,i] = d} choice[l,i]*(end[l,i] - start[l,i]) <= 4;

/* przerwa na jedzenie */

s.t. prz{d in {2,4,5}}: sum{l in Lekcje, i in 1..4, t in 24..26: days[l,i] = d && start[l,i] <= t/2 && end[l,i] > t/2+1} choice[l,i] <= 1;
s.t. prz1: tr[1] + sum{l in Lekcje, i in 1..4, t in 24..26: days[l,i] = 1 && start[l,i] <= t/2 && end[l,i] > t/2+1} choice[l,i] <= 1;
s.t. prz3: tr[2] + tr[3] + sum{l in Lekcje, i in 1..4, t in 24..26: days[l,i] = 1 && start[l,i] <= t/2 && end[l,i] > t/2+1} choice[l,i] <= 1;


maximize Pref: sum{l in Lekcje, i in {1..4}} (choice[l,i]*pref[l,i]);

solve;

display choice;
display tr;
display Pref;

data;

set Lekcje := Alg Ana Fiz Chm Cho;

param start:    1       2       3       4   :=
    Alg         13      10      10      11
    Ana         13      10      11      8
    Fiz         8       10      15      17
    Chm         8       8       13      13
    Cho         9       10.5    11      13;

param end  :    1       2       3       4   :=
    Alg         15      12      12      13
    Ana         15      12      13      10
    Fiz         11      13      18      20
    Chm         10      10      15      15
    Cho         10.5    12      12.5    14.5;

param pref :    1       2       3       4   :=
    Alg         5       4       10      5
    Ana         4       4       5       6
    Fiz         3       5       7       8
    Chm         10      10      7       5
    Cho         0       5       3       4;

param days :    1       2       3       4   :=
    Alg         1       2       3       3
    Ana         1       2       3       4
    Fiz         2       2       4       4
    Chm         1       1       4       5
    Cho         1       1       5       5;



end;
