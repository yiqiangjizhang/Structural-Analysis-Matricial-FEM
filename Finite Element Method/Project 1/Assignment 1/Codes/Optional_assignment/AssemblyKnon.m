function K = AssemblyKnon(COOR,CN,d_k,AreaFUN,DerStressFUN)

% Equations 147 to 156

n_elem = size(COOR,1) - 1;
n_nodes = n_elem + 1;
K = zeros(n_nodes, n_nodes);   
n_nodeE = size(CN,2); % Number of nodes per element

for e = 1:n_elem  % Loop over number of elements 
    
    % Element longitude calculation
        H_e = COOR(e+1) - COOR(e);

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
    
    % Elemental matrix
    A = AreaFUN(x_e);
    E = DerStressFUN(e);
    
    Ke = A*E/H_e * [1 -1; -1 1];
    
    % Assembly
    for a = 1:n_nodeE
        for b = 1:n_nodeE
            A = CN(e,a);
            B = CN(e,b);
            K(A,B) = K(A,B) + Ke(a,b);
        end
    end
end