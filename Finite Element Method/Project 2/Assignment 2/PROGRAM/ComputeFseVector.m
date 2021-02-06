function Fse = ComputeFseVector(fe,weig,shapef,dershapef,Xe) ; 
% Given 
% fe: Nodal values of the source function (nnodeE x1)
% weig :   Vector of Gauss weights (1xngaus)
% shapef:   Array with the   shape functions at each Gauss point (ngaus x nnodeE )
% dershapef:   Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus)
% Xe: Global coordinates of the nodes of the element,  
% 
% this function returns the element source flux vector  Fse

ndim = size(Xe,1) ; ngaus = length(weig) ; nnodeE = size(Xe,2)  ; 
Fse = zeros(nnodeE,1) ; 

for  g = 1:ngaus
    % Matrix of derivatives for Gauss point "g"
    BeXi = dershapef(:,:,g) ; 
    % Matrix of shape functions at point "g"
    Ne = shapef(g,:) ; 
    % Jacobian Matrix 
    Je = Xe*BeXi' ; 
    % JAcobian 
    detJe = det(Je) ;    
    %
    Fse = Fse + weig(g)*detJe*(Ne'*Ne)*fe ; 
end