function plotBeam2D(x,Tnod,u,scale)
% PLOTBEAM2D - Plot beam's nodes displacements
% Inputs:
%   x      Nodal coordinates matrix
%   Tnod   Nodal connectivities matrix
%   u      Array with global displacements and rotations
%   scale  Scale factor for displacements

figure
hold on
axis equal

X = x(:,1);
Y = x(:,2);
ux = u(1:3:end);
uy = u(2:3:end);

% Plot undeformed structure
p1 = plot(X(Tnod)',Y(Tnod)','-k','linewidth',0.5);

% Plot deformed structure
p2 = plot(X(Tnod)'+scale*ux(Tnod)',Y(Tnod)'+scale*uy(Tnod)','color',[0,0.5,1],'linewidth',2.5);

xlabel('x (m)');
ylabel('y (m)');

title(sprintf('Deformed structure (scale = %g)',scale));

set(gca,'Xdir','reverse');