function l = computeEquilibriumParameter(g, L1, L2, Me, M)


%Computation of Aerodinamic forces
q1 = @(x) 0.85 - 0.15*cos(x*pi/L1);
Q1 = integral(q1, 0, L1);

q2 = @(x) -(L1-L2-x).*(L1+L2-x)/L2^2;
Q2 = integral(q2, L1, L1+L2);

% Computation of equilibrium parameter
l = g*(M+Me)/(Q1+Q2);
 
end