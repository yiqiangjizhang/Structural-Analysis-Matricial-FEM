function [Ne, BeXi] = BilinearQuadrilateral4N(xi, eta);

% Shape functions and derivatives for 4-node bilinear quadrilateral element 

% Matrix of shape functions
Ne = 1/4 *[(1-xi)*(1-eta) (1+xi)*(1-eta) (1+xi)*(1+eta) (1-xi)*(1+eta)];
% Matrix of the gradient of shape functions 
BeXi = 1/4 *[-1*(1-eta) (1-eta) (1+eta) -1*(1+eta); ...
             -1*(1-xi) -1*(1+xi) (1+xi) (1-xi)];

end
