function Ke_local = computeKeLocal(n_i, n_ne, e, Le, mat, Tmat)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  n_i      Number of DOFs per node
%                  n_ne     Number of nodes per element
%   - e     Number of element
%   - Le    Element's length
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%            mat(m,3) - Section inertia of material m
%   - Tmat  Material connectivities table [nel]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Ke_local   Elemental stiffness matrix in local coordinates
%                [n_ne*n_i x n_ne*n_i]
%--------------------------------------------------------------------------

Ke_local = zeros(n_ne*n_i, n_ne*n_i);

% Row 1
Ke_local(1,1) = 12;
Ke_local(1,2) = 6*Le;
Ke_local(1,3) = -12;
Ke_local(1,4) = 6*Le; 
% Row 2
Ke_local(2,1) = 6*Le;
Ke_local(2,2) = 4*Le^2;
Ke_local(2,3) = -6*Le;
Ke_local(2,4) = 2*Le^2; 
% Row 3
Ke_local(3,1) = -12;
Ke_local(3,2) = -6*Le;
Ke_local(3,3) = 12;
Ke_local(3,4) = -6*Le; 
% Row 4
Ke_local(4,1) = 6*Le;
Ke_local(4,2) = 2*Le^2;
Ke_local(4,3) = -6*Le;
Ke_local(4,4) = 4*Le^2; 

Ke_local = (mat(Tmat(e),1)*mat(Tmat(e),2)/Le^3)*Ke_local;

end