%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date:
% Author/s:
%

clear;
close all;

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
                   1; % (6)
                   1; % (7)
                   1; % (8)
                   2; % (9)
                   2; % (10)
                   2; % (11)
                   2; % (12)
];

%% SOLVER

% Write your code here...

%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u,sig,scale);