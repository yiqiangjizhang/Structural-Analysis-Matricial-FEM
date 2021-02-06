function [u, R] = solveSys(vL, vR, uR, KG, Fext)
%--------------------------------------------------------------------------
% Inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Outputs:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

% Partition of KG matrix and Fext vector
KLL = KG(vL, vL);
KLR = KG(vL, vR);
KRL = KG(vR, vL);
KRR = KG(vR, vR);
Fext_L = Fext(vL);
Fext_R = Fext(vR);

% Computation of displacements and reactions
uL = linsolve(KLL, Fext_L - KLR * uR);
RR = KRR * uR + KRL * uL - Fext_R;

% Assign displacements
u(vL,1) = uL;
u(vR,1) = uR;

% Assign reactions
R(vL,1) = 0;
R(vR,1) = RR;

end