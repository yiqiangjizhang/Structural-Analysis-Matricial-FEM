function q_avg = compute_q_avg(L1, L2, l, a, b)
%--------------------------------------------------------------------------
% Inputs:
%   - L1  Length of first subdomain
%   - L2  Length of second subdomain
%   - l   Equilibrium parameter
%   - a   Lower integration limit
%   - b   Upper integration limit
%--------------------------------------------------------------------------
% It must provide as output:
%   - q_avg   Average value of q over [a,b], i.e., integral of q over [a,b]
%   divided by (b-a)
%--------------------------------------------------------------------------

q_avg = 0;
if a >= 0 && b <= L1
    q_1 = @(x) l*(0.85-0.15*cos(pi*x/L1));
    q_avg = integral(q_1, a, b)/(b - a);
elseif a >= L1 && b <= L1 + L2
    q_2 = @(x) -l*(L1-L2-x).*(L1+L2-x)/L2^2;
    q_avg = integral(q_2, a, b)/(b - a);
end

end