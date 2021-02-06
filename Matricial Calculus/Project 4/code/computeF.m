function Fext = computeF(n_i, n_dof, Fdata)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  n_i         Number of DOFs per node
%                  n_dof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% Outputs:
%   - Fext  Global force vector [n_dof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------

Fext = zeros(n_dof, 1);
for i = 1:size(Fdata, 1)
    Fext(n_i * Fdata(i,1) - (n_i - Fdata(i,2))) = Fdata(i,3);    
end

end