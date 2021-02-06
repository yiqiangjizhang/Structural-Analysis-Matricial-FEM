function [Le, Re] = computeLeRe(n_d, n_ne, n_i, e, x, Tnod)
%--------------------------------------------------------------------------
% Inputs:
%   - n_d           Number of dimensions of the problem
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - e             Number of element
%   - x             Matrix of nodal coordinates
%   - Tnod          Matrix of nodal connectivities 
%--------------------------------------------------------------------------
% Outputs:
%   - Le            Length of element e
%   - Re            Rotation matrix for element e
%--------------------------------------------------------------------------

Le = 0; % Element's length
Re = zeros(n_ne*n_i, n_ne*n_i); % Rotation matrix
for n = 1:n_d
    x1 = x(Tnod(e,1), n);
    x2 = x(Tnod(e,2), n);
    Le = Le + (x2 - x1)^2;
    Re(1,n) = x2 - x1;
    Re(2,n_i-n) = x2 - x1;
end
Le = sqrt(Le); % Element's length defined
Re(2,1) = -Re(2,1); 
Re(3,3) = Le;
Re(4:6,4:6) = Re(1:3,1:3);
Re = Re / Le; % Rotation matrix defined

end