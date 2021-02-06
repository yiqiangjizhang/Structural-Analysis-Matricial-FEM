%-------------------------------------------------------------------------%
% ASSIGNMENT 01
%-------------------------------------------------------------------------%
% Date: 24/02/2020
% Author/s: Pedro López; Yi Qiang Ji
%

clear;
close all;
clc;

%% INPUT DATA

F = 750; % N
E = 70e9; % Pa
A = 72e-6; % m^2
rho = 2200; % kg/m^3

%% PREPROCESS

% Nodal coordinates matrix creation
%  x(a,j) = coordinate of node a in the dimension j
x = [%  X       Y
		0		0; % (1)
        0.5		0.2; % (2)
        1		0.4; % (3)
        1.5		0.6; % (4)
        0		0.5; % (5)
        0.5		0.6; % (6)
        1		0.7; % (7)
        1.5		0.8; % (8)
];

% Connectivities matrix ceation
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [%     a       b
            1       2;   %1
            2       3;   %2
            3       4;   %3
            5       6;   %4         
            6       7;   %5
            7       8;   %6
            1       5;   %7
            1       6;   %8
            2       5;   %9
            2       6;   %10
            2       7;   %11
            3       6;   %12
            3       7;   %13
            3       8;   %14
            4       7;   %15
            4       8   %16            
            % Write the data here...
];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [%  Node    DOF Magnitude
            2       2   F;
            3       2   F;
            4       2   F   % Write the data here...
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [% Node    DOF     Magnitude
            1       1       0;
            1       2       0;
            5       1       0;
            5       2       0
% Write the data here...
];

% Material data
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.   Section A.       Density
                E,           A,      rho;  % Material (1)
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
                   1; % (9)
                   1; % (10)
                   1; % (11)
                   1; % (12)
                   1; % (13)
				   1; % (14)
				   1; % (15)
				   1; % (16)
];

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

% Computation of the DOFs connectivities
Td = connectDOFs(n_el,n_nod,n_i,Tn);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);

% Global force vector assembly
Fext = computeF(n_i,n_dof,Fdata);

% Apply conditions 
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);

% System resolution
[u,R] = solveSys(vL,vR,uR,KG,Fext);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat);

%% POSTPROCESS

% Plot displacements
plotDisp(n_d,n,u,x,Tn,1);

% Plot strains
plotStrainStress(n_d,eps,x,Tn,{'Strain'});

% Plot stress
plotStrainStress(n_d,sig,x,Tn,{'Stress';'(Pa)'});

% Plot stress in defomed mesh
plotBarStressDef(x,Tn,u,sig,1);