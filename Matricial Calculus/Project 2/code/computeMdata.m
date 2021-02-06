function [Mdata] = computeMdata(n, n_d, n_el, x, M, Tnod, mat, Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n           Total number of nodes
%                  n_d         Number of dimensions
%                  n_el        Number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - M     Pilots's mass
%   - Tnod  Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Mdata  Mass vector [n x 1]
%            Mdata(I) - Total mass on node I
%--------------------------------------------------------------------------

% Declare Mdata matrix
Mdata = zeros(n, 1);

% For each bar element
for e = 1:n_el
    % Compute element length
    L_e = 0;
    for i = 1:n_d
        xi = x(Tnod(e,1), i);
        xj = x(Tnod(e,2), i);
        L_e = L_e + (xj - xi)^2;
    end
    L_e = sqrt(L_e);
    % Compute element mass
    mass = L_e * mat(Tmat(e),2) * mat(Tmat(e),3);
    % Add mass/2 to the corresponding nodes
    Mdata(Tnod(e,1)) = Mdata(Tnod(e,1)) + mass/2;
    Mdata(Tnod(e,2)) = Mdata(Tnod(e,2)) + mass/2;    
end

% Assign half of mass M to nodes 1 and 2
Mdata(1) = Mdata(1) + M/2;
Mdata(2) = Mdata(2) + M/2;

end

