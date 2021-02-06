function Fe_local = computeFeLocal(L1, L2, l, M, g, n_ne, n_i, e, Le, x, Tnod, method)
%--------------------------------------------------------------------------
% Inputs:
%   - L1            Length of the first subdomain
%   - L2            Length of the second subdomain
%   - l             Equilibrium parameter
%   - M             Semiwing mass
%   - g             Gravity
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - e             Number of element
%   - Le            Length of element e
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
%   - Fe_local      Element force vector in local coordinates
%--------------------------------------------------------------------------

% COMPUTATION FORCES IN Z DIRECTION
Fe_local = zeros(n_ne*n_i, 1);
Fe_local(1) = 1;
Fe_local(2) = Le/6;
Fe_local(3) = 1;
Fe_local(4) = -Le/6;

a = x(Tnod(e,1),1);
b = x(Tnod(e,2),1);
q_avg = 0; %#ok<NASGU>
lambda_avg = 0; %#ok<NASGU>
if method == 2 %Trapeze integration method
    q_avg = (evaluate_q(L1, L2, l, a)+evaluate_q(L1, L2, l, b))/2;
    lambda_avg = (evaluate_lambda(L1, L2, M, a)+evaluate_lambda(L1, L2, M, b))/2;
elseif method == 3
    q_avg = compute_q_avg(L1, L2, l, a, b);
    lambda_avg = compute_lambda_avg(L1, L2, M, a, b);
else
    q_avg = evaluate_q(L1, L2, l, (a+b)/2);
    lambda_avg = evaluate_lambda(L1, L2, M, (a+b)/2);
end
load_avg = q_avg - g*lambda_avg;
Fe_local = Fe_local * load_avg * Le / 2;

end