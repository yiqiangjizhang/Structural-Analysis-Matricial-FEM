function [Ff,Ff_GQ] = AssemblyFf(n_nodes,n_elem,CN,n_nodeE,COOR,H_e,Fe_eq)

Fe = zeros(n_nodeE,1);
Ff = sparse(n_nodes,1);
Fe_GQ = zeros(n_nodeE,1);
Ff_GQ = sparse(n_nodes,1);

    for e=1:n_elem
        % Element Force
            % Matlab symbolic
             Fe = Compute_Fe_force(COOR,e,H_e,Fe_eq); 
            % Gauss quadrature
             Fe_GQ = Compute_Fe_force_GQ(COOR,e,H_e)
        for a = 1:n_nodeE
            A = CN(e,a);
            Ff(A) = Ff(A) + Fe(a);
            Ff_GQ(A) = Ff_GQ(A) + Fe_GQ(a);
        end
    end

end
