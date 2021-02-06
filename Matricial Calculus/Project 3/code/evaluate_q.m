function q = evaluate_q(L1, L2, l, x)
%--------------------------------------------------------------------------
% Inputs:
%   - L1  Length of first subdomain
%   - L2  Length of second subdomain
%   - l   Equilibrium parameter
%   - x   Position in which q is to be evaluated
%--------------------------------------------------------------------------
% It must provide as output:
%   - q   q(x)
%--------------------------------------------------------------------------

q = 0;
if x >= 0 && x < L1
    q = l*(0.85 - 0.15*cos(pi*x/L1));
elseif x >= L1 && x <= L1 + L2
    q = -l*(L1 - L2 - x)*(L1 + L2 - x)/L2^2;
end

end