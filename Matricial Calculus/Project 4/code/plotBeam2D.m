function plotBeam2D(x,Tnod,u,scale)
% PLOTBEAM2D - Plot beam's nodes displacements
% Inputs:
%   x      Nodal coordinates matrix
%   Tnod   Nodal connectivities matrix
%   u      Array with global displacements and rotations
%   scale  Scale factor for displacements

fig = figure(1);
hold on
axis equal

X = x(:,1);
Y = x(:,2);
ux = u(1:3:end);
uy = u(2:3:end);

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% Plot undeformed structure
plot(X(Tnod)',Y(Tnod)','-k','linewidth',0.5);

% Plot deformed structure
X1 = X(Tnod)'+scale*ux(Tnod)';
Y1 = Y(Tnod)'+scale*uy(Tnod)';
plot(X1,Y1,'color','blue','linewidth',2.5);

xlabel("$x \ \left( \mathrm{m} \right)$");
ylabel("$y \ \left( \mathrm{m} \right)$");
xlim([-1.5 1.5]);
ylim([0 2.25]);
yticks([0:0.25:2.25]);

title(sprintf('Deformed structure (scale = %g)',scale));

set(gca,'Xdir','reverse');
grid on;
grid minor;
box on;
set(gcf,'units','centimeters','position',[2,2,20,14]);
%legend("Estructura no deformada", "Estructura deformada");
