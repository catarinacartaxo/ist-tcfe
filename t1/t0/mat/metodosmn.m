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

G1 = 1/R1
G2 = 1/R2
G3 = 1/R3
G4 = 1/R4
G5 = 1/R5
G6 = 1/R6
G7 = 1/R7
G67 = (1/(R6+R7))

Z = 0.0
um = 1.0



D=[R1+R3+R4,-R3,-R4; -R3,R3-(1/Kb),0; -R4, 0, R4+R6+R7-Kc]
E=[Va;0;0]

F=D\E

Vcm=Kc*F(3)
Vbm=F(2)/Kb

A = [um,Z,Z,-um,Z,Z,Z;-G1,G1+G2+G3,-G2,Z,Z,Z,Z;Z,-Kb-G2,G2,Z,Z,Z,Z; Z,-Kb,Z,Z,G5,Z,Z;Z,Z,Z,G6,Z,-G6-G7,G7;-G1,G1,Z,-G4-G6,Z,G6,Z;Z,Z,Z,Kc*G6,Z,-Kc*G6,um]
B = [Va;Z;Z;Id;Z;Z;Z]

C = A\B

Icn = (C(7,1)-C(1,1))*G6
Vcn = Kc*Icn
Ibn = Kb*C(3,1)

fid = fopen ("tabelanos_tab.tex", "w")
fprintf(fid,  "V1 & %0.10f\\\\ \\hline \n", C(1) )
fprintf(fid,  "V2 & %0.11f\\\\ \\hline \n", C(2) )
fprintf(fid,  "V3 & %0.11f\\\\ \\hline \n", C(3) )
fprintf(fid,  "V4 & %0.11f\\\\ \\hline \n", C(4) )
fprintf(fid,  "V6 & %0.11f\\\\ \\hline \n", C(5) )
fprintf(fid,  "V7 & %0.11f\\\\ \\hline \n", C(6) )
fprintf(fid,  "V8 & %0.11f\\\\ \\hline \n", C(7) )
fclose (fid)


fidf = fopen ("tabelamalhas_tab.tex", "w")
fprintf(fidf,  "I1 & %0.11f\\\\ \\hline \n", F(1) )
fprintf(fidf,  "I2 & %0.11f\\\\ \\hline \n", F(2) )
fprintf(fidf,  "I3 & %0.11f\\\\ \\hline \n", F(3) )
fclose (fidf)


fidcm = fopen ("calculosmalhas_tab.tex", "w")

fprintf(fidcm,  "Vc & %0.10f\\\\ \\hline \n", Vcm )
fprintf(fidcm,  "I2 & %0.11f\\\\ \\hline \n", Vbm )

fclose (fidcm)
%VAIS TER QUE ME DIZER

fidcn = fopen ("calculosnos_tab.tex", "w")
fprintf(fidcn,  "Ic & %0.7f\\\\ \\hline \n", Icn )
fprintf(fidcn,  "Vc & %0.7f\\\\ \\hline \n", Vcn )
fprintf(fidcn,  "Ib & %0.7f\\\\ \\hline \n", Ibn )
fclose (fidcn)


