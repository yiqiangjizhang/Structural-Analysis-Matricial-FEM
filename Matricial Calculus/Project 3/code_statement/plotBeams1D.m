function plotBeams1D(fig,x,Tnod,nsub,pu,pt,Fy,Mz)
% PLOTBEAMS1D - Plot displacements, rotations, shear force and bending
% moment for 1D beam
% Inputs:
%   fig      Figure handle
%   x        Nodal coordinates matrix
%   Tnod     Nodal connectivities matrix
%   nsub     Number of elements's subdivisions to evaluate displacements
%            and rotations
%   pu       Polynomial coefficients for each elements's displacements
%   pt       Polynomial coefficients for each elements's rotations 

nel = size(Tnod,1);
xel = x(Tnod)';
Fy_el = Fy';
Mz_el = Mz';
x_el = zeros(nsub+1,nel);
u_el = zeros(nsub+1,nel);
theta_el = zeros(nsub+1,nel);    
for e = 1:nel
    le = x(Tnod(e,2))-x(Tnod(e,1));
    x_el(:,e) = x(Tnod(e,1))+(0:le/nsub:le);
    u_el(:,e) = polyval(pu(e,:),0:le/nsub:le);
    theta_el(:,e) = polyval(pt(e,:),0:le/nsub:le);
end    

figure(fig)
% Plot beam deflection
subplot(2,2,1)
plot(x_el(:),u_el(:));

% Plot beam section rotation
subplot(2,2,2)
plot(x_el(:),theta_el(:));

% Plot beam internal shear force
subplot(2,2,3)
plot(xel(:),Fy_el(:));

% Plot beam internal bending moment
subplot(2,2,4)
plot(xel(:),Mz_el(:));

end