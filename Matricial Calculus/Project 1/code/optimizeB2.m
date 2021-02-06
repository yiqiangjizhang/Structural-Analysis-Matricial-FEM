function [sells_opt, e_opt, u_opt, eps_opt, sig_opt] = optimizeB2(n_d, n_dof, n_el, n_nod, n_el_dof, Tn, Td, mat, Tmat, x, Fdata, Fext, fixNod)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It provides as output:
%   - sells_opt - Optimum of sells     
%   - e_opt     - Vector of elements in the optimal estructure
%   - u_opt     - Vector of displacements in the optimal estructure
%--------------------------------------------------------------------------

sells_opt = 0;
e_opt = 0;
u_opt = 0;
n_i = n_d; %Redundant variable, as defined in main_01

% Initial vector of elements, imposing elements 1-6 and 16
% If v(i) = 1, element i is in the structure, otherwise it is eliminated
v0 = zeros(n_el, 1);
v0(1:6,1) = 1;
v0(16,1) = 1;
modBars = 9; % Number of bar elements that can be modified

eps_1 = 0;
sig_1 = 0;

% Find the optimum by brute force
for i = 0:(2^modBars-1)    
    % Generate vector of sequence 
    str = dec2bin(i,modBars);
    v = v0;
    for j = 1:modBars
        if str(1,j) == '0'
            v(j+6) = 0;
        else
            v(j+6) = 1;
        end
    end
    v(7) = 0; %Bar element 7 always can be removed, since it joins two fixed points and does no work
    % Generate vector of elements present in the structure
    n_el_case = sum(v);
    e_case = zeros(n_el_case, 1);
    k = 1;
    for i = 1:n_el
        if v(i) == 1
            e_case(k) = i;
            k = k + 1;
        end
    end
    % Generate the particular Tn and Tmat matrices for the case 
    Tn_case = Tn(e_case, 1:size(Tn,2));
    Tmat_case = Tmat(e_case, 1:size(Tmat,2));
    
    % Computation of the DOFs connectivities
    Td = connectDOFs(n_el_case,n_nod,n_i,Tn_case);

    % Computation of element stiffness matrices
    Kel = computeKelBar(n_d,n_el_case,x,Tn_case,mat,Tmat_case);

    % Global matrix assembly
    KG = assemblyKG(n_el_case,n_el_dof,n_dof,Td,Kel);

    % Global force vector assembly
    Fext = computeF(n_i,n_dof,Fdata);

    % Apply conditions 
    [vL,vR,uR] = applyCond(n_i,n_dof,fixNod);

    % System resolution
    [u,R,canSolve] = solveSys2(vL,vR,uR,KG,Fext);
    
    % If KLL is not singular, i.e., cond(KLL) > 1e3, 
    if canSolve == 1        
        % Compute sells 
        sells = computeSells(n_el, n_d, x, Tn, mat, Tmat, v);        
        [eps, sig] = computeStrainStressBar(n_d, n_el_case, u, Td, x, Tn_case, mat, Tmat_case);
        if sells_opt < sells & max(sig) < 50e6
            sells_opt = sells;
            e_opt = e_case;
            u_opt = u;
            eps_opt = eps;
            sig_opt = sig;
        end
    end
end

end

