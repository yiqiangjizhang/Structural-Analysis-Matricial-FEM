function [d,qheatGLO,posgp] = SolveHeatFE(COOR,CN,TypeElement,TypeElementB, ConductMglo,  rnod,dR,...  
    qFLUXglo,CNb,fNOD)  ; 

%%% This function returns the (nnode x 1) vector of nodal temperatures (d),
%%% as well as the vector formed by the heat flux vector at all gauss
%%% points  (qheatGLO). The inputs are: 
% --------------
% 1. Finite element mesh 
% -------------------
% COOR: Coordinate matrix (nnode x ndim)
% CN: Connectivity matrix (nelem x nnodeE)
% TypeElement: Type of finite element (quadrilateral,...)
% TypeElementB: Type of boundary finite element (linear...)
% -----------
% 2. Material
% -----------
%  ConductMglo (ndim x ndim x nelem)  % Array of conductivity matrices
% -------------------------
% 3. Dirichlet (Essential) Boundary Condition s
% --------------------------------------------
%  rnod --> Set of nodes with prescribed temperatures 
%  dR   --> Vector of prescribed temperatures  (size(rnod) = size(dR))
% ---------------------------------------
% 4. Neumann (natural) Boundary Conditions
% -------------------------------------------
%  CNb: Connectivity matrix for the boundary elements of the Neumann
%  Boundary
%  qFLUXglo: Vector containing the prescribed flux at all nodes  (nnode x
% --------------------------------
% 5. Heat source
% ---------------
%  fNOD: Vector containing the nodal values of the heat source function (nnode x1 )
% ----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A) Assembly of global conductance matrix 
% ------------------------------
disp('Computing conductance matrix K ...')
K = ComputeK(COOR,CN,TypeElement, ConductMglo) ; 

% B) Assembly of global flux vector (source contribution)
% ------------------------------
disp('Computing  global flux vector (source contribution) Fs...')
Fs = ComputeFs(COOR,CN,TypeElement, fNOD) ; 

% C) Assembly of global flux vector (boundary contribution)
% ------------------------------
disp('Computing  global flux vector (boundary contribution) Fbnd...')
Fbnd = ComputeFbnd(COOR,CNb,TypeElementB, qFLUXglo) ; 

% D) Solving for the vector of unknown temperatures 
disp('Solving...')
[d qheatGLO posgp] = SolveHE(K,Fs,Fbnd,dR,rnod,COOR,CN,TypeElement,ConductMglo) ; 

