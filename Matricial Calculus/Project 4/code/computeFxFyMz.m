function [Fx_el, Fy_el, Mz_el] = computeFxFyMz(n_d, n_el, n_ne, n_i, x, Tnod, Td, Kel, u)
%--------------------------------------------------------------------------
% Inputs:
%   - Dimensions:  
%                  n_d        Number of dimensions
%                  n_el       Number of elements
%                  n_ne       Number of nodes for each element
%                  n_i        Number of DOFs for each node
%   - x     Matrix of nodal coordinates
%   - Tnod  Matrix of nodal connectivities  
%   - Td    Matrix of DOF connectivities
%   - Kel   Tensor of element stiffness matrices
%   - u     Displacements vector
%--------------------------------------------------------------------------
% Outputs:
%   - Fx_el     Axial force vector
%   - Fy_el     Shear force vector
%   - Mz_el     Bending moment vector
%--------------------------------------------------------------------------

Fx_el = zeros(n_el, n_ne); %Axial force vector
Fy_el = zeros(n_el, n_ne); %Shear force vector
Mz_el = zeros(n_el, n_ne); %Bending force vector

% Compute Fx_el, Fy_el and Mz_el for each element
for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [~, Re] = computeLeRe(n_d, n_ne, n_i, e, x, Tnod);
    % COMPUTE ELEMENT'S DISPLACEMENT IN GLOBAL COORDINATES
    u_e = zeros(n_ne*n_i);
    for i = 1:n_ne*n_i
        I = Td(e,i);
        u_e(i,1) = u(I,1);
    end
    % COMPUTE INTERNAL FORCES IN LOCAL COORDINATES
    Fe_local = Re * (Kel(:,:,e) * u_e);
    % COMPUTE AXIAL FORCE
    Fx_el(e,1) = -Fe_local(n_i-2);
    Fx_el(e,2) = Fe_local(2*n_i-2);
    % COMPUTE SHEAR FORCE
    Fy_el(e,1) = -Fe_local(n_i-1);
    Fy_el(e,2) = Fe_local(2*n_i-1);
    % COMPUTE BENDING MOMENT
    Mz_el(e,1) = -Fe_local(n_i);
    Mz_el(e,2) = Fe_local(2*n_i);    
end

end