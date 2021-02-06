function plotStrainStress(n_d,s,x,Tn,title_name)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d            Problem's dimensions
%   - s     Strain/stress vector [n_el x 1]
%            s(e) - Strain/stress associated to bar e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - fact  Scale factor for the deformed structure
%--------------------------------------------------------------------------

% Reshape matrices for plot
for i = 1:n_d
    X0{i} = reshape(x(Tn,i),size(Tn))';
end
S = repmat(s',size(Tn,2),1);

% Open and initialize figure
figure('color','w');
hold on;       % Allow multiple plots on same axes
box on;        % Closed box axes
axis equal;    % Keep aspect ratio to 1
colormap jet;  % Set colormap colors

% Add axes labels
xlabel('x (m)')
ylabel('y (m)')
title(title_name{1});

% Plot undeformed structure
patch(X0{:},S,'edgecolor','flat','linewidth',2);

% Set colorbar properties
caxis([min(S(:)),max(S(:))]);
cbar = colorbar;
set(cbar,'Ticks',linspace(min(S(:)),max(S(:)),5));
title(cbar,title_name);