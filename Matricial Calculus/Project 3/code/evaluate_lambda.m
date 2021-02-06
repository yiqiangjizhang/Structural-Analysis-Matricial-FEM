function lambda = evaluate_lambda(L1, L2, M, x)
%--------------------------------------------------------------------------
% Inputs:
%   - L1  Length of first subdomain
%   - L2  Length of second subdomain
%   - M   Semiwing mass
%   - x   Position in which lambda is to be evaluated
%--------------------------------------------------------------------------
% It must provide as output:
%   - lambda   lambda(x)
%--------------------------------------------------------------------------

lambda = 0;
if x >= 0 && x < L1
    lambda = 3*M*(L1-x)/(2*L1^2) + M/(4*(L1+L2));
elseif x >= L1 && x <= L1 + L2
    lambda = M/(4*(L1+L2));
end

end