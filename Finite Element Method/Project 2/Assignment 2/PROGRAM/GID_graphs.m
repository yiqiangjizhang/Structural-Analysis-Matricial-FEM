
% Clear Command Window, clear workspace variables and close any MATLAB windows

clc;
clear all;
close all;

% Plot gratitaional equipotential energy
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% 2D plot
figure(1);
hold on;
box on;
grid minor;
tit = title('\textbf{Distribution of temperature along the top edge}');
xlab = xlabel('X variation $[\mathrm{m}]$');
ylab = ylabel('Temperature $[^\circ \mathrm{C}]$');

data_1_nodes = [0 0 ; 2 -1.57832];


data_5_nodes = [0 0 ; 0.40000001 -0.94037402 ; 0.80000001 -1.143142 ; ...
                1.2 -1.1820821 ; 1.6 -1.128162 ; 2 -1.087373];

data_10_nodes = [0 0 ; 0.2 -0.63817 ; 0.40000001 -0.89582098 ; ...
                 0.60000002 -1.054783 ; 0.80000001 -1.138821 ; ...
                 1 -1.174486 ; 1.2 -1.176289 ; 1.4 -1.156532 ; ...
                 1.6 -1.1268049 ; 1.8 -1.099843 ; 2 -1.088568];

data_30_nodes = [0 0 ; 0.0666667 -0.30405399 ;
                0.133333 -0.478358 ;
                0.2 -0.61679202 ;
                0.26666701 -0.72726101 ;
                0.33333299 -0.81813699 ;
                0.40000001 -0.89347798 ;
                0.466667 -0.95616502 ;
                0.533333 -1.008217 ;
                0.60000002 -1.051168 ;
                0.66666698 -1.086221 ;
                0.73333299 -1.114354 ;
                0.80000001 -1.1363879 ;
                0.86666697 -1.1530271 ;
                0.93333298 -1.164889 ;
                1 -1.172526 ;
                1.0666699 -1.176441 ;
                1.13333 -1.177103 ;
                1.2 -1.174951 ;
                1.26667 -1.1704119 ;
                1.33333 -1.163902 ;
                1.4 -1.155839 ;
                1.46667 -1.146649 ;
                1.53333 -1.136776 ;
                1.6 -1.126685 ;
                1.66667 -1.1168669 ;
                1.73333 -1.107833 ;
                1.8 -1.100096 ;
                1.86667 -1.094141 ;
                1.9333301 -1.090377 ;
                2 -1.0890861 ];
            
            
plot(data_1_nodes(:,1),data_1_nodes(:,2), ...
     data_5_nodes(:,1),data_5_nodes(:,2), ...
     data_10_nodes(:,1),data_10_nodes(:,2), ...
     data_30_nodes(:,1),data_30_nodes(:,2));
 
leg = legend('1 element','5x5 elements','10x10 elements','30x30 elements','Location','northeast');

tit.FontSize = 16;
xlab.FontSize = 16;
ylab.FontSize = 16;
leg.FontSize = 12;
