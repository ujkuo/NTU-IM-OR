param S; #shift i:14 kinds
param T; #time period j:24 `ours
param D; #day k:31 days
param I; #csr h:40 csrs

#demand matrix: pth period for day j-----------------------------------------------------------
param Demand{j in 1..T, k in 1..D}; 

#shift arrangement: pth period and kth shift---------------------------------------------------
param C{j in 1..T, i in 1..S}; 



#difference between CSRs on shift: kth shift pth period----------------------------------------
var x{i in 1..S, k in 1..D, h in 1..40}binary;
#difference between shift assignment and day: ith CSR, jth day, kth shift
var w{j in 1..T, k in 1..D}; #difference between demand and supply

#minimize labor shortage ij--------------------------------------------------------------------
minimize labor_shortage:sum{j in 1..T, k in 1..D}w[j,k];



#constraints-----------------------------------------------------------------------------------
# w_jk constraint
subject to w_nonneg1{j in 1..T, k in 1..D}:w[j,k] >= Demand[j,k]-sum{i in 1..S}(C[j,i]*sum{h in 1..I}x[i,k,h]);
subject to w_nonneg2{j in 1..T, k in 1..D}:w[j,k] >= 0;

#every csr is assigned to one shift
subject to p_1{k in 1..D, h in 1..I}:sum{i in 1..S}x[i,k,h] == 1;
#every csr needs eight day-off
subject to shift_0{h in 1..I}: sum{k in 1..D}x[14,k,h] == 8; 


#manager limits
subject to 1{k in {1,15,29}}: sum{h in 14..16, i in 11..13}x[i,k,h]+sum{h in 34..40, i in 11..13}x[i,k,h]>=1;
subject to 2{k in {10}}: sum{h in 14..16, i in 11..13}x[i,k,h]+sum{h in 34..40, i in 11..13}x[i,k,h]>=2;
subject to 3{k in {22}}: sum{h in 14..16, i in 7..10}x[i,k,h]>=1;


#shift requests
subject to drew: x[5,10,6] == 1;
subject to jackson: x[6,17,38] == 1;
subject to willy: x[13,24,2] == 1;


#leave requests
subject to cory1: x[14,1,34] == 1;
subject to cory2: x[14,2,34] == 1;
subject to cory3: x[14,3,34] == 1;
subject to geogina: x[14,3,17] == 1;
subject to justice: x[14,14,13] == 1;
subject to richard: x[14,15,39] == 1;
subject to jackson1: x[14,19,38] == 1;
subject to jackson2: x[14,20,38] == 1;
subject to frankie: x[14,20,21] == 1;
subject to sam: x[14,31,36] == 1;


#time limits
subject to night_limit{k in 1..D-6, h in 1..I}: sum{i in 11..13}(x[i,k,h]+x[i,k+1,h]+x[i,k+2,h]+x[i,k+3,h]+x[i,k+4,h]+x[i,k+5,h]+x[i,k+6,h])<=1;
subject to afternoon_limit{k in 1..D-6, h in 1..I}: sum{i in 7..10}(x[i,k,h]+x[i,k+1,h]+x[i,k+2,h]+x[i,k+3,h]+x[i,k+4,h]+x[i,k+5,h]+x[i,k+6,h])<=2;
subject to shift_0_limit{k in 1..D-6, h in 1..I}: x[14,k,h]+x[14,k+1,h]+x[14,k+2,h]+x[14,k+3,h]+x[14,k+4,h]+x[14,k+5,h]+x[14,k+6,h]>=1;
