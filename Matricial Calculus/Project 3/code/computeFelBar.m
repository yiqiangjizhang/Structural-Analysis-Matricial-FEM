function Fel = computeFelBar(L1, L2, l, M, g, n_i, n_ne, n_el, x, Tnod, method)
%--------------------------------------------------------------------------
% Inputs:
%   - L1            Length of the first subdomain
%   - L2            Length of the second subdomain
%   - l             Equilibrium parameter
%   - M             Semiwing mass
%   - g             Gravity
%   - n_i      Number of DOFs per node
%   - n_ne     Number of nodes per element
%   - n_el     Number of Elements
%   - x             Matrix of nodal coordinates
%   - Tnod          Matrix of nodal connectivities
%   - method        Method to compute average load
%                   1 Evaluate q and lambda at (a+b)/2 (mid point)
%                   2 Evaluate q and lambda by numerical integration, using
%                   trapeze method, and dividing by interval length
%                   3 Evaluate q and by numerical integration, using matlab
%                   function, and dividing by interval length
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fel   Element force vectors 
%--------------------------------------------------------------------------

Fel = zeros(n_ne*n_i, n_el);

% For each bar
for e = 1:n_el
    % COMPUTE BAR LENGTH AND ROTATION MATRIX
    [Le, Re] = computeLeRe(n_i, n_ne, e, x, Tnod);    
    
    % COMPUTE FORCE VECTOR FOR ELEMENT e
    Fe_local = computeFeLocal(L1, L2, l, M, g, n_ne, n_i, e, Le, x, Tnod, method);   
    
    % COMPUTE FORCE VECTOR IN GLOBAL COORDINATES AND ASSIGN
    Fel(:,e) = (Re') * Fe_local;
end

end