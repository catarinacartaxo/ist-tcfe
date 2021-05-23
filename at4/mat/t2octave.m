close all
clear all
pkg load symbolic

%read values from python script

fid = fopen("./data.txt","r")

m = textscan(fid, "%s")
vet = cell(1, 11);

for i = 1:11
  vet{1, i} = m{1}(3*i,1)
endfor

format long
val = cell2mat(vet);
R1 = str2num(val{1})*1000;
R2 = str2double(val{2})*1000;
R3 = str2double(val{3})*1000; 
R4 = str2double(val{4})*1000; 
R5 = str2double(val{5})*1000;
R6 = str2double(val{6})*1000;
R7 = str2double(val{7})*1000; 
Vs =  str2double(val{8});
C = str2double(val{9})/(1e+6);  
Kb = str2double(val{10})/1000; 
Kd = str2double(val{11})*1000;

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;

fclose(fid)


spicedata = fopen("valoresini.cir", "w");
fprintf(spicedata, "R1 1 2 %sk \n", val{1});
fprintf(spicedata, "R2 3 2 %sk \n", val{2});
fprintf(spicedata, "R3 2 5 %sk \n", val{1,3});
fprintf(spicedata, "R4 5 GND %sk \n", val{1,4});
fprintf(spicedata, "R5 5 6 %sk \n", val{1,5});
fprintf(spicedata, "R6 9 7 %sk \n", val{1,6});
fprintf(spicedata, "R7 7 8 %sk \n", val{1,7});
fprintf(spicedata, "Vim 9 GND  0V\n");
fprintf(spicedata, "Gib 6 3 (2 5) %sm \n", val{1,10});
fprintf(spicedata, "HVd 5 8 Vim %sk \n", val{1,11});

fclose(spicedata);

% ---ALÍNEA 1----
A = [1,0,0,0,0,0,0;-G1,G1+G2+G3,-G2,-G3,0,0,0;0,-G2-Kb,G2,Kb,0,0,0;0,-G3,0,G3+G4+G5+1/Kd,-G5,0,-1/Kd;0,Kb,0,-Kb-G5,G5,0,0;0,0,0,0,0,-G6-G7,G7;0,0,0,1,0,-Kd*G6,-1];

B = [Vs;0;0;0;0;0;0];

c = A\B

Vx = c(5,1)-c(7,1)
I1 = (c(2,1)-c(1,1)) * G1
I2 = (c(3,1)-c(2,1)) * G2
Vb = c(2,1)-c(4,1)
I3 = Vb * G3
I4 = c(4,1) * G4
I5 = (c(5,1)-c(4,1)) * G5
Id = c(6,1) * G6
I7 = (c(7,1)-c(6,1)) * G7
Ib = Kb*Vb;
IVd = I5-I4+I3;


spice1 = fopen("datateo1.cir","w");
fprintf(spice1, "Vx 6 8 %f\n", Vx);
fclose(spice1);

%imprimir a tabela da alinea 1 num ficheiro
foct1 = fopen ("oct1_tab.tex", "w")
fprintf(foct1,  "Ic & 0.0\\\\ \\hline \n")
fprintf(foct1,  "Ib & %0.11f\\\\ \\hline \n", Ib )

fprintf(foct1,  "I1 & %0.11f\\\\ \\hline \n", I1 )
fprintf(foct1,  "I2 & %0.11f\\\\ \\hline \n", I2 )
fprintf(foct1,  "I3 & %0.11f\\\\ \\hline \n", I3 )
fprintf(foct1,  "I4 & %0.11f\\\\ \\hline \n", I4 )
fprintf(foct1,  "I5 & %0.11f\\\\ \\hline \n", I5 )
fprintf(foct1,  "I6 & %0.11f\\\\ \\hline \n", Id )
fprintf(foct1,  "I7 & %0.11f\\\\ \\hline \n", I7 )

fprintf(foct1,  "V1 & %0.10f\\\\ \\hline \n", c(1) )
fprintf(foct1,  "V2 & %0.11f\\\\ \\hline \n", c(2) )
fprintf(foct1,  "V3 & %0.11f\\\\ \\hline \n", c(3) )

fprintf(foct1,  "V5 & %0.11f\\\\ \\hline \n", c(4) )
fprintf(foct1,  "V6 & %0.11f\\\\ \\hline \n", c(5) )
fprintf(foct1,  "V7 & %0.11f\\\\ \\hline \n", c(6) )
fprintf(foct1,  "V8 & %0.11f\\\\ \\hline \n", c(7) )

