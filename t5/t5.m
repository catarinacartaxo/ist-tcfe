R_1=1e3;
R_2=100e3;
R_3=1e3;
R_4=1e3;
C_1=220e-9;
C_2=220e-9; 

f=logspace(1,7,10000);
n=columns(f);

for i=1:n
	w(i)=2*f(i)*pi;
	gain(i)=(1/(j*w(i)*C_2))/(1/(j*w(i)*C_2)+R_4)*(R_1/(1+R_1/(j*w(i)*C_1)))*(1+R_2/R_3);
	gain(i)=abs(gain(i));
endfor;

gain_max=max(gain);
low_central_freq=1;
high_central_freq=1;
for i=1:n
	if(low_central_freq==1 && gain(i)>(gain_max/sqrt(2)))
    low_central_freq=i;endif;

	if(low_central_freq!=1 && high_central_freq==1 && gain(i)<gain_max/sqrt(2))
    high_central_freq=i;
    endif;
endfor;
hf = figure ();
semilogx(f,20*log10(gain), "-b");
grid on;
xlabel("Frequency(Hz)");
ylabel("Gain");
print(hf, "gain.pdf");

wf=2*pi*1000;
Zi=(1/(wf*j*C_1)+R_1)
Zout=(1/(1/(R_4)+wf*j*C_2))
Ziabs=abs((1/(j*wf*C_1)+R_1))
Z_out_abs=abs((1/(1/(R_4)+j*wf*C_2)))

printf("\n\nLCF %f\n",f(low_central_freq) );
printf("HCF %f\n",f(high_central_freq) );
printf("Central frequency: %f\n",sqrt(f(high_central_freq)*f(low_central_freq)) );
high_teorica=1/(2*pi*C_2*R_4)
low_teorico=1/(2*pi*C_1*R_1)
central_teorico=sqrt(low_teorico*high_teorica)
f_central=sqrt(f(high_central_freq)*f(low_central_freq));
gain_in_dB=20*log10(abs((1/(j*f_central*C_2))/(1/(j*f_central*C_2)+R_4)*(R_1/(R_1+1/(j*f_central*C_1)))*(1+R_2/R_3)))
resultstable = fopen("resultstable.tex", "w");
fprintf(resultstable, "$f_{central}\\;(Hz)$ & %.6e\\\\ \\hline\n", f_central);
fprintf(resultstable, "$Gain$ & %.6e\\\\ \\hline\n", gain_in_dB);
fprintf(resultstable, "$Z_{in}\\;(\\Omega)$ & %.6e \\\\ \\hline\n", Zi);
fprintf(resultstable, "$Z_{out}\\;(\\Omega)$ & %.6e  \\\\ \\hline\n", Zout);

fclose(resultstable);