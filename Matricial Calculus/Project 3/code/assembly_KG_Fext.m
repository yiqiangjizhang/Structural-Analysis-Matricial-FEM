function [KG, Fext] = assembly_KG_Fext(n_el, n_ne, n_i, n_dof, Td, Kel, Fel)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el       Total number of elements
%                  n_ne       Number of nodes for each element
%                  n_i        Number of DOFs for each node
%                  n_dof      Total number of DOFs
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%   - Fel   Element force vectors 
%--------------------------------------------------------------------------
% It must provide as output:
%   - KG    Global stiffness matrix [n_dof x n_dof]
%   - Fext  Global force vector
%--------------------------------------------------------------------------

KG = zeros(n_dof, n_dof); % Global stiffness matrix
Fext = zeros(n_dof, 1); % Global force vector

% ASSEMBLING Kel to KG AND Fel to Fext
for e = 1:n_el
    for i = 1:n_ne*n_i
        I = Td(e,i);
        Fext(I) = Fext(I) + Fel(i,e);
        for j = 1:n_ne*n_i
            J = Td(e,j);
            KG(I,J) = KG(I,J) + Kel(i,j,e);
        end        
    end
end

end
