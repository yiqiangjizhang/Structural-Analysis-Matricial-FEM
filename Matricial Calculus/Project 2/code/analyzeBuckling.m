function [] = analyzeBuckling(n_d, n_el, x, Tnod, mat, Tmat, sig)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Number of dimensions of the problem
%                  n_el       Number of elemsnts
%   - x     Nodal coordinates matrix [n x n_d]
%   - Tnod  Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Print in console whether element e has no buckling (0) or it has (1)
%--------------------------------------------------------------------------

sig_cr = zeros(n_el, 1);
% Computation of critical tension
for e = 1:n_el
    % Compute bar length
    L_e = 0; 
    for n = 1:n_d
        xi = x(Tnod(e,1), n);
        xj = x(Tnod(e,2), n);
        L_e = L_e + (xj - xi)^2;
    end
    L_e = sqrt(L_e);
    % Check if there is buckling
    sig_cr(e) = (pi^2) * (mat(Tmat(e),1)*mat(Tmat(e),4)) / (mat(Tmat(e),2) * L_e^2);    
end

% Print tension, critical tension and buckling for every element
fprintf("%5s%15s%15s%15s\n", "e", "sig (MPa)", "sig_cr (MPa)", "buckling");
for e = 1:n_el
    buckling = 0;
    if sig(e) < 0 && sig_cr(e) <= abs(sig(e))
        buckling = 1;
    end
    fprintf("%5d%15.3f%15.3f%15d\n", e, sig(e)*1e-6, sig_cr(e)*1e-6, buckling);
end

for e = 1:n_el
    buckling = 0;
    if sig(e) < 0 && sig_cr(e) <= abs(sig(e))
        buckling = 1;
    end
    fprintf("%d\t%.3f\t%.3f\t%d\n", e, sig(e)*1e-6, sig_cr(e)*1e-6, buckling);
end

end