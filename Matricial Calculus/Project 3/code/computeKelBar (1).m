function Kel = computeKelBar(n_d,n_el,x,Tnod,mat,Tmat,R)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tnod    Nodal connectivities table [n_el x n_nod]
%            Tnod(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------

n_nod = size(Tnod, 2); % Number of nodes for each element
Kel = zeros(n_d * n_nod, n_d * n_nod, n_el); % Elemental stiffnes matrix

% Stiffness matrix computation (cosidering 2D problem)
for e = 1:n_el
    % Compute element bar length and rotation matrix
    Le = 0; % Element bar length
    for n = 1:n_d
        xi = x(Tnod(e,1), n);
        xj = x(Tnod(e,2), n);
        Le = Le + (xj - xi)^2;
    end
    Le = sqrt(Le);
    % Compute Ke local
    Ke_local = computeKeLocal(n_d, e, Le, mat, Tmat);
    % Obtain rotation matrix for element e
    Re = R(:,:,e);
    % Compute Ke global
    Ke_global = (Re') * Ke_local * Re;
    Kel(:,:,e) = Ke_global;
end

end