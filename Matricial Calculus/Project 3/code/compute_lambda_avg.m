function lambda_avg = compute_lambda_avg(L1, L2, M, a, b)
%--------------------------------------------------------------------------
% Inputs:
%   - L1  Length of first subdomain
%   - L2  Length of second subdomain
%   - M   Semiwing mass
%   - a   Lower integration limit
%   - b   Upper integration limit
%--------------------------------------------------------------------------
% It must provide as output:
%   - lambda_avg   Average value of q over [a,b], i.e., integral of lamda 
%   over [a,b] divided by (b-a)
%--------------------------------------------------------------------------

lambda_avg = 0;
if a >= 0 && b <= L1
    lambda_1 = @(x) M/(4*(L1+L2)) + 3*M*(L1-x)/(2*L1^2);
    lambda_avg = integral(lambda_1, a, b)/(b - a);
elseif a >= L1 && b <= L1 + L2
    lambda_2 = @(x) M/(4*(L1+L2)) + 0*x;
    lambda_avg = integral(lambda_2, a, b)/(b - a);
end

end
