function [pu, pt, eps] = computePuPtEps(n_d, n_el, n_ne, n_i, x, Tnod, Td, u)
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
%   - u     Displacements vector
%--------------------------------------------------------------------------
% Outputs:
%   - pu    Deflection polynomial coefficients [n_el x 4]
%   - pt    Rotation polynomial coefficients [n_el x 3]
%   - eps   Axial strain [n_el x 1]
%--------------------------------------------------------------------------

pu = zeros(n_el, 4);  % Deflection polynomial coefficients
pt = zeros(n_el, 3);  % Rotation polynomial coefficients
eps = zeros(n_el, 1); % Axial strain

% Compute deflection and rotation polynomial coefficients and axial strain
% for each element
for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [Le, Re] = computeLeRe(n_d, n_ne, n_i, e, x, Tnod);
    % COMPUTE ELEMENT'S DISPLACEMENT IN GLOBAL COORDINATES
    u_e = zeros(n_ne*n_i,1);
    for i = 1:n_ne*n_i
        I = Td(e,i);
        u_e(i,1) = u(I,1);
    end
    % COMPUTE ELEMENT'S DISPLACEMENT IN LOCAL COORDINATES
    u_e = Re * u_e;
    % COMPUTE ELEMENT'S DEFLECTION AND ROTATION POLYNOMIAL COEFFICIENTS
    coef = computeDRM(Le) * u_e;
    pu(e,1:4) = coef';
    pt(e,1:3) = [3*coef(1), 2*coef(2), coef(3)];
    % COMPUTE ELEMENT'S AXIAL STRAIN
    eps(e,1) = [-1 0 0 1 0 0] * u_e / Le; 
end

end