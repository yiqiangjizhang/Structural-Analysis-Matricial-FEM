function [qheatGLO] = ComputeHeatFluxMatrix(ConductM,weig,dershapef,Xe,e,d)

ndim = size(Xe,1) ; 
ngaus = length(weig) ; 
nnodeE = size(Xe,2)  ; 

counter = [1,3,5,7];

for  g = 1:ngaus
    % Matrix of derivatives for Gauss point "g"
    BeXi = dershapef(:,:,g) ; 
    % Jacobian Matrix 
    Je = Xe*BeXi' ; 
    % JAcobian 
    detJe = det(Je) ; 
    % Matrix of derivatives with respect to physical coordinates 
    Be = inv(Je)'*BeXi ;
    % Heat matrix
    qheatGLO(counter(g),e) = ConductM(:,:,e)*Be*d(g+4*(e-1))
    qheatGLO(g*2,e) = ConductM(:,:,e)*Be*d(g+4*(e-1))
    
end






end