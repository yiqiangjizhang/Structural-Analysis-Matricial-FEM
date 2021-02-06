clc
% clear all
close all
% Finite Element Program for Elastostatic problems 
% --------------------------------------------
% ELASTODYNAMIC
% --------------------------------------------
format long;
%%% INPUT  %%% 
% Input data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_INPUT_DATA = 'BEAM3D' ;  % Name of the mesh file 
%------------------------------------------------------
load('valoresjuan.mat')
load('elastodynamic_data.mat')
neig = 25;
[MODES, FREQ] = UndampedFREQ(M,K,neig);
[d_vib_all t qi_0_matrix] = UndampedFreeVibration(DATA, DOFl, MODES, FREQ,d,K_ll, M_ll);
% [d_vib_all t qi_0_matrix] = DampedFreeVibration(DATA, DOFl, MODES, FREQ,d,K_ll, M_ll);
% GidPostProcessModes(COOR,CN,TypeElement,MODES,posgp,NameFileMesh,DATA,DOFl); 
GidPostProcessDynamic(COOR,CN,TypeElement,d_vib_all,NAME_INPUT_DATA,posgp,NameFileMesh,t);

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% 2D plot
figure(1);
hold on;
box on;
grid minor;
xlab = xlabel('Modes');
ylab = ylabel('Initial amplitude $q_0$');

bar(abs(qi_0_matrix))
