function Me = ComputeMeMatrix(dens,weig,shapef,dershapef,Xe) ;
ndim = size(Xe,1) ; 
ngaus = length(weig) ; 
nnodeE = size(Xe,2)  ;  

Me = zeros(nnodeE*ndim,nnodeE*ndim) ;

for  g = 1:ngaus
    % Matrix of shape functions at point "g"
    NeSCL = shapef(g,:);
    % Matrix of shape functions at point "g" (for vector-valued fields)
    Ne = StransfN(NeSCL,ndim);
    % Matrix of derivatives for Gauss point "g"
    BeXi = dershapef(:,:,g) ; 
    % Jacobian Matrix 
    Je = Xe*BeXi' ; 
    % Jacobian 
    detJe = det(Je) ; 
    Me = Me + weig(g)*detJe*(Ne'*dens*Ne) ; 
end

end