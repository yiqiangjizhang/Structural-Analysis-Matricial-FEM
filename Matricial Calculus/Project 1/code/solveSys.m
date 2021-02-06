function [u,R] = solveSys(vL,vR,uR,KG,Fext)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

KLL = KG(vL, vL);
KLR = KG(vL, vR);
KRL = KG(vR, vL);
KRR = KG(vR, vR);
Fext_L = Fext(vL);
Fext_R = Fext(vR);

% Displaying the condition number of KLL matrix.
% The condition number of a matrix measures the sensitivity of the solution
% of a system of linear equations to errors in the data. It gives an 
% indication of the accuracy of the results from matrix inversion and the 
% linear equation solution. Values of cond(X) and cond(X,p) near 1 indicate 
% a well-conditioned matrix.
fprintf("Cond: %.5f\n", cond(KLL));

% Solving the linear equation
uL = linsolve(KLL, Fext_L - KLR * uR);
RR = KRR * uR + KRL * uL - Fext_R;

u(vL,1) = uL;
u(vR,1) = uR;

R(vL,1) = 0;
R(vR,1) = RR;

end