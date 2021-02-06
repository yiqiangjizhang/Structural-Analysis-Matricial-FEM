%-------------------------------------------------------------------------%
% ASSIGNMENT 04
%-------------------------------------------------------------------------%
% Date:
% Author/s:
%

clear;
close all;

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
alpha = 8; % �
rw = 0.58; % m
I0 = 230; % kg m2
dt = 0.75; % s
mu = 0.32; 
V = 235; % km/h

%% PRECOMPUTATIONS

% Compute section properties AA, AB (area), IzA, IzB (inertia) 

% Complete with your code...

% Compute forces (normal N and friction F)

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

% Dimensions
nel = nel_min*nel_part(k);    % Number of elements
nnod = nel+1;                 % Number of nodes
n_d = size(x,2);              % Number of dimensions
n_i = 3;                      % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_nod = size(Tnod,2);         % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element

%% SOLVER
    
% Complete with your code...

%% POSTPROCESS

% Plot of the deformed structure
plotBeam2D(x,Tnod,u,50);

% Plot of the internal forces distribution
plotBeamIntForces(x,Tnod,Fx_el,Fy_el,Mz_el);