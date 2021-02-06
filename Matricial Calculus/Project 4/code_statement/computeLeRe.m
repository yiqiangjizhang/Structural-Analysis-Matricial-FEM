function [Le, Re] = computeLeRe(n_d, n_i, e, x, Tnod)

Le = 0;
Re = zeros(2*n_i, 2*n_i);
for i = 1:n_d
    xi = x(Tnod(e,1), i);
    xj = x(Tnod(e,2), i);
    Le = Le + (xj-xi)^2;
    Re(1,i) = xj-xi;
    Re(2,n_i-i) = xj-xi;
end
Le = sqrt(Le);
Re(1,2) = -Re(1,2);
Re(n_i,n_i) = Le;
Re(n_i+1:end,n_i+1:end) = Re(1:n_i,1:n_i);
Re = Re / Le;

end

