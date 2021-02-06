function [x] = computeNodalCoordinates(nel_part_k, nnod, L1, L2)

% Nodal Coordinates (x,y) considering 2D problem
x = zeros(nnod, 2);

% First Domain coordinates
for n = 1:nel_part_k+1
    x(n) = (n-1)*L1/nel_part_k;
end

% Second Domain Coordinates
for n = 2:nel_part_k+1
    x(n+nel_part_k) = (n-1)*L2/nel_part_k + L1;
end

end