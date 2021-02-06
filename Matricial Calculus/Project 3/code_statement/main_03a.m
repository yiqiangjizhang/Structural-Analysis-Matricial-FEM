%-------------------------------------------------------------------------%
% ASSIGNMENT 03 - (A)
%-------------------------------------------------------------------------%
% Date: 09/03/20
% Author/s: Pedro López; Yi Qiang Ji
%

clear;
close all;

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

%% PRECOMPUTATIONS

% Compute section: 
% A  - Section area
A = b * h - 2 * ((b/2 - a/2) * (h - t));

% Iy - Section inertia
Iy = 1/12 * h^3 * b - 2 * 1/12 * ((b/2 - a/2) * (h - t)); % Section inercia calculated by difference of inertias


% Compute parameter l:
% l - Equilibrium parameter

% Plot analytical solution
fig = plotBeamsInitialize(L1+L2);

% Loop through each of the number of elements
for k = 1:length(nel_part)

    %% PREPROCESS
    
    % Number of elements
    nel = nel_min*nel_part(k);
    % Number of nodes
    nnod = nel+1;
    
    % Nodal coordinates
    %  x(a,j) = coordinate of node a in the dimension j
    % Complete the coordinates
    
    % Nodal connectivities  
    %  Tnod(e,a) = global nodal number associated to node a of element e
    Tnod = zeros(nel,2);
    for e = 1:nel
        Tnod(e,1) = e;
        Tnod(e,2) = e+1;
    end
    
    % Material properties matrix
    %  mat(m,1) = Young modulus of material m
    %  mat(m,2) = Section area of material m
    %  mat(m,3) = Section inertia of material m
    mat = [% Young M.        Section A.    Inertia 
              E,                A,         Iy;  % Material (1)
    ];

    % Material connectivities
    %  Tmat(e) = Row in mat corresponding to the material associated to element e 
    Tmat = ones(nel,1);
        
    %% SOLVER
    
    % Compute:
    % u  - Displacements and rotations vector [ndof x 1]
    % pu - Polynomial coefficients for displacements for each element [nel x 4]
    % pt - Polynomial coefficients for rotations for each element [nel x 3]
    % Fy - Internal shear force at each elements's nodes [nel x nne]
    % Mz - Internal bending moment at each elements's nodes [nel x nne]
    
    %% POSTPROCESS
    
    % Number of subdivisions and plots
    nsub = nel_part(end)/nel_part(k);
    plotBeams1D(fig,x,Tnod,nsub,pu,pt,Fy,Mz)
    drawnow;
    
end

% Add figure legends
figure(fig)
legend(strcat('N=',cellstr(string(nel_part))),'location','northeast');