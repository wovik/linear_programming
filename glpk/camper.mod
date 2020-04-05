/* Wojciech Kowalik */

set Town;
set Campers := {1..4};

param Amount{Town, Campers}, >=0, integer;
param D{Town, Town}, >=0;
var sent1{Town, Town}, >=0;
var sent2{Town, Town}, >=0;
var sent2As1{Town, Town}, >=0;

minimize Cost: sum{from in Town, to in Town} (sent1[from,to]*D[from,to] + sent2[from, to]*D[from,to]*1.15 + sent2As1[from,to]*D[from,to]*1.15);

s.t. AmountDelivered1{t in Town} : Amount[t, 1] = sum{from in Town} (sent1[from, t] + sent2As1[from, t]);
s.t. AmountDelivered2{t in Town} : Amount[t, 2] = sum{from in Town} sent2[from, t];
s.t. AmountSend1{t in Town} : Amount[t, 3] <= sum{to in Town} sent1[t, to] ;
s.t. AmountSend2{t in Town} : Amount[t, 4] <= sum{to in Town} (sent2[t, to] + sent2As1[t,to]);

solve;

display sent1;
display sent2;
display sent2As1;
printf "Cost: %.4f\n", Cost;

data;

set Town := Warszawa Gdansk Szczecin Wroclaw Krakow Berlin Rostock Lipsk Praga Brno Bratyslawa Koszyce Budapeszt;

                    /*  Lack    LackVIP Surp    SurpVIP */
param Amount :          1       2       3       4   :=
    Warszawa            0       4       14      0
    Gdansk              20      0       0       2
    Szczecin            0       0       12      4
    Wroclaw             8       0       0       10
    Krakow              0       8       10      0
    Berlin              16      4       0       0
    Rostock             2       0       0       4
    Lipsk               3       0       0       10
    Praga               0       4       10      0
    Brno                9       0       0       2
    Bratyslawa          4       0       0       8
    Koszyce             4       0       0       4
    Budapeszt           8       0       0       4;

param D :   Warszawa    Gdansk  Szczecin    Wroclaw Krakow  Berlin  Rostock Lipsk   Praga   Brno    Bratyslawa  Koszyce Budapeszt   :=
Warszawa    0           283     454         301     253     516     626     231     517     458     532         231     545
Gdansk      283         0       289         376     486     402     424     317     554     590     698         484     763
Szczecin    454         289     0           307     526     124     174     585     370     491     613         550     731
Wroclaw     301         376     307         0       236     293     467     521     216     215     329         271     427
Krakow      253         486     526         236     0       529     695     473     392     257     295         47      291
Berlin      516         402     124         293     529     0       193     679     279     433     552         562     688
Rostock     626         424     174         467     695     193     0       738     471     625     746         722     878
Lipsk       231         317     585         521     473     679     738     0       736     689     761         441     758
Praga       517         554     370         216     392     279     471     736     0       186     291         438     444
Brno        458         590     491         215     257     433     625     689     186     0       121         305     260
Bratyslawa  532         698     613         329     295     552     746     761     291     121     0           337     161
Koszyce     231         484     550         271     47      562     722     441     438     305     337         0       317
Budapeszt   545         763     731         427     291     688     878     758     444     260     161         317     0;


end;
