function Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
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

n_nod = size(Tn, 2); % Number of nodes for each element
Kel = zeros(n_d * n_nod, n_d * n_nod, n_el); % Elemental stiffnes matrix

% Stiffness matrix computation (cosidering 2D problem)
for e = 1:n_el
    Le = 0; % Element bar length
    Re = zeros(2, n_d * n_nod); % Rotation matrix
    for n = 1:n_d
        xi = x(Tn(e,1), n);
        xj = x(Tn(e,2), n);
        Le = Le + (xj - xi)^2;
        Re(1, n) = xj - xi;
        Re(2, n_d + n) = xj - xi;
    end
    Le = sqrt(Le);
    Re = Re / Le;
    Ke_local = mat(Tmat(e),1) * mat(Tmat(e),2) * [1, -1; -1, 1] / Le;
    Ke_global = (Re') * Ke_local * Re;
    Kel(:,:,e) = Ke_global;
end

end