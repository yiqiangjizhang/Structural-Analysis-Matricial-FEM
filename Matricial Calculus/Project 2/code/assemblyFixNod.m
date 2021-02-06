function [fixNod] = assemblyFixNod(matrix)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - matrix:   restriction matrix whose structure is described in
%               findAllFixNod function
%--------------------------------------------------------------------------
% It must provide as output:
%   - fixNod   Fix nodes matrix
%--------------------------------------------------------------------------

% Compute sum of matrix, which is the total number of dofs with
% displacement restrictions
sum = 0;
for i = 1:size(matrix,1)
    for j = 1:size(matrix,2)
        sum = sum + matrix(i,j);
    end
end

fixNod = zeros(sum, 3);
fixNod(:,3) = 0; %All displacements must be 0

row = 1;
for node = 1:size(matrix,2)
    for dof = 1:size(matrix,1)
        if matrix(dof,node) == 1
            fixNod(row,1) = node;
            fixNod(row,2) = dof;
            row = row + 1;
        end
    end
end

end