%% Assignment 01
% Author/s: Iván Sermanoukian; Yi Qiang Ji
% Assigment1_bar1D_Galerkin
%--------------------------------------------------------------------------

clc; % Clean the command window
clear all; % Clean the workspace 
close all; % Close Matlab secondary windows

format long;

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

%% Aproximate solution by Galerkin Method using Gauss' Quadrature

% Number of elements
n_elem = 10;
% Number of nodes
n_nodes = n_elem +1;
% Coordinate matrix
COOR = linspace(0,L,n_nodes)';
% Element connectivity matrix
CN = zeros(n_elem,2);
% Number of nodes per element
n_nodeE = size(CN,2);

for e=1:n_elem
    for j=1:2
        CN(e,j) = e+j-1;
    end
end

% K matrix
[K,H_e] = AssemblyK(COOR,CN,n_elem,n_nodes,n_nodeE,rho);

% Fe equation
Fe_eq = Equation_Fe(s);

% F assembly
[Ff] = AssemblyFf(n_nodes,n_elem,CN,n_nodeE,COOR,H_e,Fe_eq,s);
Ff(end) = Ff(end)+ b; 

% Nodal displacement
d_r = -g;
r = 1; 
j = 2:n_nodes;
d_l = K(j,j)\(Ff(j)-K(j,r)*d_r);
d(1) = d_r;
    for i=2:1:(n_nodes)
        d(i) = d_l(i-1);
    end
u_approx = d;

[Error_u, Error_u_prime] = Error_calculation(COOR,H_e,n_elem,u_approx)

Error_function_u = sqrt(sum(Error_u))
Error_function_u_prime = sqrt(sum(Error_u_prime))

%% Plotting the functions

figure(1);  
hold on;

% Set Matlab interpreter = LaTeX
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Plots of all the functions throughout the bar
h1 = ezplot(u_exact,0,L);
%h2 = ezplot(u_approx_symbolic,0,L);
h2 = plot(COOR,u_approx);

% Set the legend
lgd = legend([h1 h2], ... 
    {['Exact Solution: $', latex(vpa(u_exact,4)),'$'] , ... 
    ['FE - Matlab Symbolic']}, ...
    'location','southeast','interpreter','latex');

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









