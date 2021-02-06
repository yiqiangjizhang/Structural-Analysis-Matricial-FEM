function [sells] = computeSells(n_el, n_d, x, Tn, mat, Tmat, v)
    
sells = 0; % Money earned selling extra material
for e = 1:n_el % For each bar element
    if v(e) == 0 % In case the element is not used, it can be sold
        % Compute the element length
        Le = 0;
        for n = 1:n_d
            xi = x(Tn(e,1), n);
            xj = x(Tn(e,2), n);
            Le = Le + (xj - xi)^2;
        end
        Le = sqrt(Le);
        % Compute the element volume and mass
        vol = Le * mat(Tmat(e), 2);
        mass = mat(Tmat(e), 3) * vol;
        % Compute the money earned selling the element
        sells = sells + 46 * mass;
    end    
end


end