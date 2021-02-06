function GidResults2DFE_modes(NameFile,COOR,CONNECT,TypeElement,MODES,posgp)
% INPUT DATA
%dbstop('4')
if nargin == 0
    load('tmp1.mat')
end
%%%%%%
elem_type = TypeElement;
NNode= size(CONNECT,2) ;;
ndime = size(COOR,2) ;
nnod = size(COOR,1) ;
npe =  size(CONNECT,2) ;
nElem = size(CONNECT,1) ;
npg = size(posgp,2);
fid_res = fopen(NameFile,'wt');
fprintf(fid_res,'GiD Post Results File 1.0 \n');
xg =posgp ;
fprintf(fid_res,['GaussPoints "GPset" Elemtype ',elem_type,'\n']);
fprintf(fid_res,['Number of Gauss Points: ',num2str(npg),'\n']);
fprintf(fid_res,'Nodes not included\n');
fprintf(fid_res,'Natural Coordinates: Internal\n');
fprintf(fid_res,'End GaussPoints\n');
if ndime == 2
    nstrain =4 ;
else
    nstrain =6 ;
end
stepsSH  =1; % Linear analysis, just one step
TIMEVECTOR = 1;
istep = 1;
disp(['istep=',num2str(istep)])
% %**************************************************
% Natural modes
%**************************************************
for imode = 1:size(MODES,2)
    d = MODES(:,imode) ; 
    var = reshape(d,ndime,nnod) ;
    time_step = TIMEVECTOR(istep) ;
    fprintf(fid_res, ['Result "Mode ',num2str(imode),'"  "Load Analysis" '  num2str(time_step) ' Vector OnNodes  \n' ],[]);
    if ndime==2
        fprintf(fid_res,'ComponentNames "X-DISPL" "Y-DISPL"\n');
    elseif ndime==3
        fprintf(fid_res,'ComponentNames "X-DISPL" "Y-DISPL" "Z-DISPL"\n');
    end
    fprintf(fid_res,'Values\n');
    fORMAT = ['%d',repmat(' %f',1,ndime),'\n'];
    fprintf(fid_res,fORMAT,[1:nnod;var]);
    fprintf(fid_res,'End Values\n');
   
    
    
end


fclose(fid_res);