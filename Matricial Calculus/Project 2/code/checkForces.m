function [F, M] = checkForces(g, x, Mdata, lift, thrust, drag)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - g     Earth's gravity
%   - x     Nodal coordinates matrix 
%   - Mdata Matrix with mass assigned to each node
%   - thrust    Modulus of thrust
%   - lift      Modulus of lift
%   - drag      Modulus of drag
%--------------------------------------------------------------------------
% It must provide as output:
%   - F     Vectorial sum of all forces
%   - M     Vectorial sum of all moments
%--------------------------------------------------------------------------
% In section B1, if F == 0 and M == 0, then forces are well computed

% Creation of vectors for each force
t = [thrust, 0, 0];
d = [-drag, 0, 0];
l = [0, 0, lift];
w = [0, 0, -g*sum(Mdata)];

% Moment on node 1, around node 4
r = x(1,:) - x(4,:); % Position of node 1 respect to node 4
w1 = [0, 0, -g*Mdata(1)]; % Weight on node 1
M1 = cross(r, t/2 + w1); % Moment on node 1 around node 4

% Moment on node 2, around node 4
r = x(2,:) - x(4,:); % Position of node 2 respect to node 4
w2 = [0, 0, -g*Mdata(2)]; % Weight on node 2
M2 = cross(r, t/2 + w2); % Moment on node 2 around node 4

% Moment on node 3, around node 4
r = x(3,:) - x(4,:); % Position of node 3 respect to node 4
w3 = [0, 0, -g*Mdata(3)]; % Weight on node 3
M3 = cross(r, l/4 + d/4 + w3); % Moment on node 3 around node 4

% Moment on node 4, around node 4
r = x(4,:) - x(4,:); % Position of node 4 respect to node 4
w4 = [0, 0, -g*Mdata(4)]; % Weight on node 4
M4 = cross(r, l/4 + d/4 + w4); % Moment on node 4 around node 4

% Moment on node 5, around node 4
r = x(5,:) - x(4,:); % Position of node 5 respect to node 4
w5 = [0, 0, -g*Mdata(5)]; % Weight on node 5
M5 = cross(r, l/4 + d/4 + w5); % Moment on node 5 around node 4

% Moment on node 6, around node 4
r = x(6,:) - x(4,:); % Position of node 6 respect to node 4
w6 = [0, 0, -g*Mdata(6)]; % Weight on node 6
M6 = cross(r, l/4 + d/4 + w6); % Moment on node 6 around node 4

% Vectorial sum of forces and moments
F = t + d + l + w;
M = M1 + M2 + M3 + M4 + M5 + M6;

end

