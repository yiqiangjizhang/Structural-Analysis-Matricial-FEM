function [vL,vR,uR] = applyCond(n_i,n_dof,fixNod)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i      Number of DOFs per node
%                  n_dof    Total number of DOFs
%   - fixNod  Prescribed displacements data [Npresc x 3]
%              fixNod(k,1) - Node at which the some DOF is prescribed
%              fixNod(k,2) - DOF (direction) at which the prescription is applied
%              fixNod(k,3) - Prescribed displacement magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%--------------------------------------------------------------------------

vR = zeros(size(fixNod,1), 1);
uR = zeros(size(fixNod,1), 1);

% Applying boundary conditions
for i = 1:size(vR,1)
    vR(i) = n_i * fixNod(i,1) - (n_i - fixNod(i,2));
    uR(i) = fixNod(i,3);
end

vL = setdiff(1:n_dof, vR)';

end