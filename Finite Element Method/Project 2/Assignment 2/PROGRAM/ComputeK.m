function K = ComputeK(COOR,CN,TypeElement, ConductM) ;
%%%%
% This subroutine   returns the global conductance matrix K (nnode x nnode)
% Inputs
% --------------
% 1. Finite element mesh
% -------------------
% COOR: Coordinate matrix (nnode x ndim) (4x2)
% CN: Connectivity matrix (nelem x nnodeE) (nelemx4)
% TypeElement: Type of finite element (quadrilateral,...)
% -----------
% 2. Material
% -----------
%  ConductMglo (ndim x ndim x nelem) (2x2xnelem) % Array of conductivity matrices
%%%%
 if nargin == 0
     load('tmp1.mat')
 end
 
 
 
 
%% COMPLETE THE CODE ....
%warning('You must program the assembly of the conductance matrix K !!')


% Dimensions of the problem
nnode = size(COOR,1);  % Number of nodes
ndim = size(COOR,2);   % Spatial Dimension of the problem  (2 or 3)
nelem = size(CN,1);   % Number of elements 
nnodeE = size(CN,2) ; %Number of nodes per element 

% Determine Gauss weights, shape functions and derivatives  
TypeIntegrand = 'K'; 
[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ; 

% Assembly of matrix K
% ----------------
K = sparse(nnode,nnode) ;

for e = 1:nelem 
    % Element matrix
    NODOSe = CN(e,:);
    x = COOR(NODOSe,1);
    y = COOR(NODOSe,2);
    Xe =[x' ; y'];
    % Compute Ke matrix
    Ke = ComputeKeMatrix(ConductM(:,:,e),weig,dershapef,Xe);
    % Assembly
    for a = 1:nnodeE
        for b = 1:nnodeE
            A = CN(e,a);
            B = CN(e,b);
            K(A,B) = K(A,B) + Ke(a,b);
        end
    end


end

end

