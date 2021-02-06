function [u]= GalerkinMethod(N,f,b,g);
syms x %
N_1 = subs(N,1) ;
B = diff(N,x); 
BtB = B.'*B ;  
K = int(BtB,0,1) ; 
F = int(N.'*f,0,1) + N_1.'*b  ; 
r = 1; l = 2:length(N) ; 
dl = K(l,l)\(F(l)-K(l,r)*g); 
u  = g + N(l)*dl; % N(1)*d_1 + N(2)*d_2 + N(3)*d_3 + ...