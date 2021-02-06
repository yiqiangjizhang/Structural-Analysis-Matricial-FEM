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
n_elem_matrix = [5,10,20,30,40];
counter = 1;
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

    [Error_u, Error_u_prime] = Error_calculation(COOR,H_e,n_elem,u_approx(counter,:));
    
    Error_function_u(counter) = sqrt(sum(Error_u));
    Error_function_u_prime(counter) = sqrt(sum(Error_u_prime));
    
    H_e_plot(counter) = H_e(counter);
    
    counter = counter +1;
end


%% Plotting the functions

figure(1);  
hold on;

% Set Matlab interpreter = LaTeX
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
 
% Plots of all the functions throughout the bar

plot(log(H_e_plot),log(Error_function_u));
plot(log(H_e_plot),log(Error_function_u_prime));
 
% Set the title and labels for each axis
tlt = title('Error convergence','interpreter','latex');
Xl = xlabel('$Log_{e}(h)$');
Yl = ylabel('$Log_{e}(Error)$');
lgd = legend('u','$\frac{du}{dx}$','location','southeast')

% Change the Font Size of the titles and labels
set(lgd,'FontSize',14);
% set(tlt,'FontSize',14);
% set(Xl,'FontSize',14);
% set(Yl,'FontSize',14);

grid minor; % Add a grid
box on; % Framing the figure
ylim([-12,-4]);

% Basic_fitting_u 
Basic_fitting_u = polyfit(log(H_e_plot),log(Error_function_u),1);
slope_u = Basic_fitting_u(1);
intercept_u = Basic_fitting_u(2);
% Basic fitting u_prime
Basic_fitting_u_prime = polyfit(log(H_e_plot),log(Error_function_u_prime),1);
slope_u_prime = Basic_fitting_u_prime(1);
intercept_u_prime = Basic_fitting_u_prime(2);

hold off;

 
 
 
 