fprintf(foct1,  "Id & %0.11f\\\\ \\hline \n", Id )

fclose (foct1)

% ---ALÍNEA 2----

D = [1,0,0,0,0,0,0;G1,-G1-G2-G3,G2,G3,0,0,0;0,Kb+G2,-G2,-Kb,0,0,0;-G1,G1,0,G4,0,G6,0;0,0,0,1,0,-Kd*G6,-1;0,0,0,0,1,0,-1;0,0,0,0,0,-G6-G7,G7];

E = [0;0;0;0;0;Vx;0];

F = D\E

Ix = G5*F(5,1)

V1 = F(1);
V2 = F(2);
V3 = F(3);
V5 = F(4);
V6 = F(5);
V7 = F(6);
V8 = F(7);

I1 = (V1-V2)/R1;
I2 = (V2-V5)/R3;
I3 = (V3-V2)/R2;
I5 = (V5-V6)/R3;
I4 = V5/R4;
Id = -V7/R6;
I6 = (V8-V7)/R7;
Ib = Kb*Vb;

Req=Vx/Ix

spice2 = fopen("datateo2.cir","w");
fprintf(spice2, ".param V6=%fe+00\n",F(5,1));
fprintf(spice2, ".param V8=0.0\n");
fclose(spice2);

%imprimir a tabela da alinea 1 num ficheiro
foct2 = fopen ("oct2_tab.tex", "w")

fprintf(foct2, "Ib & %0.11f\\\\ \\hline \n", Ib )

fprintf(foct2, "I1 & %0.11f\\\\ \\hline \n", I1 )
fprintf(foct2, "I2 & %0.11f\\\\ \\hline \n", I2 )
fprintf(foct2, "I3 & %0.11f\\\\ \\hline \n", I3 )
fprintf(foct2, "I4 & %0.11f\\\\ \\hline \n", I4 )
fprintf(foct2, "I5 & %0.11f\\\\ \\hline \n", I5 )
fprintf(foct2, "I6 & %0.11f\\\\ \\hline \n", I6 )
fprintf(foct2, "Id & %0.11f\\\\ \\hline \n", Id )

fprintf(foct2, "V1 & %0.10f\\\\ \\hline \n", F(1) )
fprintf(foct2, "V2 & %0.11f\\\\ \\hline \n", F(2) )
fprintf(foct2, "V3 & %0.11f\\\\ \\hline \n", F(3) )

fprintf(foct2, "V5 & %0.11f\\\\ \\hline \n", F(4) )
fprintf(foct2, "V6 & %0.11f\\\\ \\hline \n", F(5) )
fprintf(foct2, "V7 & %0.11f\\\\ \\hline \n", F(6) )
fprintf(foct2, "V8 & %0.11f\\\\ \\hline \n", F(7) )

fprintf(foct2, "$R_{eq}$ & %0.11f\\\\ \\hline \n", Req )

fclose (foct2)

% ---ALÍNEA 3----

t = 0:0.1:20;

f1 = figure(1);
plot(t,Vx.*exp(-t/Req./C/1000));
xlabel("t [ms]");
ylabel("vn6 [V]");
print(f1,"v6natural.png","-dpng");
close(f1);


% ---ALÍNEA 4----

f = 1000; 
w = 2*pi*f; 

pvs = exp(-j*pi/2);

A = [1,0,0,0,0,0,0;-G1,G1,0,G4,0,G6,0;G1,-G1-G2-G3,G2,G3,0,0,0;0,G2+Kb,-G2,-Kb,0,0,0;0,-Kb,0,Kb+G5,-G5-j*w*C,0,j*w*C;0,0,0,0,0,-G6-G7,G7;0,0,0,1,0,Kd*G6,-1];

B = [pvs;0;0;0;0;0;0];

c = A\B

C2 = [abs(c(1)), angle(c(1)); abs(c(2)), angle(c(2)); abs(c(3)), angle(c(3)); abs(c(4)), angle(c(4)); abs(c(5)), angle(c(5)); abs(c(6)), angle(c(6)); abs(c(7)), angle(c(7))]

foct4 = fopen ("oct4_tab.tex", "w")

