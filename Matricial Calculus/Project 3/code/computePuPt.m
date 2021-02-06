function [pu, pt] = computePuPt(n_el, n_ne, n_i, x, Tnod, Td, u)
%--------------------------------------------------------------------------
% Inputs:
%   - n_el      Number of elements
%   - n_ne      Number of nodes for each element
%   - n_i       Number of DOFs for each node
%   - x         Matrix of nodal coordinates
%   - Tnod      Matrix of nodal connectivities
%   - Td        Matrix of DOFs connectivities
%   - u         Displacements and rotations vector
%--------------------------------------------------------------------------
% It must provide as output:
%   - pu        Polynomial coefficients for displacements for each element [n_el x 4]
%   - pu        Polynomial coefficients for rotations for each element [n_el x 3]
%--------------------------------------------------------------------------

pu = zeros(n_el, 4);
pt = zeros(n_el, 3);

% For each bar element
for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [Le, Re] = computeLeRe(n_i, n_ne, e, x, Tnod);
    
    % OBTAIN ELEMENT'S DISPLACEMENT IN GLOBAL COORDINATES
    u_e = zeros(n_ne*n_i,1);
    for i = 1:n_ne*n_i
        I = Td(e,i);
        u_e(i,1) = u(I,1);
    end
    
    % OBTAIN ELEMENT'S DISPLACEMENT IN LOCAL COORDINATES
    u_e_local = Re * u_e;
    
    % COMPUTE ELEMENT'S DEFLECTION AND ROTATION POLYNOMIAL COEFFICIENTS
    DRM = computeDRM(n_ne, n_i, Le);
    coefs = DRM * u_e_local / Le^3;
    
    % ASSIGN TO pu AND pt
    pu(e,:) = [coefs(1), coefs(2), coefs(3), coefs(4)];
    pt(e,:) = [3*coefs(1), 2*coefs(2), coefs(3)];
end

end