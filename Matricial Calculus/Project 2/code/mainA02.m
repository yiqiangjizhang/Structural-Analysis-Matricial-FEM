%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date:
% Author/s:
%

clear;
close all;
clc;

%% INPUT DATA

% Geometric data
L = 0.75;
B = 3;
H = 0.75;
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
x = [%     X      Y      Z
         2*L,    -L,     0; % (1)
         2*L,     L,     0; % (2)
         2*L,     0,     H; % (3)
           0,     0,     H; % (4)
           0,    -B,     H; % (5)
           0,     B,     H; % (6)
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tnod = [%     a      b
           1,     2; % (1)
           3,     4; % (2)
           3,     5; % (3)
           4,     5; % (4)
           3,     6; % (5)
           4,     6; % (6)
           1,     3; % (7)
           2,     3; % (8)
           1,     4; % (9)
           2,     4; % (10)
           1,     5; % (11)
           2,     6; % (12)
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [% Node    DOF     Magnitude
            1       2       0;
            1       3       0;
            2       3       0;
            4       1       0;
            4       2       0;
            4       3       0;
%Write the data here...
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  mat(m,4) = Section inertia of material m
%  --more columns can be added for additional material properties--
mat = [%    Young M.        Section A.          Density     Section inertia
            70e9,           pi/4*(D1^2-d1^2),   2200,       (pi/64)*(D1^4-d1^4);     % Material (1)
            200e9,          pi/4*D2^2,          1300,       (pi/64)*D2^4;            % Material (2)
]; 

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [% Mat. index
                   1; % (1)
                   1; % (2)
                   1; % (3)
                   1; % (4)
                   1; % (5)
                   1; % (6)
                   1; % (7)
                   1; % (8)
                   2; % (9)
                   2; % (10)
                   2; % (11)
                   2; % (12)
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

% Computation of mass on every node
Mdata = computeMdata(n, n_d, n_el, x, M, Tnod, mat, Tmat);

% Computation of lift, thrust and drag
% "B1" to compute forces in section B1 and B2
% "B3" to compute forces in section B3 (1.25 * lift, 1.25 * drag)
[a, lift, weight, thrust, drag] = computeForces(g, L, H, Mdata, "B3");

% Check if the forces are well computed:
%   In sections B1 and B2, vectorial sum of forces and moments must be 0
%   In section B3, vectorial sum of moments must be 0
% Uncomment next line to check forces
%[F, M] = checkForces(g, x, Mdata, thrust, lift, drag);

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [%  Node    DOF     Magnitude
            1       1       thrust/2 - Mdata(1)*a(1);
            1       3       -g*Mdata(1) - Mdata(1)*a(3);
            2       1       thrust/2 - Mdata(2)*a(1);
            2       3       -g*Mdata(2) - Mdata(2)*a(3);
            3       1       -drag/4 - Mdata(3)*a(1);
            3       3       -g*Mdata(3)+lift/4 - Mdata(3)*a(3);
            4       1       -drag/4 - Mdata(4)*a(1);
            4       3       -g*Mdata(4)+lift/4 - Mdata(4)*a(3);
            5       1       -drag/4 - Mdata(5)*a(1);
            5       3       -g*Mdata(5)+lift/4 - Mdata(5)*a(3);
            6       1       -drag/4 - Mdata(6)*a(1);
            6       3       -g*Mdata(6)+lift/4 - Mdata(6)*a(3);
];

% Computation of the DOFs connectivities
Td = connectDOFs(n_el, n_nod, n_i, Tnod);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d, n_el, x, Tnod, mat, Tmat);

% Global matrix assembly
KG = assemblyKG(n_el, n_el_dof, n_dof, Td, Kel);

% Global force vector assembly
Fext = computeF(n_i, n_dof, Fdata);

% Compute all the possibilities of fixNod matrix
%findAllFixNod(n_i, n_dof, KG, Fext, 'data/matrices.txt', 'data/fixNodPossibilities.txt', 1e-10, 1e5);

% Apply conditions 
[vL,vR,uR] = applyCond(n_i, n_dof, fixNod);

% System resolution
[u,R] = solveSys(vL, vR, uR, KG, Fext);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar(n_d, n_el, u, Td, x, Tnod, mat, Tmat);

%% POSTPROCESS

% Print results
%printDisplacementReaction(u, R);
%printEpsSig(eps, sig);

% Check if there is buckling
analyzeBuckling(n_d, n_el, x, Tnod, mat, Tmat, sig);

% Plot deformed structure with stress of each bar
scale = 10; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x, Tnod, u, sig, scale);

