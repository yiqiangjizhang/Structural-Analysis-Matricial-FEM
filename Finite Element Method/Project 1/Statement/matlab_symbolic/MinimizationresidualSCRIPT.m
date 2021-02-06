clc ; % Clean the command window
clear all  ; % Clean the workspace 
syms x u(x) % Define symbolic variables/functions
%syms x u(x) % Define symbolic variables/functions ... 
b =0 ;  % Neumann Boundary condition   (= Point load at x = 1)
g =-1;   % Dirichlet boundary condition  (= Restricted displacement)
f = cos(pi*x) ;  % Source function  ( = Force over the bar)
N = [1 x x^2  x^3 x^4 x^5 ] ;  % Basis functions (polynomials)
% ----------------------
% %%%  Exact solution  %  (ONly works in some Matlab versions)
 %Du = diff(u,x) ;   
 %uexact = dsolve(diff(u,2) == -f,u(0)==g,Du(1)== b) ;
%%%%%  Approximate solution by minimization of residual 
[uapprox]= Minimizationresidual(N,f,b,g) ;
%  Plotting the functions 
figure(1) ;
hold on; 
xlabel('x') ;
ylabel('u'); 

%%%
%h1 = ezplot(uexact,0,1) ;
h2 = ezplot(uapprox,[0,1]) ;
%legend([h1 h2],{['Exact: ',char(vpa(uexact,3))],['Minimization res.: ',char(vpa(uapprox,3))]})
% -------------------------------
%  Change the limits
 %axis([0  1  -1.3 -1.2]) ; 
 
