%Assigment1_bar1D
clc; % Clean the command window
clear all; % Clean the workspace 

% Boundary Value Problem (BVP)
syms x u(x)               % Define symbolic variables/functions
% syms L                  % Define general constants
% syms g                  % Dirichlet boundary condition  (= Restricted displacement)
L = 1;                    % Specific exact solution [m]
g = 0.01;                 % Specific exact solution [m]
b =(g*pi^2/L);            % Neumann Boundary condition   (= Point load at x = L)
rho = (pi/L)^2;           % Density of the bar
s = g*rho^2;              % BVP constant
f = (rho*u(x) - s*x^2);   % Distributed axial force (E is not relevant here)

%% General exact solution / Specific exact solution

Du = diff(u,x);
Uexact = dsolve(diff(u,2) == -f, u(0) == -g, Du(1) == b);

%% Plotting the functions
figure(1);
hold on;
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

title('Boundary Value Problem');
xlabel('Bar length x');
ylabel('Displacement u(x)');
grid minor;
box on;
% h1 = ezplot(Uexact,0,L)
% legend([h1], {['Exact Solution: ', char(vpa(Uexact,3))]})
fplot(Uexact,[0 L],'b')
legend(['$', latex(vpa(Uexact,4)),'$'],'location','southeast','interpreter','latex');

