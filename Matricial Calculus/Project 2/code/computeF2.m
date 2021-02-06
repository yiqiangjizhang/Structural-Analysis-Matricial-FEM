function Fext = computeF(n_i, n_dof, Fdata, Wdata)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i         Number of DOFs per node
%                  n_dof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%   - Wdata  External nodal weights [n x 3]
%            Wdata(k,1) - Node at which the weight is applied
%            Wdata(k,2) - DOF (direction) at which the weight acts (always
%            3)
%            Wdata(k,3) - Weight magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fext  Global force vector [n_dof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each force is applied.

Fext = zeros(n_dof, 1); % External force vector

% Forces in Fdata vector
for i = 1:size(Fdata,1)
    Fext(n_i * Fdata(i,1) - (n_i - Fdata(i,2))) = Fdata(i,3); 
end

% Weights in Wdata vector
for i = 1:size(Wdata,1)
    dof = n_i * Wdata(i,1) - (n_i - Wdata(i,2));
    Fext(dof) = Fext(dof) + Wdata(i,3);
end

end