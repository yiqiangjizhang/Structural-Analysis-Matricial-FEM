function [Fe_hat, STRAIN, STRESS] = Compute_Fe_force_GQ(COOR,AreaFUN,d_k,stressFUN)

    % Element longitude calculation
        H_e = COOR(n_elem+1) - COOR(n_elem);

    % Element Coordinates
        xe_1 = COOR(e);
        xe_2 = COOR(e+1);

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
        A = AreaFUN(x_e);

    % Compute (B^e)^T
        B_e = 1/H_e*[-1 1];
        B_e_t = B_e';

    % Compute stress
        STRAIN(e) = B_e*[d_k(e); d_k(e+1)];
        sigma = stressFUN(STRAIN(e));
        STRESS(e) = sigma;

    % Compute vector Fe
        Fe_hat = w*B_e_t*A*sigma;
        
end