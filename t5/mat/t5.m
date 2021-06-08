R1=1e3;
R2=100e3;
R3=1e3;
R4=1e3;
C1=220e-9;
C2=220e-9; 
f=logspace(1,7,10000);
n=columns(f);
for i=1:n
	w(i)=2*pi*f(i);
	gain(i)=(1/(j*w(i)*C2)) / ( 1/(j*w(i)*C2) + R4) *  (R1 / (R1+ 1/(j*w(i)*C1)) ) *(1+R2/R3);
	ganhoabs(i)=abs(gain(i));
endfor;
gain_max=max(ganhoabs);
i_LCF=1;
i_HCF=1;
for i=1:n
	if(i_LCF==1 && ganhoabs(i)>(gain_max/sqrt(2)) )
		i_LCF=i;	endif;
	if(i_LCF!=1 && i_HCF==1 && ganhoabs(i)<gain_max/sqrt(2))
		i_HCF=i;endif;
endfor;
hf = figure ();
semilogx(f, 20*log10(ganhoabs), "-b");
grid on;
xlabel("f[Hz]");
ylabel("Gain");
print(hf, "gain.pdf");
wf=2*pi*1000;
Zi=(1/(j*wf*C1)+R1)
Zout=(1 / ( 1/(R4) + j*wf*C2 ))
Ziabs=abs((1/(j*wf*C1)+R1))
Zoutabs=abs((1/( 1/(R4) + j*wf*C2 )))
printf("\n\nLCF %f\n",f(i_LCF) );
printf("HCF %f\n",f(i_HCF) );
printf("central frequency %f\n",sqrt(f(i_HCF)*f(i_LCF)) );
low_teorico=1/(2*pi*C1*R1)
high_teorico=1/(2*pi*C2*R4)
central_teorico=sqrt(low_teorico*high_teorico)
f_central=sqrt(f(i_HCF)*f(i_LCF));
w_central=2*pi*sqrt(f(i_HCF)*f(i_LCF));
gain_in_dB=20*log10(abs((1/(j*w_central*C2)) / ( 1/(j*w_central*C2) + R4) *  (R1 / (R1+ 1/(j*w_central*C1)) ) *(1+R2/R3)))
resultstable = fopen("resultstable.tex", "w");
fprintf(resultstable, "$f_{central}(Hz)$ & %.6e\\\\ \\hline\n", f_central);
fprintf(resultstable, "$Gain$ & %.6e\\\\ \\hline\n", gain_in_dB);
fprintf(resultstable, "$Z_{in}(\\Omega)$ & %.6e \\\\ \\hline\n", Zi);
fprintf(resultstable, "$Z_{out}(\\Omega)$ & %.6e  \\\\ \\hline\n", Zout);
fclose(resultstable);