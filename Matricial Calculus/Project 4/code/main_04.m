%-------------------------------------------------------------------------%
% ASSIGNMENT 04
%-------------------------------------------------------------------------%
% Date:
% Author/s:
%

clear;
close all;
clc;

%% INPUT DATA

% Material properties
E = 200e9; % Pa

% Cross-section parameters
d = 195e-3; % m
tA = 12e-3; % m
a = 64e-3; % m
b = 82e-3; % m
tB = 7e-3; % m

% Other data
L = 0.65; % m
H1 = 1.20; % m
H2 = 2.25; % m
alpha = 8*pi/180; % rad
rw = 0.58; % m
I0 = 230; % kg m2
dt = 0.75; % s
mu = 0.32; 
V = 235/3.6; % m/s

%% PRECOMPUTATIONS

% Compute section properties AA, AB (area), IzA, IzB (inertia) 
AA = pi * d * tA;
AB = a*(b+tB) - (a-tB)*(b-tB);
IzA = pi/4 * (((d+tA)/2)^4 - ((d-tA)/2)^4);
IzB = 1/12 * (a*(b+tB)^3 - (a-tB)*(b-tB)^3);

% Complete with your code...

% Compute forces (normal N and friction F)
F = I0*V/(rw^2*dt);
N = I0*V/(rw^2*dt*mu);

fprintf("%10s = %.3e\n", "AA", AA);
fprintf("%10s = %.3e\n", "AB", AB);
fprintf("%10s = %.3e\n", "IzA", IzA);
fprintf("%10s = %.3e\n", "IzB", IzB);
fprintf("%10s = %.3f\n", "F", F);
fprintf("%10s = %.3f\n\n", "N", N);

% Complete with your code...

%% PREPROCESS

% Nodal coordinates
%  x(a,j) = coordinate of node a in the dimension j
x = [
    0,      0; % Node 1
    L,     H2; % Node 2
    0,     H2; % Node 3
    0,  H2-H1; % Node 4
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tnod = [
    1, 4; % Element 1-4
    4, 3; % Element 4-3
    2, 4; % Element 2-4
];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [%  Node    DOF     Magnitude
            1       1       -F*cos(alpha)+N*sin(alpha);
            1       2       F*sin(alpha)+N*cos(alpha);
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [% Node    DOF     Magnitude
            2       1       0;
            2       2       0;
            2       3       0;
            3       1       0;
            3       2       0;
            3       3       0;
% Write the data here...
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Section inertia of material m
mat = [% Young M.        Section A.    Inertia 
               E,               AA,        IzA;  % Material 1
               E,               AB,        IzB;  % Material 2
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [
    1; % Element 1-4 / Material 1 (A)
    1; % Element 4-3 / Material 1 (A)
    2; % Element 2-4 / Material 2 (B)
];


%% SOLVER
% Dimensions
n_d = size(x,2);              % Number of dimensions
n_el = size(Tnod,1);          % Number of elements
n_nod = size(x,1);            % Total number of nodes (joints)
n_ne = size(Tnod, 2);         % Number of nodes for each element
n_i = 3;                      % Number of DOFs for each node
n_dof = n_i * n_nod;          % Total number of degrees of freedom
n_el_dof = n_i * n_ne;        % Number of DOFs for each element

% Complete with your code...

% Computation of the DOFs connectivities
Td = connectDOFs(n_el, n_ne, n_i, Tnod);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d, n_el, n_ne, n_i, x, Tnod, mat, Tmat);

% Global matrix assembly
KG = assemblyKG(n_el, n_dof, n_el_dof, Td, Kel);

% Global force vector assembly
Fext = computeF(n_i, n_dof, Fdata);

% Apply conditions
[vL, vR, uR] = applyCond(n_i, n_dof, fixNod);

% System resolution
[u, R] = solveSys(vL, vR, uR, KG, Fext);

% Computation of internal forces and bending moment
[Fx_el, Fy_el, Mz_el] = computeFxFyMz(n_d, n_el, n_ne, n_i, x, Tnod, Td, Kel, u);

% Computation of axial strain, deflection and section rotation
[pu, pt, eps] = computePuPtEps(n_d, n_el, n_ne, n_i, x, Tnod, Td, u);

%% POSTPROCESS

% Plot of the deformed structure
plotBeam2D(x, Tnod, u, 50);

% Plot of the internal forces distribution
plotBeamIntForces(x, Tnod, Fx_el, Fy_el, Mz_el);

% Print displacement components at node 1, and for each element, print
% axial and shear stresses and bending moment at each node
printResults(n_el, n_ne, n_i, n_dof, Tnod, u, Fx_el, Fy_el, Mz_el);