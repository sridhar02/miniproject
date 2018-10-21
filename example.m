clc;

n=3;
k = 10;

p = zeros(1,k);
for i = 1:k
    p(i)=power(n,i);
    
end
disp(p);