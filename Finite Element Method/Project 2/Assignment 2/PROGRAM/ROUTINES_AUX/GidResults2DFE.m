function GidResults2DFE(NameFile,COOR,CONNECT,TypeElement,d,qheatGLO,NAME_INPUT_DATA,posgp)
% INPUT DATA
%dbstop('6')
if nargin == 0
    load('tmp1.mat')
end
%%%%
elem_type = TypeElement;
NNode= size(CONNECT,2) ;;
ndime = size(COOR,2) ;
nnod = size(COOR,1) ;
npe =  size(CONNECT,2) ;
nElem = size(CONNECT,1) ;
if isempty(posgp)
    npg = 4 ;
else
    npg = size(posgp,2);
end
fid_res = fopen(NameFile,'wt');
fprintf(fid_res,'GiD Post Results File 1.0 \n');

%% Definici�n de punto de Gauss
%Se almacena los puntos de gauss, para no hacerlo en todos los pasos que se plotea los resultados
%(solo es necesario definirlo una vez).

% %%Punto de Gauss �nico para valor medio de los puntos de gauss
% fprintf(fid_res,['GaussPoints "GPset" Elemtype ',elem_type,'   \n']);
% fprintf(fid_res,'Number of Gauss Points: 1   \n');
% fprintf(fid_res,'Nodes not included  \n');
% fprintf(fid_res,'Natural Coordinates: Internal  \n');
% fprintf(fid_res,'End GaussPoints  \n');
xg =posgp ; 

