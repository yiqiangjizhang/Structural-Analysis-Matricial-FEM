function Ke = ComputeKeMatrix(ConductM,weig,dershapef,Xe) ;
% Given 
% ConductM: Conductivity Matrix
% weig :   Vector of Gauss weights (1xngaus)
% dershapef:   Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus)
% Xe: Global coordinates of the nodes of the element,  
% this function returns the element conductance matrix Ke

ndim = size(Xe,1) ; ngaus = length(weig) ; nnodeE = size(Xe,2)  ; 
Ke = zeros(nnodeE,nnodeE) ; 

for  g = 1:ngaus
    % Matrix of derivatives for Gauss point "g"
    BeXi = dershapef(:,:,g) ; 
    % Jacobian Matrix 
    Je = Xe*BeXi' ; 
    % JAcobian 
    detJe = det(Je) ; 
    % Matrix of derivatives with respect to physical coordinates 
    Be = inv(Je)'*BeXi ; 
    %
    Ke = Ke + weig(g)*detJe*(Be'*ConductM*Be) ; 
end