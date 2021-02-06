function Ke_local = computeKeLocal(n_ne, n_i, Le, e, mat, Tmat)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  
%                  n_ne       Number of nodes for each element
%                  n_i        Number of DOFs for each node
%   - Le    Element's length
%   - e     Number of element
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%            mat(m,3) - Section inertia of material m
%   - Tmat  Material connectivities table [nel]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% Outputs:
%   - Ke_local   Stiffness matrix in local coordinates
%--------------------------------------------------------------------------

% Ke_local LEFT MATRIX 
Ke_1 = zeros(n_ne*n_i, n_ne*n_i);
% Row 2
Ke_1(2,2) = 12;
Ke_1(2,3) = 6*Le;
Ke_1(2,5) = -12;
Ke_1(2,6) = 6*Le;
% Row 3
Ke_1(3,3) = 4*Le^2;
Ke_1(3,5) = -6*Le;
Ke_1(3,6) = 2*Le^2;
% Row 5
Ke_1(5,5) = 12;
Ke_1(5,6) = -6*Le;
% Row 6
Ke_1(6,6) = 4*Le^2;
% Symmetrization
for i = 1:size(Ke_1,1)
    for j = 1:i-1
        Ke_1(i,j) = Ke_1(j,i);
    end
end
Ke_1 = mat(Tmat(e),1) * mat(Tmat(e),3) * Ke_1 / Le^3;

% Ke_local RIGHT MATRIX
Ke_2 = zeros(n_ne*n_i, n_ne*n_i);
Ke_2(1,1) = 1;
Ke_2(1,4) = -1;
Ke_2(4,1) = -1;
Ke_2(4,4) = 1;
Ke_2 = mat(Tmat(e),1) * mat(Tmat(e),2) * Ke_2 / Le;

% Ke_local COMPUTATION
Ke_local = Ke_1 + Ke_2;

end