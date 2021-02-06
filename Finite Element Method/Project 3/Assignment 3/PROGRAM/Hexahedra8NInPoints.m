function [weig,posgp,shapef,dershapef] = Hexahedra8NInPoints

% This function returns, for each 2-node 1D linear element,
% and using a 1 points Gauss rule (ngaus=1): , if TypeIntegrand = K
% and ngaus=2, if TypeIntegrand = RHS:
%
% weig = Vector of Gauss weights (1xngaus) (1x4)
% posgp: Position of Gauss points  (ndim x ngaus) (2x4))
% shapef: Array of shape functions (ngaus x nnodeE) (4x4)
% dershape: Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus) (2x4x4)

% Eight integration points
    weig  = [1 1 1 1 1 1 1 1] ;
    posgp = 1/sqrt(3)*[-1 1 1 -1 -1 1 1 -1; ... % x
                       -1 -1 1 1 -1 -1 1 1; ... % y
                       -1 -1 -1 -1 1 1 1 1];    % z


ndim = 3; nnodeE = 8 ;
ngaus = length(weig) ;
shapef = zeros(ngaus,nnodeE) ;
dershapef = zeros(ndim,nnodeE,ngaus) ;
for g=1:length(weig);
    xi = posgp(1,g) ;
    eta = posgp(2,g);
    zeta = posgp(3,g);
    [Ne, BeXi] = TrilinearHexahedral8N(xi, eta, zeta);
    shapef(g,:) = Ne ;
    dershapef(:,:,g) = BeXi ;
end


 
end