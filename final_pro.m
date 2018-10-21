clc;
v = read_values("rest.txt");
s = create_cw_struct(v);
s.Re = 690.72;    
general_equation(s);
varying_diameters(s);

function s = create_cw_struct(values)
    c = cell(1,2*length(values{1}));
    for i = 1:length(values{1})
        c{2*i - 1} = values{1}{i};
        c{2*i} = values{2}(i);
    end
    s = struct(c{:});
    s.ed = s.e/s.D;
    s.Z=1/(1+(s.P1*344400*(10)^1.785*s.G/(s.t)^3.825));
end

function values = read_values(file_name)
    fileID = fopen(file_name,'r');
    formatSpec = '%s %f';
    values = textscan(fileID, formatSpec);
    fclose(fileID);
end

function f1 = colebrook_white(cw_s)
    f1 = (1.8*log10(6.9/cw_s.Re+(cw_s.ed/3.7)^1.11))^(-2);
    Fe=f1;
    % computing root of f1
    while f1==Fe
        Fe=(1/sqrt(f1)+2*log10(cw_s.ed/3.7+2.51/cw_s.Re/sqrt(f1)));
        if Fe<=0.000001  
            break;
        else
            f1 = Fe;
        end
    end
end

function f2 = Drew_equation(cw_s)

f2=0.0056+(0.5/cw_s.Re^(0.32));

end

function f3 = Nikuradse_equation(cw_s)

        f3=(1/(1.74-2*log10(2*cw_s.ed)))^2;

end

function f4 = Wood_equation(cw_s)

    a=0.53*(cw_s.ed)+0.094*(cw_s.ed)^0.225;
    b=88*(cw_s.ed)^0.44;
    c=1.62*(cw_s.ed)^0.134;
    f4=a+b*(cw_s.Re^c); 
end

function f5 = Blasius_correlation(cw_s)

    if 2100<cw_s.Re<=20000
        f5=0.316*(cw_s.Re)^(-0.25); 
    elseif cw_s.Re>=20000
        f5 = 0.184*(cw_s.Re)^(-0.2);
    else
        f5 = '-';
    end    

end

function f6 = Churchil_equation(cw_s)

    A=(-2*log10((cw_s.ed/3.70)+(7/cw_s.Re)^0.9))^16;
    B=(37530/cw_s.Re)^16;

    f6 = 8*((8/cw_s.Re)^12+(A+B)^(-3/2))^(1/12);

end

function f7 = Chen_equation(cw_s)

    f7 = 1/(-2*log10(cw_s.ed/3.7065-5.0452/cw_s.Re*log10(cw_s.ed^1.1098/2.8257+5.8506/cw_s.Re^0.8981)))^2;

end

function f8 = Barr_equation(cw_s)

    f8 = 1/(-2*log10(cw_s.ed/3.70+4.518*log10(cw_s.Re/7)/(cw_s.Re*(1+cw_s.Re^0.52/29*cw_s.ed^0.7))))^2;


end

function f9 = Zigrang_sylvester_equation(cw_s)

    f9 = 1/(-2*log10(cw_s.ed/3.7-5.02/cw_s.Re*log10(cw_s.ed/3.7-5.02/cw_s.Re*log10(cw_s.ed/3.7+13/cw_s.Re))))^2;

end 

function f10 = Haaland_equation(cw_s)

    f10 = 1/(-1.8*log10((cw_s.ed/3.70)^1.11+6.9/cw_s.Re))^2;


end 

function f11 = Manadilli_equation(cw_s)

     f11 = 1/(-2*log10(cw_s.ed/3.70+95/cw_s.Re^0.983-96.82/cw_s.Re))^2;

end 

function f12 = Prandtl_Correlation(cw_s) 

    f12 = (1.8*log10(6.9/cw_s.Re+(cw_s.ed/3.7)^1.11))^(-2);
    F = f12;
    while F == f12
        F = 1/sqrt(f12)-2*log10(cw_s.Re*sqrt(f12))+0.8;
        if F <= 0.000001
            break;
        else
            f12 = F;
        end
    end    
end

function P2 = general_equation(cw_s)
    f1 = colebrook_white(cw_s);
    f2 = Drew_equation(cw_s);
    f3 = Nikuradse_equation(cw_s);
    f4 = Wood_equation(cw_s);
    f5 = Blasius_correlation(cw_s);
    f6 = Churchil_equation(cw_s);
    f7 = Chen_equation(cw_s);
    f8 = Barr_equation(cw_s);
    f9 = Zigrang_sylvester_equation(cw_s);
    f10 = Haaland_equation(cw_s);
    f11 = Manadilli_equation(cw_s);
    f12 = Prandtl_Correlation(cw_s);
    names = ["cole brook";"drew koo&Mc"; "Nikuradse";"wood";"Blasius";"Chruchil";"chen";"Barr";"Zigrang";"Haaland";"Manadilli";"Prandtl"];
   
    f = [f1;f2;f3;f4;f5;f6;f7;f8;f9;f10;f11;f12];
    %calculation of pressure using different friction factor values
    P2 = zeros(length(f),1);
    for j = 1:length(f)
        k = ((1/77.54^2)*cw_s.G*cw_s.t*cw_s.L*cw_s.Z*cw_s.Q^2*cw_s.Pb^2*f(j)/(cw_s.Tb^2*cw_s.D^5));
        
        P2(j) = (cw_s.P1^2-k)^0.5;
        %P3(j)=(cw_s.P1^2-4.5346*(cw_s.G*cw_s.t*cw_s.Z*cw_s.L*(cw_s.Q)^2*cw_s.Pb^2/cw_s.Tb^2
    end    
    T = table(names,f,P2);
    disp(T);
end

function c = varying_diameters(cw_s) 
   D = 15.5;
   D_arr = [ D  D/2 3*D/4 D/4]
   
      for D = D_arr
          cw_s.D = D;
          general_equation(cw_s);    
      end

end


