function KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el       Total number of elements
%                  n_el_dof   Number of DOFs per element
%                  n_dof      Total number of DOFs
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - KG    Global stiffness matrix [n_dof x n_dof]
%            KG(I,J) - Term in (I,J) position of global stiffness matrix
%--------------------------------------------------------------------------

KG = zeros(n_dof, n_dof); % Global stiffness matrix

% Assembling Kel to KG
for e = 1:n_el
    for i = 1:n_el_dof
        I = Td(e,i);
        for j = 1:n_el_dof
            J = Td(e,j);
            KG(I,J) = KG(I,J) + Kel(i,j,e);
        end        
    end
end

end