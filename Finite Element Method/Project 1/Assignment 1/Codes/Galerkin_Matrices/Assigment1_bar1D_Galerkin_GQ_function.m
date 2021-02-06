%% Assignment 01
% Author/s: Iván Sermanoukian; Yi Qiang Ji
% Assigment1_bar1D_Galerkin
%--------------------------------------------------------------------------

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

%% Aproximate solution by Galerkin Method using Gauss' Quadrature

% Number of elements
n_elem_matrix = [5,10,20,30,40];
for n = 1:1:length(n_elem_matrix)
    
    n_elem = n_elem_matrix(n);
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
    %d = sparse(10,51)
    d(n,1) = d_r;
        for i=2:1:(n_nodes)
            d(n,i) = d_l(i-1);
        end
        
    u_approx = d;

end


%% Plotting the functions

figure(1);  
hold on;

X_1 = linspace(0,L,n_elem_matrix(1)+1);
X_2 = linspace(0,L,n_elem_matrix(2)+1);
X_3 = linspace(0,L,n_elem_matrix(3)+1);
X_4 = linspace(0,L,n_elem_matrix(4)+1);
X_5 = linspace(0,L,n_elem_matrix(5)+1);

% Set Matlab interpreter = LaTeX
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
 
% Plots of all the functions throughout the bar
h0 = ezplot(u_exact,0,L);
h1 = plot(X_1,u_approx(1,1:length(X_1)),'r');
h2 = plot(X_2,u_approx(2,1:length(X_2)),'Color',[1 140/255 0]);
h3 = plot(X_3,u_approx(3,1:length(X_3)),'Color',[75/255 0 130/255]);
h4 = plot(X_4,u_approx(4,1:length(X_4)),'g');
h5 = plot(X_5,u_approx(5,1:length(X_5)),'c');


% Set the legend
 lgd = legend([h0 h1 h2 h3 h4 h5], ... 
    {['Exact Solution: $', latex(vpa(u_exact,4)),'$'] , ... 
    ['Gauss quadrature: 5 elements'], ...
    ['Gauss quadrature: 10 elements'], ...
    ['Gauss quadrature: 20 elements'], ...
    ['Gauss quadrature: 30 elements'], ...
    ['Gauss quadrature: 40 elements']}, ...
    'location','southeast','interpreter','latex');
 
% Set the title and labels for each axis
tlt = title('Boundary Value Problem (40 elements)','interpreter','latex');
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

 
 
 
 
