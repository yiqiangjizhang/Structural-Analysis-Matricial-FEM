function F = computeElementForceVector()

F = zeros(2*(n_d+1), n_el);
for e = 1:n_el
    % Computation of element length
    Le = 0; % Element bar length
    for n = 1:n_d
        xi = x(Tnod(e,1), n);
        xj = x(Tnod(e,2), n);
        Le = Le + (xj - xi)^2;
    end
    Le = sqrt(Le);
    % Compute first part of force vector
    Fe1 = zeros(2*(n_d+1), 1);
    Fe1(2) = 1;
    Fe1(3) = Le/6;
    Fe1(5) = 1;
    Fe1(6) = -Le/6;
    % Compute second part of force vector
    Fe2 = zeros(2*(n_d+1), 1);
    Fe2(1) = 1;
    Fe2(4) = 1;
    
end

end