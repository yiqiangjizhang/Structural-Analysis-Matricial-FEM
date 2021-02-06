function plotBarStress3D(x,Tnod,u,sig,scale)
% PLOTBARSTRESS3D function. 
% Inputs:                                           Type [Dimensions]
% - x      Nodal coordinates matrix (in m)          matrix [ n    , nd   ]
% - Tnod   Nodal connectivities matrix              matrix [ nel  , nnod ]
% - u      Array with global displacements (in m)   array  [ ndof ]
% - sig    Array with stress for each bar (in Pa)   array  [ nel  ]
% - scale  Scale factor for the displacements       scalar

% Precomputations
nd = size(x,2);
X = x(:,1);
Y = x(:,2);
Z = x(:,3);
ux = u(1:nd:end);
uy = u(2:nd:end);
uz = u(3:nd:end);

% Initialize figure
figure
hold on
axis equal;
colormap jet;

% Plot undeformed structure
plot3(X(Tnod)',Y(Tnod)',Z(Tnod)','-k','linewidth',0.5);

% Plot deformed structure with stress colormapped
patch(X(Tnod)'+scale*ux(Tnod)',Y(Tnod)'+scale*uy(Tnod)',Z(Tnod)'+scale*uz(Tnod)',[sig';sig'],'edgecolor','flat','linewidth',2);

% View angle
view(45,20);

% Add axes labels
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')

% Add title
title(sprintf('Deformed structure (scale = %g)',scale));

% Add colorbar
cbar = colorbar('Ticks',linspace(min(sig),max(sig),5));
title(cbar,{'Stress';'(Pa)'});

end