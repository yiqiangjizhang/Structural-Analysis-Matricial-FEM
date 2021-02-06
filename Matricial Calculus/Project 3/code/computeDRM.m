function DRM = computeDRM(n_ne, n_i, Le)
%--------------------------------------------------------------------------
% Inputs:
%   - n_ne          Number of nodes for each element
%   - n_i           Number of DOFs for each node
%   - Le            Element's length
%--------------------------------------------------------------------------
% It must provide as output:
%   - DRM           Deflection-Rotation matrix
%--------------------------------------------------------------------------

DRM = zeros(n_ne*n_i, n_ne*n_i);
% Row 1
DRM(1,1) = 2;
DRM(1,2) = Le;
DRM(1,3) = -2;
DRM(1,4) = Le;
% Row 2
DRM(2,1) = -3*Le;
DRM(2,2) = -2*Le^2;
DRM(2,3) = 3*Le;
DRM(2,4) = -Le^2;
% Row 3
DRM(3,2) = Le^3;
% Row 4
DRM(4,1) = Le^3;

end