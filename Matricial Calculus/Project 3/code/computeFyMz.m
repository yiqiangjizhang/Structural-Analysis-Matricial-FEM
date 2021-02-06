function [Fy, Mz] = computeFyMz(n_el, n_ne, n_i, Tnod, Td, x, Kel, u)
%--------------------------------------------------------------------------
% Inputs:
%   - n_el          Number of elements
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - Tnod          Matrix of nodal connectivities 
%   - Td            Matrix of DOFs connectivies
%   - x             Matrix of nodal coordinates
%   - Kel           Tensor containing stiffness matrices in global coordinates
%   - u             Displacements and rotations vector
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fy            Shear force in local coordinates for each element
%   - Mz            Bending moment in local coordinates for each element
%--------------------------------------------------------------------------

Fy = zeros(n_el, 2);
Mz = zeros(n_el, 2);

for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [~, Re] = computeLeRe(n_i, n_ne, e, x, Tnod);  
    % OBTAIN ELEMENT'S DISPLACEMENT IN GLOBAL COORDINATES
    u_e = zeros(n_ne*n_i,1);
    for i = 1:n_ne*n_i
        I = Td(e,i);
        u_e(i,1) = u(I,1);
    end    
    % COMPUTE INTERNAL FORCES IN LOCAL COORDINATES
    F_int = Kel(:,:,e) * u_e;
    F_int_local = Re * F_int;    
    % COMPUTE SHEAR FORCE
    Fy(e,1) = -F_int_local(n_i-1);
    Fy(e,2) = F_int_local(2*n_i-1);    
    % COMPUTE BENDING MOMENT
    Mz(e,1) = -F_int_local(n_i);
    Mz(e,2) = F_int_local(2*n_i);       
end

end

