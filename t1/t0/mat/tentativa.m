close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

R1 = 1.02043025561*1000
R2 = 2.0041718511*1000
R3 = 3.090579259*1000
R4 = 4.00562948037*1000
R5 = 3.03133870093*1000
R6 = 2.06427287006*1000
R7 = 1.04245638189*1000
Va = 5.0737445952
Id = 1.04039410163*0.001
Kb = 7.11526378475*0.001
Kc = 8.01207369538*1000

O=1.0
Z=0.0

C=[R44+R33+R11,-R33,-R44,Z,Z; -R33,R22+R33+R55+O/KBB,Z,-R55,Z; -R44,Z,R66+R77-KCC+R44,Z,Z; [Z,Z,Z,O,Z]; Z,-R55,KCC,R55,O]
D=[-VA;Z;Z;IDD;Z]

H=[R11+R33+R44,-R33,-R44; -R33,R33-(1/KBB),0; -R44, 0, R44+R66+R77-KCC]
K=[VA;0;0]


A=[R1+R3+R4,-R3,-R4; -R3,R3-(1/Kb),0; -R4, 0, R4+R6+R7-Kc]
B=[Va;0;0]

E=C\D
x=E(1)
y=E(2)
z=E(3)
w=E(4)
Vd=E(5)

Vc=KCC*z
Vb=y/KBB

fid = fopen ("tabelamalhas.tex", "w")

fprintf(fid,  "I1 & %0.10f \\\\ \\hline \n", x )
fprintf(fid,  "I2 & %0.11f \\\\ \\hline \n", y )
fprintf(fid,  "I3 & %0.11f \\\\ \\hline \n", z ) 
fprintf(fid,  "I4 & %0.11f \\\\ \\hline \n", w )

fprintf(fid,  "Vb & %0.7f \\\\ \\hline \n", Vb )
fprintf(fid,  "Vc & %0.7f \\\\ \\hline \n", Vc )
fprintf(fid,  "Vd & %0.7f \\\\ \\hline \n", Vd )

fclose (fid)
