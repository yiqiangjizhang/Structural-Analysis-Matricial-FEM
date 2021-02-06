function DRM = computeDRM(Le)

DRM = zeros(4,6);
% Row 1
DRM(1,2) = 2;
DRM(1,3) = Le;
DRM(1,5) = -2;
DRM(1,6) = Le;
% Row 2
DRM(2,2) = -3*Le;
DRM(2,3) = -2*Le^2;
DRM(2,5) = 3*Le;
DRM(2,6) = -Le^2;
% Row 3
DRM(3,3) = Le^3;
% Row 4
DRM(4,2) = Le^3;

DRM = DRM / Le^3;


end