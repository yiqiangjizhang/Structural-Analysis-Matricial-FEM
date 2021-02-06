function [x] = computeNodalCoordinates(n_d, n_nod, nel_part_k, L1, L2)
%--------------------------------------------------------------------------
% Inputs:
%   - n_el          Number of elements
%   - n_d           Number of dimensions
%   - n_nod         Total number of nodes (joints)
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - n_dof         Total number of degrees of freedom
%   - n_el_dof      Number of DOFs for each element
%   - nel_part_k    Number of elements in which every subdomain is divided
%   - L1            Length of the first subdomain
%   - L2            Length of the second subdomain
%--------------------------------------------------------------------------
% It must provide as output:
%   - x        Matrix of nodal coordinates
%--------------------------------------------------------------------------

% Setting Nodal Coordinates (x,y)
x = zeros(n_nod, n_d);

% Computing x coordinate
for n = 1:nel_part_k+1
    x(n, 1) = (n-1) * L1 / nel_part_k;
end

% Computing y coordinate
for n = 2:nel_part_k+1
    x(n+nel_part_k, 1) = (n-1) * L2 / nel_part_k + L1;
end

end