fprintf(foct4, "$\\tilde{V_1}$ & %0.7f & %0.7f\\\\ \\hline \n", C2(1,1), C2(1,2))
fprintf(foct4, "$\\tilde{V_2}$& %0.7f & %0.7f\\\\ \\hline \n", C2(2,1), C2(2,2) )
fprintf(foct4, "$\\tilde{V_3}$ & %0.7f & %0.7f\\\\ \\hline \n", C2(3,1), C2(3,2)  )
fprintf(foct4, "$\\tilde{V_4}$ & 0.0 & 0.0\\\\ \\hline \n")
fprintf(foct4, "$\\tilde{V_5}$ & %0.7f & %0.7f\\\\ \\hline \n", C2(4,1), C2(4,2)  )
fprintf(foct4, "$\\tilde{V_6}$& %0.7f & %0.7f\\\\ \\hline \n", C2(5,1), C2(5,2)  )
fprintf(foct4, "$\\tilde{V_7}$ & %0.7f & %0.7f\\\\ \\hline \n", C2(6,1), C2(6,2)  )
fprintf(foct4, "$\\tilde{V_8}$ & %0.7f & %0.7f\\\\ \\hline \n", C2(7,1), C2(7,2)  )

fclose (foct4)


% ---ALÍNEA 5----

function x = pieceWise(t, amp, pha, w, V, tau)
  x = V * ones(size (t));
%ind = t >= (pha-pi/2)/w;
ind = t >= 0;
  x(ind) = V*exp(-t(ind)/tau)+amp*cos(w*t(ind)-pha);
endfunction

t = -5:1e-3:20;

f2 = figure(2);
plot(t, pieceWise(t/1000, C2(5,1), C2(5,2), w, V6, Req*C), "r");
hold on;
plot(t, sin(w*t/1000), "g");
xlabel("t [ms]");
ylabel("[V]");
legend("v6(t) [V]", "vs(t) [V]");
print(f2, "total.png","-dpng");
close(f2);

% ---ALÍNEA 6----

syms fa
syms Vi
syms v11
syms v21
syms v31
syms v41
syms v51
syms v61
syms v71
syms v81

N = [1,0,vpa(0),0,0,0,0;
-1/vpa(R1, 11),1/vpa(R1,11),0,1/vpa(R4,11),0,1/vpa(R6,11),0;

1/vpa(R1,11),(-1/vpa(R1,11))-(1/vpa(R2,11))-(1/vpa(R3,11)),1/vpa(R2,11), 1/vpa(R3,11),0,0,0;

0,1/vpa(R2,11)+vpa(Kb,11),-1/vpa(R2,11),-vpa(Kb,11),0,0,0;

0,-vpa(Kb,11),0,vpa(Kb,11)+1/vpa(R5,11),-1/vpa(R5,11)-2*pi*j*fa*vpa(C,11),0,2*pi*j*fa*vpa(C,11);

0,0,0,0,0,-1/vpa(R6,11)-1/vpa(R7,11),1/vpa(R7,11);

0,0,0,1,0,vpa(Kd,11)*1/vpa(R6,11),-1];

M = [Vi;vpa(0);vpa(0);vpa(0);vpa(0);vpa(0);vpa(0)];

T = N\M

v11=T(1)
v21=T(2)
v31=T(3)
v51=T(4)
v61=T(5)
v71=T(6)
v81=T(7)

T1 = simplify(v61/Vi)
T2 = simplify((v61-v81)/Vi)
T3 = simplify(v11)

fileID8= fopen("transfer.tex","w")
chr = latex(T1)
fprintf(fileID8, "$$");
fprintf(fileID8, "%s", chr)
fprintf(fileID8, "$$\n");
chr= latex(T2)
fprintf(fileID8, "$$");
fprintf(fileID8, "%s", chr)
fprintf(fileID8, "$$\n");


freq_1= function_handle(T1)
freq_2= function_handle(T2)
freq_3= function_handle(T3)

x= logspace(-1,6)

hf=figure()

y= freq_1(x);
semilogx(x, 20*log10(abs(y)))
hold on
y= freq_2(x);
semilogx(x, 20*log10(abs(y)))
hold on
semilogx(x, 0)
hold off
title("Signal Magnitude")
legend("abs(T(v6))", "abs(T(v6-v8))","abs(Tvs)")
xlabel("kHz")
ylabel("V")
grid on
print (hf, "Transmagnitude.pdf");




hf=figure()

y= freq_1(x);
semilogx(x, arg(y)*180/pi)
hold on
y=freq_2(x);
semilogx(x, arg(y)*180/pi)
y=freq_3(x);
semilogx(x, arg(y)*180/pi)
title("Signal Phase")
legend("abs(T(v6))", "abs(T(v6-v8))","abs(Tvs)")
xlabel("kHz")
ylabel("degrees")
grid on
print (hf, "Transphase.pdf");

fclose(fileID8)
