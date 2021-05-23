close all
clear all
pkg load symbolic

%gain stage

VT=25e-3
BFN=178.7
VAFN=69.7
RE1=75
RC1=840
RB1=75000
RB2=15000
VBEON=0.7
VCC=12
RS=75

%OP operating point

RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


%guardar OP numa tabela 

fop1 = fopen("op1teo.tex", "w");
fprintf(fop1,  "IB1 & %0.7f\\\\ \\hline \n", IB1 )
fprintf(fop1,  "IC1 & %0.7f\\\\ \\hline \n", IC1 )
fprintf(fop1,  "IE1 & %0.7f\\\\ \\hline \n", IE1 )
fprintf(fop1,  "VE1 & %0.7f\\\\ \\hline \n", VE1 )
fprintf(fop1,  "VO1 & %0.7f\\\\ \\hline \n", VO1 )
fprintf(fop1,  "VCE & %0.7f\\\\ \\hline \n", VCE )
fclose(fop1);

%incremental 

gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

%gain
AV1 = -RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)

AV1simple = gm1*RC1/(1+gm1*RE1)

RE1=0
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1simple = gm1*RC1/(1+gm1*RE1)


RE1=75

%ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)
ZI1=1/(1/RB+1/rpi1)
ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)))

ZO1 = 1/(1/ZX+1/RC1)

%imprimir valores da incremental
finc1 = fopen("inc1teo.tex", "w");
fprintf(finc1,  "AV1 & %0.7f\\\\ \\hline \n", AV1 )
fprintf(finc1,  "ZI1 & %0.7f\\\\ \\hline \n", ZI1 )
fprintf(finc1,  "ZO1 & %0.7f\\\\ \\hline \n", ZO1 )
fclose(finc1)


%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 75
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

%guardar OP numa tabela 

fop2 = fopen("op2teo.tex", "w");
fprintf(fop2,  "VI2 & %0.7f\\\\ \\hline \n", VI2 )
fprintf(fop2,  "IE2 & %0.7f\\\\ \\hline \n", IE2 )
fprintf(fop2,  "IC2 & %0.7f\\\\ \\hline \n", IC2 )
fprintf(fop2,  "VO2 & %0.7f\\\\ \\hline \n", VO2 )
fclose(fop2);

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)

ZI2 = (gm2+gpi2+go2+ge2)/(gpi2*(gpi2+go2+ge2))

ZO2 = 1/(gm2+gpi2+go2+ge2)

%impedancias totais
ZOtotal=1*0.0001/(go2+gm2*gpi2/(gpi2+ZO1)+ge2+1/(gpi2+ZO1))

%imprimir valores da incremental
finc2 = fopen("inc2teo.tex", "w");
fprintf(finc2,  "AV2 & %0.7f\\\\ \\hline \n", AV2 )
fprintf(finc2,  "ZI2 & %0.7f\\\\ \\hline \n", ZI2 )
fprintf(finc2,  "ZO2 & %0.7f\\\\ \\hline \n", ZO2 )
fprintf(finc2,  "ZOout & %0.7f\\\\ \\hline \n", ZOtotal )
fclose(finc2)




%%%%%%%%%%%%%%%%%%%%%
syms w
syms AVVV

x= logspace(-1,10)
C=0.0000000000005
AVVV=0.03*gm1*real((1./(1./ro1+1./((1./RE1)+(1./(j.*2.*pi.*x.*C)))))*(1/(1/rpi1+1/RB1+1/RB2))/(RS+(1/(1/rpi1+1/RB1+1/RB2))))
hf = figure ();
%plot(x,20*log(real(AVVV)))
semilogx(x, 20*log10(abs(AVVV)))
xlabel("freq")
ylabel("vin")
print(hf,"vovi.pdf");