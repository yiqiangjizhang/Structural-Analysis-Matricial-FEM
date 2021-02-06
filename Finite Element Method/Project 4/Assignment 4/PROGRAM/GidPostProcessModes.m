function GidPostProcessModes(COOR,CN,TypeElement,MODES,posgp,NameFileMesh,DATA,DOFl); 
% Post-processing of results using GID  (vibration modes)
%dbstop('4')
if nargin==0
    load('tmp.mat')
end

% Name of the mesh file 
NameFile_msh = ['GIDPOST/','MODES','_',NameFileMesh(1:end-4),'.msh'] ; 
% Name of the results file 
NameFile_res= ['GIDPOST/','MODES','_',NameFileMesh(1:end-4),'.res'] ; 

% Writing mesh file
MaterialType = ones(size(CN,1),1) ; 
GidMesh2DFE(NameFile_msh,COOR,CN,'MODES',MaterialType,TypeElement);
% Writing results file
%nMODES =size   ; 
MODESplot = zeros(size(COOR,1)*size(COOR,2),size(MODES,2)) ; 
MODESplot(DOFl,:) = MODES ; 
GidResults2DFE_modes(NameFile_res,COOR,CN,TypeElement,MODESplot,posgp);

cddd = cd ; 
NAMEFILEOPEN =  [cddd,'/',NameFile_res] ; 
disp('open GID FILE:')
disp(NAMEFILEOPEN)