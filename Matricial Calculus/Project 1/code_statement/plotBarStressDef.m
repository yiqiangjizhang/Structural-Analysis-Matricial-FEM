function plotBarStressDef(x,Tn,u,sig,scale)
%--------------------------------------------------------------------------
% PLOTBARSTRESSDEF function. 
% The function takes as inputs:                     Type [Dimensions]
%   - x      Nodal coordinates matrix (in m)          matrix [ n    , n_d   ]
%   - Tn     Nodal connectivities matrix              matrix [ n_el  , n_nod ]
%   - u      Array with global displacements (in m)   array  [ n_dof ]
%   - sig    Array with stress for each bar (in Pa)   array  [ n_el  ]
%   - scale  Scale factor for the displacements       scalar
%--------------------------------------------------------------------------

% Precomputations
n_d = size(x,2);
X = x(:,1);
Y = x(:,2);
ux = u(1:n_d:end);
uy = u(2:n_d:end);

% Initialize figure
figure('color','w');
hold on
box on
axis equal;
colormap jet;

% Plot undeformed structure
plot(X(Tn)',Y(Tn)','-k','linewidth',0.5);

% Plot deformed structure with stress colormapped
patch(X(Tn)'+scale*ux(Tn)',Y(Tn)'+scale*uy(Tn)',[sig';sig'],'edgecolor','flat','linewidth',2);

% Add axes labels
xlabel('x (m)')
ylabel('y (m)')

% Add title
title(sprintf('Deformed structure (scale = %g)',scale));

% Add colorbar
caxis([min(sig(:)),max(sig(:))]);
cbar = colorbar;
set(cbar,'Ticks',linspace(min(sig(:)),max(sig(:)),5));
title(cbar,{'Stress';'(Pa)'});

end