function [Residual,STRAIN,STRESS] = AssemblyFint(COOR,CN,d_k,stressFUN,AreaFUN) ;

% Theoretical expression 140 and 141

% Creating of void arrays
n_elem = size(COOR,1) - 1;
STRAIN = zeros(n_elem,1);
STRESS = zeros(n_elem,1);
F_hat = zeros(n_elem+1,1);
n_nodeE = size(CN,2); % Number of nodes per element

for e=1:n_elem % Element Force - Gauss quadrature
    
    % Element longitude calculation
        H_e = COOR(e+1) - COOR(e);

    % Element Coordinates
        xe_1 = COOR(e);
        xe_2 = COOR(e+1);
        % x_e = (xe_1 + xe_2)*0.5;
    % Retrieve the weigths and the position of the Gauss points
        xiG = 0;
        w = 2;

    % Evaluate element shape functions at each Gauss point
        N_e(1) =  0.5*(1-xiG);
        N_e(2) =  0.5*(1+xiG);

    % Compute position each Gauss point in physical domain
        x = [xe_1;xe_2];
        x_e = N_e*x;

    % Compute Area
%         A = AreaFUN(x_e);
        A = AreaFUN(x_e);

    % Compute (B^e)^T
        B_e = 1/H_e*[-1 1];
        B_e_t = B_e';

    % Compute stress
        STRAIN(e) = B_e*[d_k(e); d_k(e+1)];
        sigma = stressFUN(STRAIN(e));
        STRESS(e) = sigma;

    % Compute vector Fe
        Fe_hat = w*B_e_t*A*sigma*H_e/2; 
    
    for a = 1:n_nodeE
        A = CN(e,a);
        F_hat(A) = F_hat(A) + Fe_hat(a);
    end

end

Residual = F_hat;

end