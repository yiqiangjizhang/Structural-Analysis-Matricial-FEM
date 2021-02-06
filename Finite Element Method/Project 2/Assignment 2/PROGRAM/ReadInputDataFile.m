function [COOR,CN,TypeElement,TypeElementB, ConductMglo,  rnod,dR,...  
    qFLUXglo,CNb,fNOD,NameFileMesh]  = ReadInputDataFile(NAME_INPUT_DATA) ; 


% OUTPUTS 
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
 disp('Reading input data...')

eval(NAME_INPUT_DATA) ; 