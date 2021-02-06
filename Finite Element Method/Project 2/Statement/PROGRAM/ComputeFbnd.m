function Fbnd = ComputeFbnd(COOR,CNb,TypeElementB, qFLUXglo) ; 
% This subroutine   returns the  boundary   contribution (Fs)    to the
% global flux vector. Inputs
% --------------
% 1. Finite element mesh 
% -------------------
% COOR: Coordinate matrix (nnode x ndim)
% CNb: Connectivity matrix of the boundary elements  (nelemB x nnodeEb)
% TypeElementB: Type of boundary element (linear,...)
% -----------
% 2. Vector containing the nodal values of the prescribed flux at   each
% boundary element 
% -----------
%  qFLUXglo (nnode x 1)  %  
%%%%
if nargin ==0
load('tmp2.mat')
end


% Dimensions of the problem 
nnode = size(COOR,1);  nelemB = size(CNb,1); nnodeEb = size(CNb,2) ;     

% Shape function routines (for calculating shape functions and derivatives)
TypeIntegrand = 'RHS'; % Right-hand side vector
[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElementB,nnodeEb,TypeIntegrand) ; 

% Assembly of vector Fbnd
% ----------------
Fbnd = zeros(nnode,1) ; 
for e = 1:nelemB   
    % Nodes of element "e"
    %dbstop('34')
    CNloc = CNb(e,:) ; 
    % Prescribed flux function evaluated at the nodes of element "e"
    qFLUXe = qFLUXglo(e,:)' ;  qFLUXe = qFLUXe(:) ; 
    % Coordinates of the nodes of element "e"
    Xe = COOR(CNloc,:)' ;
    % Computation of elemental sourve flux vector   
    %dbstop('40')
    FbndE = ComputeFbndVector(qFLUXe,weig,shapef,dershapef,Xe) ; 
    for a=1:nnodeEb 
            A = CNb(e,a) ;        
            Fbnd(A) = Fbnd(A) + FbndE(a) ; 
    end
end
    
    

