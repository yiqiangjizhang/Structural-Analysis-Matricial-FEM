function [a, lift, weight, thrust, drag] = computeForces(g, L, H, Mdata, section)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - g         Earth's gravity
%   - L         Glider's dimension
%   - H         Glider's dimension
%   - Mdata     Mass applied on every node
%   - section   Section of the problem: "B1" or "B3"
%--------------------------------------------------------------------------
% It must provide as output:
%   - a         Acceleration vector
%   - lift      Lift modulus
%   - weight    Weight modulus
%   - thrust    Thrust modulus
%   - drag      Drag modulus
%--------------------------------------------------------------------------

% Compute forces modulus depending on section
if section == "B1"
    %fprintf("Computing B1\n");
    lift = g * sum(Mdata);
    drag = (L*g/(2*H)) * (3*(Mdata(1)+Mdata(2)+Mdata(3)) - (Mdata(4)+Mdata(5)+Mdata(6)));
    thrust = drag;
else 
    %fprintf("Computing B3\n");
    lift = 1.25 * g * sum(Mdata);
    drag = 1.25 * (L*g/(2*H)) * (3*(Mdata(1)+Mdata(2)+Mdata(3)) - (Mdata(4)+Mdata(5)+Mdata(6)));
    thrust = (L/(2*H)) * (4*g*(Mdata(1)+Mdata(2)+Mdata(3)) - lift);
end
weight = g * sum(Mdata);

% Force vectors
Lift = [0; 0; lift];
Drag = [-drag; 0; 0];
Thrust = [thrust; 0; 0];
Weight = [0; 0; -weight];

% Compute acceleration
a = (Lift + Drag + Thrust + Weight) / sum(Mdata);

end