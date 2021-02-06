%% Galerkin method (Exercise 5)
function [u]= GalerkinMethodA1(N,b,g,rho,s,L);
syms x           % Define symbolic variables/functions
N_L = subs(N,L); % Substitute and save N(x=L)
B = diff(N,x);   % First derivative of N(x)
BtB = B.'*B ;    % Transposed B * B
NtN = N.'*N;     % Transposed N * N
K = int(BtB-NtN*rho,0,L) ;           % Calculate stiffness matrix
F = -int(N.'*s*x^2,0,L) + N_L.'*b  ; % Calculate external forces
r = 1; l = 2:length(N) ;             % rows l ={2,3,...,n}
dl = K(l,l)\(F(l)-K(l,r)*g);         % Real coeficients vector 
u  = g + N(l)*dl;                    % Real displacement vector
% N(1)*d_1 + N(2)*d_2 + N(3)*d_3 + ...