%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date: 02/03/2020
% Author/s: Pedro López; Yi Qiang Ji
%

clear;
close all;
clc;

%% INPUT DATA

% Geometric data
L = 0.75;
B = 3;
H = 0.75;
Fz = -1000;
D1 = 21e-3; 
d1 = 5e-3;
D2 = 2e-3;

% Mass
M = 120;

% Other
g = 9.81;

%% PREPROCESS

% Nodal coordinates matrix 
%  x(a,j) = coordinate of node a in the dimension j
%{
x = [%      X       Y       Z
            0,      0,      0; % (1)
            0,      L,      0; % (2)
            0,      L,      L; % (3)
            0,      0,      L; % (4)
            L,    L/2,    L/2  % (5)
];
%}
x = [%      X       Y       Z
            -L/2       -L/2    -L/2;
            -L/2       L/2     -L/2;
            -L/2       L/2     L/2;
            -L/2       -L/2    L/2;
            L/2       0       0;
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tnod = [%     a      b
           1,     5; % (1)
           2,     5; % (2)
           3,     5; % (3)
           4,     5; % (4)
];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [%  Node    DOF Magnitude
            5       3   Fz
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [% Node    DOF     Magnitude
            1       1       0;
            1       2       0;
            1       3       0;
            2       1       0;
            2       2       0;
            2       3       0;
            3       1       0;
            3       2       0;
            3       3       0;
            4       1       0;
            4       2       0;
            4       3       0;
% Write the data here...
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  mat(m,4) = Section inertia of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.        Section A.    Density 
            70e9, pi/4*(D1^2-d1^2),       2200;  % Material (1)
           200e9,        pi/4*D2^2,       1300;  % Material (2)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [% Mat. index
                   1; % (1)
                   1; % (2)
                   1; % (3)
                   1; % (4)
                   1; % (5)
];

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tnod,1);          % Total number of elements
n_nod = size(Tnod,2);         % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element

% Computation of the DOFs connectivities
Td = connectDOFs(n_el, n_nod, n_i, Tnod);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d, n_el, x, Tnod, mat, Tmat);

% Global matrix assembly
KG = assemblyKG(n_el, n_el_dof, n_dof, Td, Kel);

% Global force vector assembly
Fext = computeF(n_i, n_dof, Fdata);

% Apply conditions
[vL, vR, uR] = applyCond(n_i, n_dof, fixNod);

% System resolution
[u, R] = solveSys(vL, vR, uR, KG, Fext);

% Compute strain and stresses
[eps, sig] = computeStrainStressBar(n_d, n_el, u, Td, x, Tnod, mat, Tmat)


%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 1000; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u,sig,scale);

printEpsSig(eps, sig);