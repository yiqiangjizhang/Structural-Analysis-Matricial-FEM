function [u, d]= Minimizationresidual(N,f,b,g) 
syms x 
%%%% Derivatives 
derN = diff(N,x) ; 
dderN = diff(derN) ; 
N0 = subs(N,0) ; % Functions at x = 0; 
derN1 = subs(derN,1) ;  % Deriv. at x = 1 ; 
INTG = 2*(dderN.'*dderN)  ;
K = int(INTG,0,1) ;  % Matrix K 
G = [N0; derN1] ;  % Matrix G 
F = -2*int(dderN.'*f,0,1) ;  % Vector F 
c = [  g; b] ;  % Vector c
% Solution 
ZEROS = zeros(size(G,1),size(G,1)) ; 
A = [K,G.'; G, ZEROS] ;  B = [F;c] ; 
x = A\B ; 
d = x(1:size(K,1)) ; 
u = N*d ; 
end