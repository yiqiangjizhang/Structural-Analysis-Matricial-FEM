clc;
clear all;
close all;
% load('DATA_fixed_end_2_div.mat');
% load('DATA_fixed_end_10_div.mat');
% load('DATA_fixed_end_15_div.mat');
load('DATA_fixed_end_20_div.mat');
% load('DATA_fixed_end.mat');

React_DOFr = React(DOFr);

% Reaction forces

React_x = 0;
React_y = 0;
React_z = 0;

React_x = sum(React_DOFr(1:(length(React_DOFr)/3)));
React_y = sum(React_DOFr((length(React_DOFr)/3+1):(length(React_DOFr)*2/3))); 
React_z = sum(React_DOFr((length(React_DOFr)*2/3+1):(length(React_DOFr))));    

% Torque

ndim = size(COOR,2);
center = [0 0.125 -0.125];

var = (DOFr(1)+2)/3;

COOR_DOFr = COOR(var:end,:);
React_DOFr = React(DOFr(1):end);
dist = zeros(length(COOR_DOFr),ndim);


for i=1:length(COOR_DOFr)
    dist(i,1) = COOR_DOFr(i,1)-center(1);
    dist(i,2) = COOR_DOFr(i,2)-center(2);
    dist(i,3) = COOR_DOFr(i,3)-center(3);
    
    R(i,1) = React_DOFr(i*ndim-2);
    R(i,2) = React_DOFr(i*ndim-1);
    R(i,3) = React_DOFr(i*ndim);
end

M_x = 0;
M_y = 0;
M_z = 0;

for i=1:length(COOR_DOFr)
    M(i,:) = cross(R(i,:),dist(i,:));
    x = M(i,1);
    y = M(i,2);
    z = M(i,3);
    
    M_x = M_x+x;
    M_y = M_y+y;
    M_z = M_z+z;
end

