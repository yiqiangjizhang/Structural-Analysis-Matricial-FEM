clc;
clear all;

xi = [-1:0.01:1];

syms xiSYM

q = (xi.^2).*exp(xi);

plot(xi,q)

xiG(1) = sqrt(3/5);
xiG(2) = -sqrt(3/5);
xiG(3) = 0;
w(1) = 5/9;
w(2) = 5/9;
w(3) = 8/9;

qFUN = (xiG.^2).*exp(xiG);

Integral = w*qFUN' % w1*q(xi1) + w2*q(xi2) + ...

qSYM = (xiSYM.^2).*exp(xiSYM);

Integral_sym = vpa(int(qSYM,-1,1),4)