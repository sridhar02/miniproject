clc;
%1.calculation of colebrook white equation
Re=input('enter Re value:');%Reynolds number
e=input('enter roughness value:');
D=input('enter diameter:');
G=input('enter gas gravity:');
t=input('average gas flowing temperature:');
L=input('pipe segment length:');
Q=input('gas flow rate:');
Pb=input('base pressure:');
Tb=input('base temperature:');
P1=input('input pressure:');
ed=e/D;%Relative roughness=epsilon/diameter
Z=1/(1+(P1*344400*(10)^1.785*G/(t)^3.825));
for i=1:length(Re)
f1(i)=(1.8*log10(6.9/Re(i)+(ed/3.7)^1.11))^(-2);
Fe(i)=f1(i);
while f1(i)==Fe(i)
        Fe(i)=(1/sqrt(f1(i))+2*log10(ed/3.7+2.51/Re(i)/sqrt(f1(i))));
        if Fe(i)<=0.000001  
            break;
        else
            f1(i)=Fe(i);
        end
end

%2.Drew,koo and Mc Adams equation
f2(i)=0.0056+(0.5/Re(i)^(0.32));

%3.Nikuradse equation and calculatinf friction factor
f3(i)=(1/(1.74-2*log10(2*ed)))^2;

%4.Wood equation 
a=0.53*(ed)+0.094*(ed)^0.225;
b=88*(ed)^0.44;
c=1.62*(ed)^0.134;
f4(i)=a+b*(Re(i)^c);

%5.Blasius correlation fro calculating friction factor

if 2100<Re(i)<=20000
    f5(i)=0.316*(Re(i))^(-0.25); 
elseif Re(i)>=20000
    f5(i)=0.184*(Re(i))^(-0.2);
else
    f5(i)='-';
end    

%6.Churchil equation

A=(-2*log10((ed/3.70)+(7/Re(i)^0.9))^16);
B=(37530/Re(i)^16);

f6(i)=8*((8/Re(i))^12+(A+B)^(-3/2))^(1/12);

%7.Chen equation

f7(i)=1/(-2*log10(ed/3.7065-5.0452/Re(i)*log10(ed^1.1098/2.8257+5.8506/Re(i)^0.8981)))^2;

%8.Barr equation

f8(i)=1/(-2*log10(ed/3.70+4.518*log10(Re(i)/7)/(Re(i)*(1+Re(i)^0.52/29*ed^0.7))))^2;

%9.Zigrang and sylvester equation

f9(i)=1/(-2*log10(ed/3.7-5.02/Re(i)*log10(ed/3.7-5.02/Re(i)*log10(ed/3.7+13/Re(i)))))^2;

%10.Haaland equation

f10(i)=1/(-1.8*log10((ed/3.70)^1.11+6.9/Re(i)))^2;

%11.Manadilli equation
f11(i)=1/(-2*log10(ed/3.70+95/Re(i)^0.983-96.82/Re(i)))^2;

%12.Prandtl  Correlation 

f12(i)=(1.8*log10(6.9/Re(i)+(ed/3.7)^1.11))^(-2);
F(i)=f12(i);
while F(i)==f12(i)
    F(i)=1/sqrt(f12(i))-2*log10(Re(i)*sqrt(f12(i)))+0.8;
    if F(i)<=0.000001
        break;
    else
        f12(i)=F(i);
    end
end

end
name=["cole brook";"drew koo&Mc"; "Nikuradse";"wood";"Blasius";"Chruchil";"chen";"Barr";"Zigrang";"Haaland";"Manadilli";"Prandtl"];
f=[f1;f2;f3;f4;f5;f6;f7;f8;f9;f10;f11;f12];
%calculation of pressure using different friction factor values
for i=1:length(Re)
    for j=1:12
        P2(j,i)=(P1^2-0.0001663*(G*t*L*Z*Q^2*Pb^2*f(j,i)/(Tb^2*D^5)))^0.5;
        P3(j,i)=(P1^2-4.5346*(G*t*Z*L*Q^2*Pb^2/Tb^2));
    end
end
T=table(name,f,P2);
disp(T);

