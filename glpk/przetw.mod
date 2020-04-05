/* Wojciech Kowalik */

var A >=0;
var B >=0;
var C >=0;
var D >=0;

/* surowce */

var s1, >=2000, <=6000;
var s2, >=3000, <=5000;
var s3, >=4000, <=7000;

var s1A, >=0;
var s1B, >=0;
var s1C, >=0;
s.t. sur1:  s1 = s1A + s1B + s1C;
s.t. sur1A: s1A >= 0.2*A;
s.t. sur1B: s1B >= 0.1*B;
s.t. sur1C: s1C = 0.2*C;

var s2A, >=0;
var s2B, >=0;
var s2D, >=0;
s.t. sur2:  s2 = s2A + s2B + s2D;
s.t. sur2A: s2A >= 0.4*A;
s.t. sur2D: s2D = 0.3*D;

var s3A, >=0;
var s3B, >=0;
s.t. sur3:  s3 = s3A + s3B;
s.t. sur3A: s3A <= 0.1*A;
s.t. sur3B: s3B <= 0.3*B;

/* straty */

var str1AtoC, >=0;
var lik1A, >=0;
s.t. lik_1: 0.1*s1A = str1AtoC + lik1A;

var str2AtoC, >=0;
var lik2A, >=0;
s.t. lik_2: 0.2*s2A = str2AtoC + lik2A;

var str3AtoC, >=0;
var lik3A, >=0;
s.t. lik_3: 0.4*s3A = str3AtoC + lik3A;

var str1BtoD, >=0;
var lik1B, >=0;
s.t. lik_4: 0.2*s1B = str1BtoD + lik1B;

var str2BtoD, >=0;
var lik2B, >=0;
s.t. lik_5: 0.2*s2B = str2BtoD + lik2B;

var str3BtoD, >=0;
var lik3B, >=0;
s.t. lik_6: 0.5*s3B = str3BtoD + lik3B;

/* produkty */

s.t. pA: A = s1A + s2A + s3A;
s.t. pB: B = s1B + s2B + s3B;
s.t. pC: C = s1C + str1AtoC + str2AtoC + str3AtoC;
s.t. pD: D = s2D + str1BtoD + str2BtoD + str3BtoD;

maximize Profit: (3*(0.9*s1A + 0.8*s2A + 0.6*s3A) + 2.5*(0.8*s1B + 0.8*s2B + 0.5*s3B) + 0.6*C + 0.5*D) - (s1*2.1 + s2*1.6 + s3*1.0) - (lik1A*0.1 + lik2A*0.2 + lik3A*0.3 + lik1B*0.05 + lik2B*0.05 + lik3B*0.4);

solve;


printf "profit: %.4f\n", Profit;
printf "s1: %.2f, s2: %.2f, s3: %.2f\n", s1, s2, s3;
printf "s1A: %.2f, s2A: %.2f, s3A: %.2f\n", s1A, s2A, s3A;
printf "s1B: %.2f, s2B: %.2f, s3B: %.2f\n", s1B, s2B, s3B;
printf "s1C: %.2f, s2D: %.2f\n", s1C, s2D;
printf "str1AtoC: %.2f, str2AtoC: %.2f, str3AtoC: %.2f\n", str1AtoC, str2AtoC, str3AtoC;
printf "str1BtoD: %.2f, str2BtoD: %.2f, str3BtoD: %.2f\n", str1BtoD, str2BtoD, str3BtoD;
printf "lik1A: %.2f, lik2A: %.2f, lik3A: %.2f\n", lik1A, lik2A, lik3A;
printf "lik1B: %.2f, lik2B: %.2f, lik3B: %.2f\n", lik1B, lik2B, lik3B;

end;
