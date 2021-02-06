function [Le, Re] = computeLeRe(n_i, n_ne, e, x, Tnod)
%--------------------------------------------------------------------------
% Inputs:
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - e             Number of element
%   - x             Matrix of nodal coordinates
%   - Tnod          Matrix of nodal connectivities 
%--------------------------------------------------------------------------
% It must provide as output:
%   - Le            Length of element e
%   - Re            Rotation matrix for element e
%--------------------------------------------------------------------------

% Compute element's length
x1 = x(Tnod(e,1), 1);
x2 = x(Tnod(e,2), 1);
Le = sqrt((x2-x1)^2);

% Compute rotation matrix
Re = zeros(n_ne*n_i, n_ne*n_i);
Re(1,1) = x2 - x1;
Re(2,2) = Le;
Re(3,3) = x2 - x1;
Re(4,4) = Le;
Re = Re / Le;

end