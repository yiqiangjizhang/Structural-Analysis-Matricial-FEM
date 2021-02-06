function Fs = ComputeFs(COOR,CN,TypeElement, fNOD) ; 
% This subroutine   returns the  heat source contribution (Fs)    to the
% global flux vector. Inputs
% --------------
% 1. Finite element mesh 
% -------------------
% COOR: Coordinate matrix (nnode x ndim)
% CN: Connectivity matrix (nelem x nnodeE)
% TypeElement: Type of finite element (quadrilateral,...)
% -----------
% 2. Vector containing the values of the heat source function at the nodes
% of the mesh
% -----------
%  fNOD (nnode x 1)  %  
%%%%
 
% Dimensions of the problem 
nnode = size(COOR,1); 
ndim = size(COOR,2); 
nelem = size(CN,1); 
nnodeE = size(CN,2);     

% Shape function routines (for calculating shape functions and derivatives)
TypeIntegrand = 'K'; 
[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ; 
  
% Assembly of vector Fs
% ----------------
Fs = zeros(nnode,1) ;  
for e = 1:nelem
    % Element matrix
    CNloc = CN(e,:);
    % Source function evaluated at the nodes of element "e"
    fe = fNOD(CNloc);
    % Coordinates of the nodes of element "e"
    x = COOR(CNloc,1);
    y = COOR(CNloc,2);
    Xe =[x' ; y'];
    % Computation of elemental source fluc vector
    Fse = ComputeFseVector(fe,weig,shapef,dershapef,Xe)

    for a=1:nnodeE
            A = CN(e,a) ;        
            Fs(A) = Fs(A) + Fse(a) ; 
    end
end



end
