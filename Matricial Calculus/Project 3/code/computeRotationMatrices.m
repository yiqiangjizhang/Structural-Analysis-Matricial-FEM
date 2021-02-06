function R = computeRotationMatrices(n_d, n_el, Tnod, x)

R = zeros(2*(n_d+1), 2*(n_d+1), n_el);
for e = 1:n_el
    % Compute element bar length and rotation matrix
    Le = 0; % Element bar length
    Re = zeros(2*(n_d+1),2*(n_d+1)); % Rotation matrix
    for n = 1:n_d
        xi = x(Tnod(e,1), n);
        xj = x(Tnod(e,2), n);
        Le = Le + (xj - xi)^2;
        Re(1, n) = xj - xi;
        Re(2, n_d+1-n) = xj - xi;
        Re(4, n_d+1+n) = xj - xi;
        Re(5, 2*(n_d+1)-n) = xj - xi;
    end
    Le = sqrt(Le);
    Re(2,1) = -Re(2,1);
    Re(5,4) = -Re(4,5);
    Re(3,3) = Le;
    Re(6,6) = Le;    
    Re = Re / Le;
    R(:,:,e) = Re;
end


end