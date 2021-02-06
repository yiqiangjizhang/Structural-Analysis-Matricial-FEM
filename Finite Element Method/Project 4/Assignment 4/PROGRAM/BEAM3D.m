% Inputs example assigment 3

% --------------------------------------
% % 1. NAME OF THE MESH AND DATA FILES. COORDINATES, CONNECTIVITIES,  LISTS
% % OF NODES FOR IMPOSING BOUNDARY CONDITIONS
% %--------------------------------------------------------------------------
% NameFileMeshDATA = 'GEOMETRY_3D_2_div' ;   %  This is the name of GIDs project
% NameFileMeshDATA = 'GEOMETRY_3D_10_div' ;   %  This is the name of GIDs project
% NameFileMeshDATA = 'GEOMETRY_3D_15_div' ;   %  This is the name of GIDs project
NameFileMeshDATA = 'GEOMETRY_3D_20_div' ;   %  This is the name of GIDs project
% NameFileMeshDATA = 'MyFirstMesh3D' ;   %  This is the name of GIDs project
% wherein the mesh has been constructed. To generate the files needed by matlab,
% remember to export both the mesh and the conditions data. (Files >
% Export > Gid Mesh) and (Files > Export > Calculation File)
% ---------------------------------------------------------------------------

%-------------------------------------------------------------------------------------
% 2. Type of structural problem (plane stress ('pstress'), plane strain ('pstrain'), 3D)
% --------------------------------------------------------------
typePROBLEM ='3D' ;
% -----------------------------------------------------------------------------------


% -----------------------------------------------------------------------------------
% 3. Material data
% -----------------------------------------------------------------------------------
imat =1 ; % Index material
% Elasticity matrix
E = 70000  ; %  MPa, Young's modulus
nu = 0.3; % Poisson's coefficient
% Compliance matrix for an isotropic materials (with all entries, 3D)
% See slides, page 23.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = E/2/(1+nu) ;  % Shear modulus
celasINV3D = [1/E  -nu/E -nu/E  0 0 0
    -nu/E  1/E  -nu/E  0 0 0
    -nu/E  -nu/E  1/E  0 0 0
    0      0    0  1/G   0 0
    0      0      0  0 1/G 0
    0      0      0  0  0  1/G] ;
ElasticityMatrix = inv(celasINV3D) ;
PROPMAT(imat).ElasticityMatrix =  ElasticityMatrix  ; %
% imat = 2 .... Repeat the above sequence of operations for defining
% another material

% % -----------------------------------------------------------
% % 4. Dirichlet boundary conditions (prescribed displacements)
% % -----------------------------------------------------------
icond = 1; % Number of condition
DIRICHLET(icond).NUMBER_SURFACE = 1 ;   % Number of SURFACE on which DISPLACEMENT  is prescribed
DIRICHLET(icond).PRESCRIBED_DISP = {[0],[0],[0]} ;  % Constraints x,y and z directions. If empty, no constraints
 


% % -------------------------------------------------
% % 5. External forces  (NEUMANN CONDITIONS, POINT FORCES AND BODY FORCES)
% --------------------------------------------------------------------
%  5.1) NEUMANN COND. Loads per unit surface
% ------------------------------------------------------------------
icond= 1 ;
NEUMANN(icond).NUMBER_SURFACE = 2 ;  % Surface on which the load is applied
NEUMANN(icond).FORCE_PER_UNIT_SURFACE= [0,0,0] ; % Force per unit surface (units determined by
% the units of the  Young's Modulus, and the units of length employed in GID). In this case, 500 KN/m2
% = 0.5 MPa

% % -------------------------------------------
% % 5.2) POINT FORCES (FORCES APPLIED ON NODES)
% % --------------------------------------------
% No torque

% iforce  = 1; % Number of force
% POINT_FORCE(iforce).NODE = 1;
% POINT_FORCE(iforce).VALUE = [0,0,0];    % Young's Modulus Units*(Length units)^2. In this case, MN

% Torque 2 vectors

% iforce  = 1; % Number of force
% POINT_FORCE(iforce).NODE = 37;
% POINT_FORCE(iforce).VALUE = [0,-0.5,0];    % Young's Modulus Units*(Length units)^2. In this case, MN
% 
% iforce  = 2; % Number of force
% POINT_FORCE(iforce).NODE = 161;
% POINT_FORCE(iforce).VALUE = [0,0.5,0];    % Young's Modulus Units*(Length units)^2. In this case, MN

% Torque 4 vectors

iforce  = 1; % Number of force
POINT_FORCE(iforce).NODE = 37; % left
POINT_FORCE(iforce).VALUE = [0,-0.25,0];    % Young's Modulus Units*(Length units)^2. In this case, MN

iforce  = 2; % Number of force
POINT_FORCE(iforce).NODE = 161; % right
POINT_FORCE(iforce).VALUE = [0,0.25,0];    % Young's Modulus Units*(Length units)^2. In this case, MN

iforce  = 3; % Number of force
POINT_FORCE(iforce).NODE = 35; % top
POINT_FORCE(iforce).VALUE = [0,0,0.25];    % Young's Modulus Units*(Length units)^2. In this case, MN

iforce  = 4; % Number of force
POINT_FORCE(iforce).NODE = 163; % bottom
POINT_FORCE(iforce).VALUE = [0,0,-0.25];    % Young's Modulus Units*(Length units)^2. In this case, MN


% -------------------------
%---5.3)  Body forces
% ---------------------
fBODY = 0 ;  % Constant value per unit volum MN/m^3.


% 6. DENSITY 
dens0 = 2.7;   % kKg/m^3

%
DATA.PRINT_AVERAGE_STRESSES_ON_ELEMENTS = 0  ; % Print volumetric average of stresses at each element




% PROCESSING INPUT DATA

[COOR,CN,TypeElement,CONNECTb,TypeElementB,MaterialType,celasglo,DOFr,dR,...
    Tnod,CNb,fNOD,Fpnt,NameFileMesh,densglo,celasgloINV] = ...
    PreProcessInputData(NameFileMeshDATA,PROPMAT,DIRICHLET,NEUMANN,POINT_FORCE,...
    fBODY,dens0,typePROBLEM);



