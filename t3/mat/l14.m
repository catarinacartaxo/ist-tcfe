close all 
clear all
f=50;
w=2*pi*f;
R=1500
C=4e-3


t=linspace(0.2, 0.4, 1000);
A = 230;
vS=A*cos(w*t);
vO = abs(vS);

figure
plot(t*1000, vO)
title("Output voltage v_o(t)")
xlabel ("t[ms]")
ylabel ("v_o[V]")
print ("rectmat.eps", "-depsc");


%lpf response
t=linspace(0.2, 0.4, 1000);

VON=0.7
vlim =3*VON

f=50;
w=2*pi*f;
vO = A/sqrt(1+w^2*R^2*C^2) * cos(w*t - atan(w*R*C))


%envelope detector
A=230
t=linspace(0.2,0.4, 100);
f=1000;
w=2*pi*f;
vS = A * cos(w*t);
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R/C);

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R/C);

figure
for i=1:length(t)
  if (vS(i) > 0)
    vOhr(i) = vS(i);
  else
    vOhr(i) = 0;
  endif
endfor

plot(t*1000, vOhr)
hold

for i=1:length(t)
  if t(i) < tOFF
    vO(i) = vS(i);
  elseif vOnexp(i) > vOhr(i)
    vO(i) = vOnexp(i);
  else 
    vO(i) = vS(i);
  endif
endfor

plot(t*1000, vO)
title("Output voltage v_o(t)")
xlabel ("t[ms]")
legend("rectified","envelope")
print ("venvlope.eps", "-depsc");
