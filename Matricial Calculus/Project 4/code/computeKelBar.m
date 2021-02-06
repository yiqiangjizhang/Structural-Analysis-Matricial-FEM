function Kel = computeKelBar(n_d, n_el, n_ne, n_i, x, Tnod, mat, Tmat)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  
%                  n_el       Total number of elements
%                  n_ne       Number of nodes for each element
%                  n_i        Number of DOFs for each node
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tnod    Nodal connectivities table [nel x n_nod]
%            Tnod(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%            mat(m,3) - Section inertia of material m
%   - Tmat  Material connectivities table [nel]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% Outputs:
%   - Kel   Elemental stiffness matrices [n_nod*(n_i+1) x n_nod*(n_i+1) x nel]
%--------------------------------------------------------------------------

Kel = zeros(n_ne*n_i, n_ne*n_i, n_el); % Element stiffness tensor

% STIFFNESS MATRIX COMPUTATION
for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [Le, Re] = computeLeRe(n_d, n_ne, n_i, e, x, Tnod);
    
    % COMPUTE STIFFNESS MATRIX IN LOCAL COORDINATES
    Ke_local = computeKeLocal(n_ne, n_i, Le, e, mat, Tmat);    
    
    % COMPUTE STIFFNESS MATRIX IN GLOBAL COORDINATES AND ASSIGN
    Ke = Re' * Ke_local * Re;
    Kel(:,:,e) = Ke;
end

end