% Assigment1_bar1D_Galerkin
% Authors: Iván Sermanoukian; Yi Qiang Ji
% Assigment1_bar1D_Galerkin

clc; % Clean the command window
clear all; % Clean the workspace 
close all; % Close Matlab secondary windows

%% Boundary Value Problem (BVP)

syms x u(x)                     % Define symbolic variables/functions
% syms L                        % Define general constants
% syms g                        % Dirichlet boundary condition  (= Restricted displacement)
L = 1;                          % Specific exact solution [m]
g = 0.01;                       % Specific exact solution [m]
b =(g*pi^2/L);                  % Neumann Boundary condition   (= Point load at x = L)
rho = (pi/L)^2;                 % Density of the bar
s = g*rho^2;                    % BVP constant
f = (rho*u(x) - s*x^2);         % Distributed axial force (E is not relevant here)
N = [1 x x^2 x^3 x^4 x^5] ;     % Basis functions (polynomials) 

%% General exact solution / Specific exact solution

Du = diff(u,x);  % First derivative of u(x)                                       
% Symbolic Matlab exact solution of the function
u_exact = dsolve(diff(u,2) == -f, u(0) == -g, Du(1) == b);  
% function + 2 x boundary conditions

%%  Approximate solution by Galerkin method

[u_approx_O1]= GalerkinMethodA1(N(1:2),b,-g,rho,s,L);  % N = [1 x] 
[u_approx_O2]= GalerkinMethodA1(N(1:3),b,-g,rho,s,L);  % N = [1 x x^2] 
[u_approx_O3]= GalerkinMethodA1(N(1:4),b,-g,rho,s,L);  % N = [1 x x^2 x^3] 
[u_approx_O4]= GalerkinMethodA1(N(1:5),b,-g,rho,s,L);  % N = [1 x x^2 x^3 x^4] 

%% Plotting the functions

figure(1);  
hold on;

% Set Matlab interpreter = LaTeX
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Plots of all the functions throughout the bar
h1 = ezplot(u_exact,0,L);
h2 = ezplot(u_approx_O1,0,L);
h3 = ezplot(u_approx_O2,0,L);
h4 = ezplot(u_approx_O3,0,L);
h5 = ezplot(u_approx_O4,0,L);

% Set the legend
lgd = legend([h1 h2 h3 h4 h5], ... 
    {['Exact Solution: $', latex(vpa(u_exact,4)),'$'] , ... 
    ['Galerkin O1: $', latex(vpa(u_approx_O1,4)),'$'], ...
    ['Galerkin O2: $', latex(vpa(u_approx_O2,4)),'$'], ...
    ['Galerkin O3: $', latex(vpa(u_approx_O3,4)),'$'], ... 
    ['Galerkin O4: $', latex(vpa(u_approx_O4,4)),'$']}, ...
    'location','southeast','interpreter','latex')

% Set the title and labels for each axis
tlt = title('Boundary Value Problem','interpreter','latex');
Xl = xlabel('Bar length x');
Yl = ylabel('Displacement u(x)');

% Change the Font Size of the titles and labels
set(lgd,'FontSize',14);
set(tlt,'FontSize',14);
set(Xl,'FontSize',14);
set(Yl,'FontSize',14);

grid minor; % Add a grid
box on; % Framing the figure

hold off;
