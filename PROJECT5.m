disp('Please Input The Following');
V=input('Rated voltage=');
f=input('Frequency=');
p=input('Number of pole pairs (p)=');
%%
%DC test for main winding
disp('Please Input The Following for DC test (Main)');
Vdcm=input('Vdc=');
Idcm=input('Idc=');
R1m=Vdcm/Idcm;
disp(['For main winding:R1m=' num2str(R1m) 'Ω' newline])
%%
%DC test for auxilary winding
disp('Please Input The Following for DC test (Auxilary)');
Vdca=input('Vdc=');
Idca=input('Idc=');
R1a=Vdca/Idca; 
disp(['For auxilary winding:R1a=' num2str(R1a) 'Ω' newline])
%%
%SS test (Main)
disp('Please Input The Following for SS test (Main)');
Vssm=input('Vstandstill for main winding=');
Issm=input('Istandstill for main winding=');
Pssm=input('Pstandstill for main winding=');
Zssm=Vssm/Issm;
Rssm=Pssm/Issm^2;
Xssm=sqrt(Zssm^2-Rssm^2);        %complex
R2m_=Rssm-R1m;                   %R2m_=R2'
X1m=0.5*Xssm*1i;                 %complex
X2m_=X1m;                        %complex
Zm=R1m+R2m_+X1m+X2m_;            %complex
disp(['For main winding:' newline 'Zss =' num2str(Zssm) 'Ω    Rss =' num2str(Rssm) 'Ω    Xss=' num2str(Xssm) 'Ω' newline 'R2''=' num2str(R2m_) 'Ω    X1m=' num2str(X1m) '    X2m''=' num2str(X2m_) 'Ω    Zm=' num2str(Zm) 'Ω'])
%%
%SS test (Auxilary)
disp('Please Input The Following for SS test (Auxilary)');
Vssa=input('Vstandstill for auxilary winding=');
Issa=input('Istandstill for auxilary winding=');
Pssa=input('Pstandstill for auxilary winding=');
Zssa=Vssa/Issa;
Rssa=Pssa/Issa^2;
Xssa=sqrt(Zssa^2-Rssa^2);        %complex
R2a_=Rssa-R1a;                   %R2a_=R2"
X1a=0.5*Xssa*1i;                 %complex
X2a_=X1a;                        %complex
Za=R1a+R2a_+X1a+X2a_;            %complex
a=sqrt(R2a_/R2m_);
disp(['For auxilary winding:' newline 'Zss =' num2str(Zssa) 'Ω    Rss =' num2str(Rssa) 'Ω    Xss=' num2str(Xssa) 'Ω' newline 'R2"''=' num2str(R2a_) 'Ω    X1a=' num2str(X1a) '    X2a''=' num2str(X2a_) 'Ω    Za=' num2str(Za) 'Ω    Effective turns ratio=' num2str(a)])
%%
%No load test
disp('Please Input The Following for No load test');
Vnl=input('Vnl=');
Inl=input('Inl=');
Pnl=input('Pnl=');
Prot=Pnl-Inl^2*(R1m+0.25*R2m_);  %assume constant
Znl=Vnl/Inl;
Rnl=Pnl/Inl^2;
Xnl=sqrt(Znl^2-Rnl^2)*1i;        %complex
Xm=2*Xnl-2*X1m-X2m_;             %complex
disp(['Xµ=' num2str(Xm) newline])
%%
%Case 1
ns=60*f/p;
ws=(2*pi*ns)/60;
Radd=2*Rssa;
Istm1=V/Zm;                     %complex
Ista1=V/(Za+Radd);              %complex 
Ist1=Istm1+Ista1;
[thm1,rm1]=cart2pol(real(Istm1),imag(Istm1));
[tha1,ra1]=cart2pol(real(Ista1),imag(Ista1));
thm1=abs(thm1);
tha1=abs(tha1);
Tst1=2*a*R2m_*abs(Istm1)/ws*abs(Ista1)*sin(thm1-tha1);
%Case 2
Xcadd=4*X1a;                    %multiply by 4 because Xa=2*X1a & Xcadd=2*Xa
Istm2=V/Zm;                     %complex
Ista2=V/(Za-Xcadd);             %complex
Ist2=Istm2+Ista2;
[thm2,rm2]=cart2pol(real(Istm2),imag(Istm2));
[tha2,ra2]=cart2pol(real(Ista2),imag(Ista2));
thm2=abs(thm2);
tha2=abs(tha2);
k=2*a*R2m_/ws;
Tst2=(2*a*R2m_*abs(Istm2)*abs(Ista2)*sin(thm2+tha2))/ws;
disp([num2str(thm1) num2str(tha1) num2str(thm2) num2str(tha2) k])
disp(['Resistance start motor' newline 'Ist=' num2str(Ist1) 'A   Tst=' num2str(Tst1) 'Nm' newline]);
disp(['Capacitor start motor' newline 'Ist=' num2str(Ist2) 'A   Tst=' num2str(Tst2) 'Nm' newline]);
%%
%Running
%Ia=0
n=input('Required speed=');
s=(ns-n)/ns;
Zf=((0.5*R2m_/s+0.5*X2m_)*(0.5*Xm))/((0.5*R2m_/s+0.5*X2m_)+(0.5*Xm));
Zb=((0.5*R2m_/(2-s)+0.5*X2m_)*(0.5*Xm))/(0.5*R2m_/(2-s)+0.5*X2m_+0.5*Xm);
Im=V/(R1m+X1m+(Zf+Zb));
PCu1=abs(Im)^2*R1m;
Rf=real(Zf);
Rb=real(Zb);
Pg=(1-s)*abs(Im)^2*(Rf-Rb);
pf=cos(angle(Im));
Pin=V*abs(Im)*pf;
Po=Pg-Prot;
Ploss=Pin-Po;
efficiency=(Po/Pin)*100;
disp([num2str(Rb) '   ' num2str(Rf) '   ' num2str(Im) newline])
disp(['Running conditions' newline 'Im=' num2str(Im) 'A   Ploss=' num2str(Ploss) 'W   Po=' num2str(Po) 'W   Pin=' num2str(Pin) 'W   cos(φ)=' num2str(pf) '   η=' num2str(efficiency) '%' newline newline])

