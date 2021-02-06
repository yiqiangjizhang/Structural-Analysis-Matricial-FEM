%-------------------------------------------------------------------------%
% ASSIGNMENT 03 - (A)
%-------------------------------------------------------------------------%
% Date: 09/03/20
% Author/s: Pedro López; Yi Qiang Ji
%

clear;
close all;
clc;

%% INPUT DATA

% Material properties
E = 71e9;

% Cross-section parameters
a = 30e-3;
b = 105e-3;
h = 900e-3;
t = 6e-3;

% Other data
g = 9.81;
L1 = 6;
L2 = 12;
Me = 2360;
M = 36000;

% Number of elements for each part
% -- Total number of elements = nel_min*nel_part
nel_min = 2; % Modify the value
nel_part = [2,4,8,16,32,64,128];
err = zeros(length(nel_part),1);

%% PRECOMPUTATIONS

% Compute section: 
% A  - Section area 
A = b*(h+t) - (b-a)*(h-t);
% Iy - Section inertia
Iy = (b*(h+t)^3 + (a-b)*(h-t)^3)/12;

% Compute parameter l:
% l - Equilibrium parameter
l = computeEquilibriumParameter(g, L1, L2, Me, M);

% Plot analytical solution
fig = plotBeamsInitialize(L1+L2);

% Analitical solution, (usig nel_part = 128)
u_an = 0;

%Method to compute average load
% 1 Evaluate q and lambda at (a+b)/2 (mid point)
% 2 Evaluate q and lambda by numerical integration, using trapeze method, 
%   and dividing by interval length
% 3 Evaluate q and by numerical integration, using matlab function, and 
%   dividing by interval length
method = 3;

% Loop through each of the number of elements
for k = length(nel_part):-1:1

    %% PREPROCESS
    
    % Dimensions (1)
    n_el = nel_min * nel_part(k); % Number of elements    
    
    % Nodal connectivities  
    %  Tnod(e,a) = global nodal number associated to node a of element e
    Tnod = zeros(n_el, 2);
    for e = 1:n_el
        Tnod(e,1) = e;
        Tnod(e,2) = e+1;
    end
    
    % Dimensions (2)
    n_d = 2;                      % Number of dimensions
    n_nod = n_el + 1;             % Total number of nodes (joints)
    n_ne = size(Tnod, 2);         % Number of nodes for each element
    n_i = 2;                      % Number of DOFs for each node
    n_dof = n_i * n_nod;          % Total number of degrees of freedom
    n_el_dof = n_i * n_ne;        % Number of DOFs for each element
    
    % Material properties matrix
    %  mat(m,1) = Young modulus of material m
    %  mat(m,2) = Section area of material m
    %  mat(m,3) = Section inertia of material m
    mat = [% Young M.        Section A.    Inertia 
             E,              A,            Iy;  % Material (1)
    ];

    % Material connectivities
    %  Tmat(e) = Row in mat corresponding to the material associated to element e 
    Tmat = ones(n_el,1);
    
    % Nodal coordinates
    %  x(a,j) = coordinate of node a in the dimension j
    % Complete the coordinates
    x = computeNodalCoordinates(n_d, n_nod, nel_part(k), L1, L2);
    
    %% SOLVER
    % Computation of the DOFs connectivities
    Td = connectDOFs(n_el, n_ne, n_i, Tnod);
    
    % Computation of element stiffness matrices
    Kel = computeKelBar(n_ne, n_i, n_el, x, Tnod, mat, Tmat);
    
    % Computation of element force vector
    Fel = computeFelBar(L1, L2, l, M, g, n_i, n_ne, n_el, x, Tnod, method);
    
    % Global matrix assembly
    [KG, Fext] = assembly_KG_Fext(n_el, n_ne, n_i, n_dof, Td, Kel, Fel);
    Fext(Td(nel_part(k)+1,1)) = Fext(Td(nel_part(k)+1,1)) - g*Me;
    
    % Fix nodes matrix creation
    %  fixNod(k,1) = node at which some DOF is prescribed
    %  fixNod(k,2) = DOF prescribed
    %  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
    fixNod = [  %Node   %DOF    %Magnitude
                1,      1,      0;
                1,      2,      0;
    ];
        
    % Apply conditions
    [vL,vR,uR] = applyCond(n_i, n_dof, fixNod);
            
    % u  - Displacements and rotations vector [ndof x 1]
    [u, R] = solveSys(vL, vR, uR, KG, Fext);
    
    % pu - Polynomial coefficients for displacements for each element [n_el x 4]
    % pt - Polynomial coefficients for rotations for each element [n_el x 3]
    [pu, pt] = computePuPt(n_el, n_ne, n_i, x, Tnod, Td, u);
    
    % Fy - Internal shear force at each elements's nodes [n_el x n_ne]
    % Mz - Internal bending moment at each elements's nodes [n_el x n_ne]
    [Fy, Mz] = computeFyMz(n_el, n_ne, n_i, Tnod, Td, x, Kel, u);
    
    %% POSTPROCESS
    
    % Compute error between numerical and analytical solution
    if k == length(nel_part)
        u_an = u;
    end
    err(k) = abs((u(end-1)-u_an(end-1))/u_an(end-1));
    
    % Number of subdivisions and plots
    nsub = nel_part(end)/nel_part(k);
    plotBeams1D(fig, x, Tnod, nsub, pu, pt, Fy, Mz);
    drawnow;
    
end

% Add figure legends
figure(fig);
legend(strcat('N=', cellstr(string(nel_part))), 'location', 'northeast', 'Interpreter', 'latex');

% Plot error vs n_el
plotError(nel_min, nel_part, err);
