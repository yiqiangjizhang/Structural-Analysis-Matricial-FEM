function [strainGLO stressGLO posgp  ]= StressStrains(COOR,CN,TypeElement,celasglo,...
    d,typePROBLEM,celasgloINV,DATA)
%%%% COmputation of strain and stresses   at each gauss point
%dbstop('4')
if nargin == 0
    load('tmp.mat')
end
nnode = size(COOR,1); ndim = size(COOR,2); nelem = size(CN,1); nnodeE = size(CN,2) ;
nstrain = size(celasglo,1) ;
TypeIntegrand = 'K';
[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ;
ngaus = length(weig) ;
if nstrain == 3
    nstrain=4 ;
end
switch typePROBLEM
    case 'pstrain'
        TP = 1;
    case 'pstress'
        TP = 2 ;
    case '3D'
        TP = 3 ;
end

stressGLO = zeros(ngaus*nstrain,nelem);
strainGLO = zeros(ngaus*nstrain,nelem);
stressGLO_elem = zeros(nstrain,nelem);
strainGLO_eleme = zeros(nstrain,nelem);
for e = 1:nelem
    % Elasticity matrix of element "e"
    celas = celasglo(:,:,e) ;
    celas3Dinv = celasgloINV(:,:,e) ;
    celas3D = inv(celas3Dinv) ;
    % Coordinates of the nodes of element "e"
    CNlocNOD = CN(e,:) ;
    Xe = COOR(CNlocNOD,:)' ;
    % Displacement at   nodes of element e
    CNloc = Nod2DOF(CNlocNOD,ndim) ;
    dE = d(CNloc) ;
    
    
    stressGID_elem = zeros(nstrain,1) ; 
    strainGID_elem = zeros(nstrain,1) ; 
    
    for  g = 1:ngaus
        % Matrix of derivatives for Gauss point "g"
        BeXi = dershapef(:,:,g) ;
        % Jacobian Matrix
        Je = Xe*BeXi' ;
        detJe = det(Je) ; 
        % Matrix of derivatives with respect to physical coordinates
        BeTILDE = inv(Je)'*BeXi ;
        % Matrix of symmetric gradient
        Be = QtransfB(BeTILDE,ndim) ;
        %
        strain = Be*dE;
        %  stress = celas*strain ;
        % Additional component
        if TP == 1
            strain3D = [strain(1) strain(2) 0 0 0 strain(3)]'; % Plane strain
            stress3D = celas3D*strain3D ;
            stressGID = stress3D([1 2 6 3]) ;  % For post-processing with GID
            strainGID = strain3D([1 2 6 3]) ;
        elseif TP == 2
            stress = celas*strain ;
            stress3D = [stress(1) stress(2) 0 0 0 stress(3)]'; % Plane strain
            strain3D = celas3Dinv*stress3D ;
            strainGID = strain3D([1 2 6 3]) ;
            stressGID = stress3D([1 2 6 3]) ; % For post-processing with GID
        elseif TP ==3
            stress = celas*strain ;
            stressGID = stress([1 2 3 6 4 5]) ; % For post-processing with GID
            strainGID = strain([1 2 3 6 4 5]) ; % For post-processing with GID
        end
        weight = detJe*weig(g); 
        stressGID_elem = stressGID_elem + stressGID/weight ; 
        strainGID_elem = strainGID_elem + strainGID/weight ; 
        
        indINI = (g-1)*nstrain+1 ;  indFIN = nstrain*g;
        stressGLO(indINI:indFIN,e) =  stressGID ;
        strainGLO(indINI:indFIN,e) =  strainGID ;
       
    end
         stressGLO_elem(:,e) =  stressGID_elem ;
        strainGLO_elem(:,e) =  strainGID_elem ;
end
DATA = DefaultField(DATA,'PRINT_AVERAGE_STRESSES_ON_ELEMENTS',0) ; 
if DATA.PRINT_AVERAGE_STRESSES_ON_ELEMENTS == 1
    strainGLO = strainGLO_elem ; 
    stressGLO = stressGLO_elem ; 
end