%Punto de Gauss de los elementos usados (este deber�a ser un loop en todos los Sets)
fprintf(fid_res,['GaussPoints "GPset" Elemtype ',elem_type,'\n']);
fprintf(fid_res,['Number of Gauss Points: ',num2str(npg),'\n']);
fprintf(fid_res,'Nodes not included\n');
%Se utiliza Given en lugar de Internal porque es m�s general para distintos puntos de gauss que se
%defina, aunque igualmente la cantidad de puntos tiene que ser compatible con lo que permite el GiD
%para cada elemento y el sistema de coordenadas usada en el mismo.
%fprintf(fid_res,'Natural Coordinates: Given\n');
%fprintf(fid_res,'%f %f\n',xg');
fprintf(fid_res,'Natural Coordinates: Internal\n');
fprintf(fid_res,'End GaussPoints\n');

stepsSH  =1; % Linear analysis, just one step
 TIMEVECTOR = 1; 
for istepLOC = 1:length(stepsSH)
    
    istep = stepsSH(istepLOC) ;
    disp(['istep=',num2str(istep)])
    
    var =  d';
    % %**************************************************
    % Nodal temperatures
    %**************************************************
    time_step = TIMEVECTOR(istep) ;
    fprintf(fid_res, ['Result "Temperature"  "Load Analysis" '  num2str(time_step) ' Scalar OnNodes  \n' ],[]);

    fprintf(fid_res,'Values\n');
    fORMAT = ['%d',repmat(' %f',1,1),'\n'];
    fprintf(fid_res,fORMAT,[1:nnod;var]);
    fprintf(fid_res,'End Values\n');
    
    %%% Heat flux ........................
    % ...................................
    if any(qheatGLO)
    LABEL_LOC = ['Heat flux (W/m)'];
    nomComponente = '"qx" "qy"';
    fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Vector OnGaussPoints "GPset"\n']);
    fprintf(fid_res,'ComponentNames %s\n',nomComponente);
    
    %   fprintf(fid_res,'Result "Stresses"  "Load Analysis" %d %s OnGaussPoints "GPset"\n',i,tipoDatAlmac);
    % fprintf(fid_res,'ComponentNames %s\n',nomComponente);
    var = qheatGLO ; 
     fprintf(fid_res,'Values\n');
        format = ['%d',repmat([repmat(' %f',1,ndime),'\n'],1,npg)];
    fprintf(fid_res,format,[1:nElem;var]);
        fprintf(fid_res,'End Values\n');
    end
%     
%     %%%%
%     % PRINT EFFECTIVE STRESSES
%     stress = stressST(:,istep)  ;
%     nstrain = 4 ;
%     ngaus = length(stress)/nstrain ;
%     stressM  =reshape(stress',nstrain,ngaus) ;
%     stressM = stressM' ;
%     trSTR = (stressM(:,1)+stressM(:,2)+stressM(:,4));
%     strVOL = trSTR/3 ; 
%     trSTR = [trSTR trSTR zeros(size(trSTR))  trSTR];
%     stressMdev =  stressM - 1/3*trSTR ; 
%     normSTR =  stressMdev(:,1).^2 + stressMdev(:,2).^2 + 2* stressMdev(:,3).^2 + stressMdev(:,4).^2 ;
%     var = sqrt(3/2)*sqrt(normSTR);
%     var = reshape(var',npg,nElem);
%     
%     LABEL_LOC = ['Effective stress'];
%     fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Scalar OnGaussPoints "GPset"\n'],[]);
%     fprintf(fid_res,'Values\n');
%     format = ['%d',repmat(' %f\n',1,npg)];
%     %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
%     %justamente la deformaci�n pl�stica equivalente.
%     
% 
%     fprintf(fid_res,format,[1:nElem;var]);
%     fprintf(fid_res,'End Values\n'); ;
    
%     %%% Mean stress 
%      var = reshape(strVOL',npg,nElem);
%      LABEL_LOC = ['Mean stress'];
%     fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Scalar OnGaussPoints "GPset"\n'],[]);
%     fprintf(fid_res,'Values\n');
%     format = ['%d',repmat(' %f\n',1,npg)];
%     %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
%     %justamente la deformaci�n pl�stica equivalente.
%     
%     fprintf(fid_res,format,[1:nElem;var]);
%     fprintf(fid_res,'End Values\n'); ;
%     
%     %
%     
%     PRINT_STRESSES = 1;
    
%     if PRINT_STRESSES == 1
%         
%         %     %%% Axial stresses at each bar
%         %     if  size(stressST,1) ~= length(Area)
%         %         elemshow = 2:2:size(stressST,1)  ;
%         %     else
%         %         elemshow = 1:length(Area) ;
%         %     end
%         var = stressST(:,istep)  ;
%         nstrain = 4 ;
%         ngaus = length(var)/nstrain ;
%         var  =reshape(var', nstrain*npg,nElem) ;
%         % Permutation of columns  (4th column --> stress xy)
%         var = var' ;
%         varNEW = var ;
%         compXY_old = 3:nstrain:nstrain*npg ;
%         compXY_new= 4:nstrain:nstrain*npg ;
%         
%         varNEW(:,compXY_new) = var(:,compXY_old) ;
%         varNEW(:,compXY_old) = var(:,compXY_new) ;
%         var = varNEW ;
%         
%         
%         %
%         LABEL_LOC = ['Stresses'];
%         tipoDatAlmac = 'PlainDeformationMatrix' ;
%         nomComponente = '"Stress XX" "Stress YY" "Stress ZZ" "Stress XY"';
%         fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Vector OnGaussPoints "GPset"\n'],[],tipoDatAlmac);
%         fprintf(fid_res,'ComponentNames %s\n',nomComponente);
%         
%         %   fprintf(fid_res,'Result "Stresses"  "Load Analysis" %d %s OnGaussPoints "GPset"\n',i,tipoDatAlmac);
%         % fprintf(fid_res,'ComponentNames %s\n',nomComponente);
%         
%         fprintf(fid_res,'Values\n');
%         format = ['%d',repmat([repmat(' %f',1,nstrain),'\n'],1,npg)];
%         
%         %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
%         %justamente la deformaci�n pl�stica equivalente.
%         fprintf(fid_res,format,[1:nElem;var']);
%         fprintf(fid_res,'End Values\n');
%         
%         %         format = ['%d',repmat([repmat(' %f',1,ntens),'\n'],1,npg)];
%         % fprintf(fid_res,format,[1:nElem;stress]);
%         % fprintf(fid_res,'End Values\n');
%         %
%         
%         
%         %%% Internal plastica variable
%         if  ~isempty(alpha_snapshots_loc)
%             %  var =alpha_snapshots_loc(:,istep) ;
%             var = alpha_snapshots_loc(:,istep) ;
%             var = reshape(var,npg,nElem) ;
%             %
%             LABEL_LOC = ['Internal p. var'];
%             fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Scalar OnGaussPoints "GPset"\n'],[]);
%             fprintf(fid_res,'Values\n');
%             format = ['%d',repmat(' %f\n',1,npg)];
%             %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
%             %justamente la deformaci�n pl�stica equivalente.
%             fprintf(fid_res,format,[1:nElem;var]);
%             fprintf(fid_res,'End Values\n'); ;
%             
%             %             if  istep ==1
%             %                 var = zeros(size(alpha_snapshots_loc(:,istep))) ;
%             %             else
%             %
%             %                 var = ones(size(alpha_snapshots_loc(:,istep))) ;
%             %                 indvar =   find(dalpha_snapshots_loc(:,istep-1)==0);
%             %                 var(indvar) = 0;
%             %             end
%             %
%             %             LABEL_LOC = ['Plastic yielding'];
%             %             fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Scalar OnGaussPoints "GPset"\n'],[]);
%             %             fprintf(fid_res,'Values\n');
%             %         %    format = ['%d',repmat(' %f\n',1,npg)];
%             %                format = ['%d',repmat(' %f\n',1,npg)];
%             %             %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
%             %             %justamente la deformaci�n pl�stica equivalente.
%             %             fprintf(fid_res,format,[1:nElem;var']);
%             %             fprintf(fid_res,'End Values\n');
%             
%             
%         end
%         
        
        
        %
        %     LABEL_LOC = ['Axial stress'];
        %     fprintf(fid_res,['Result  "',LABEL_LOC,'" "Load Analysis" ' num2str(time_step) ' Scalar OnGaussPoints "GPset"\n'],[]);
        %     fprintf(fid_res,'Values\n');
        %     format = ['%d',repmat(' %f\n',1,npg)];
        %     %Se est� sacando el �ltimo valor del vector de variable de hist�rica de cada punto de gauss, que es
        %     %justamente la deformaci�n pl�stica equivalente.
        %     fprintf(fid_res,format,[1:nElem;var']);
        %     fprintf(fid_res,'End Values\n');
%         
%     end
    
end



fclose(fid_res);
