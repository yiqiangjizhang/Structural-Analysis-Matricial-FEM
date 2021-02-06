% Inputs example assigment 2 
% ----------------------------
%--------------------------------------------------------------------------
% 1. NAME OF THE MESH AND DATA FILES. COORDINATES, CONNECTIVITIES,  LISTS
% OF NODES FOR IMPOSING BOUNDARY CONDITIONS
%--------------------------------------------------------------------------
NameFileMeshDATA = 'GEOMETRIA2D' ;   % For reading data from GID.
% -----------------------------------------------------------
% 2. Material data. 
% --------------------------------------------------------------
imat =1 ; % Index material
PROPMAT(imat).kappa =  10  ; %  Conductivity  of material "imat" (ISOTROPIC)

% -----------------------------------------------------------
% 3. Dirichlet boundary conditions (prescribed temperature)
% -----------------------------------------------------------
icond = 1; % Number of condition 
DIRICHLET(icond).NUMBER_LINE = 1 ;   % Number of line on which temperature  is prescribed
DIRICHLET(icond).PRESCRIBED_TEMPER = 0 ;  % (constant along the line)
icond = 2; % Number of condition 
DIRICHLET(icond).NUMBER_LINE = 2;   % Number of line on which temperature  is prescribed
DIRICHLET(icond).PRESCRIBED_TEMPER = 0 ;  % Prescribed temperature (constant along the line)
% -------------------------------------------------
% 4. Neumann Boundary conditions (prescribed flux)
% ------------------------------------------------
icond= 1 ;
NEUMANN(icond).NUMBER_LINE = 4 ;  % Line 
NEUMANN(icond).PRESCRIBED_qBAR= -20 ;  % CONSTANT Prescribed heat flux vector x   normal unit vector to the line  
% -------------------------------------------
% 4. Heat source (constant all over the body)
% --------------------------------------------
fSOURCE = 4 ; 


% END INPUTS 
% ----------------------------------------------------------------------------------------------







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % ---------------
% 1.  Finite element mesh:  COORDINATES AND CONNECTIVITIES for both the volume domain and the boundary domain
% OUTPUT: COOR,CN,TypeElement,CONNECTb,TypeElementB
NameFileMesh = [NameFileMeshDATA,'.msh']; % Name of the file containing the mesh information (Generated with GID)
[COOR,CN,TypeElement,CONNECTb,TypeElementB,MaterialType]=...
    ReadMeshFile(NameFileMesh)  ;
nnode = size(COOR,1) ;% Number of nodes 

% 2. MATERIAL PROPERTIES: output ConductMglo  
%-----------------------
ndim = size(COOR,2); % Number of spatial dimensions (ndim=2 for 2D problems)
nelem = size(CN,1) ; % Number of elements
ConductMglo = zeros(ndim,ndim,nelem) ; 
% Conductivity matrix (isotropic)
for imat = 1:length(PROPMAT)
    kappa = PROPMAT(imat).kappa ;
    ConductM = kappa*eye(ndim) ; % eye = IDENTITY MATRIx
    ELEMS = find(MaterialType == imat) ;
    for eLOC=1:length(ELEMS)
        e = ELEMS(eLOC) ;
        ConductMglo(:,:,e) = ConductM ;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Dirichlet (essential) boundary conditions, OUTPUT: dR and rnod
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of nodes at which temperature is prescribed
%  Specify the number of line(s) in which the temperature is imposed
rnod = cell(length(DIRICHLET),1)  ; dR =  cell(length(DIRICHLET),1) ; 
for  icond = 1:length(DIRICHLET)
    rnod{icond} =  ListOfNodesLINE(NameFileMesh,DIRICHLET(icond).NUMBER_LINE) ;
    dR{icond} = DIRICHLET(icond).PRESCRIBED_TEMPER*ones(size( rnod{icond} )) ; 
end
% Removed repeated condions 
% ---------------------------
rnod = cell2mat(rnod) ; 
dR = cell2mat(dR) ; 
[rnod, AAA] = unique(rnod) ;
dR = dR(AAA) ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Neumann (natural) boundary conditions : OUTPUT: qFLUXglo, CNb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CNb = cell(length(NEUMANN),1) ; % Boundary Connectivities 
qFLUXglo =cell(length(NEUMANN),1) ;  % Prescribed, nodal values 

for icond = 1:length(NEUMANN)
    NODESb = ListOfNodesLINE(NameFileMesh,NEUMANN(icond).NUMBER_LINE) ;
    CNb{icond} = ElemBnd(CONNECTb,NODESb) ; 
    qFLUXglo{icond} = NEUMANN(icond).PRESCRIBED_qBAR*ones(size(CNb{icond})) ;
end
 
CNb = cell2mat(CNb) ; 
qFLUXglo = cell2mat(qFLUXglo) ; 

%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Heat source
%%
 
% Global vector of heat sources (constant)
fNOD = fSOURCE*ones(nnode,1) ; 
