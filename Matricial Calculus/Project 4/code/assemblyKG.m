function KG = assemblyKG(n_el, n_dof, n_el_dof, Td, Kel)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  n_el       Total number of elements
%                  n_dof      Total number of DOFs
%                  n_el_dof   Number of DOFs per element
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------
% Outputs:
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