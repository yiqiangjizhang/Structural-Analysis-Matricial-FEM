function [qheatGLO, posgp]= HeatFlux(COOR,CN,TypeElement,ConductM,d) ; 

% Dimensions of the problem
nnode = size(COOR,1);  % Number of nodes
ndim = size(COOR,2);   % Spatial Dimension of the problem  (2 or 3)
nelem = size(CN,1);   % Number of elements 
nnodeE = size(CN,2) ; %Number of nodes per element 

% Determine Gauss weights, shape functions and derivatives  
TypeIntegrand = 'K'; 
[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ; 

ngaus = size(posgp,2) ; ; 
qheatGLO = zeros(ngaus*ndim,nelem); 

counter = [1,3,5,7];

for e = 1:nelem 
    % Element matrix
    NODOSe = CN(e,:);
    x = COOR(NODOSe,1);
    y = COOR(NODOSe,2);
    Xe =[x' ; y'];
    % Compute Qi matrix
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
        qheatGLO(counter(g):(g*2),e) = -1*ConductM(:,:,e)*Be*d(NODOSe);
    end
    
%     for a = 1:nnodeE
%         for b = 1:nnodeE
%             A = CN(e,a);
%             B = CN(e,b);
%             K(A,B) = K(A,B) + Ke(a,b);
%         end
%     end
end



end