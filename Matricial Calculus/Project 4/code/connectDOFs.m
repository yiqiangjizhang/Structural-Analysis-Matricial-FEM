function Td = connectDOFs(n_el, n_ne, n_i, Tnod)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  n_el     Number of elements
%                  n_ne     Number of nodes for each element
%                  n_i      Number of DOFs for each node
%   - Tnod    Nodal connectivities table [n_el x n_ne]
%            Tnod(e,a) - Nodal number associated to node a of element e
%--------------------------------------------------------------------------
% Outputs:
%   - Td    DOFs connectivities table [n_el x n_ne*n_i]
%            Td(e,i) - DOF i associated to element e
%--------------------------------------------------------------------------

% Computation of Td matrix
Td = zeros(n_el, n_ne*n_i);
% Addition of the global DOF for each element
for i = 1:n_el
    for j = 1:n_i
        Td(i,j) = n_i * Tnod(i,1) - (n_i - j);
        Td(i,j + n_i) = n_i * Tnod(i,2) - (n_i - j);
    end
end

end