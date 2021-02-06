clc
clear all
% "Template" Finite Element Program for Heat Conduction Problems
% ECA.
% Technical University of Catalonia
% JoaquIn A. Hdez, October 8-th, 2015
% ---------------------------------------------------
if exist('ElemBnd')==0
    addpath('ROUTINES_AUX') ;
end 
%%% INPUT  %%% 
% Input data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_INPUT_DATA = 'DATA_ASSIGNMENT2' ;
%------------------------------------------------------

% PREPROCESS  
[COOR,CN,TypeElement,TypeElementB, ConductMglo,  rnod,dR,...  
    qFLUXglo,CNb,fNOD,NameFileMesh] = ReadInputDataFile(NAME_INPUT_DATA)  ; 

% SOLVER 
% --------------------------------------------
[d,qheatGLO,posgp] = SolveHeatFE(COOR,CN,TypeElement,TypeElementB, ConductMglo,  rnod,dR,...  
    qFLUXglo,CNb,fNOD)  ; 

% POSTPROCESS
% --------------------------------------------
disp('POSTPROCESS....')
GidPostProcess(COOR,CN,TypeElement,d,qheatGLO,NAME_INPUT_DATA,posgp,NameFileMesh);