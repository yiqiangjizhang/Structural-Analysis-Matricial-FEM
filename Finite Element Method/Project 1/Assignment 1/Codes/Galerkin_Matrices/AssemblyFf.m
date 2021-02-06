function [Ff] = AssemblyFf(n_nodes,n_elem,CN,n_nodeE,COOR,H_e,Fe_eq,s)

Fe = zeros(n_nodeE,1);
Ff = sparse(n_nodes,1);

    for e=1:n_elem
        % Element Force
            % Matlab symbolic
%                 Fe = Compute_Fe_force(COOR,e,H_e,Fe_eq); 
            % Gauss quadrature
                Fe = Compute_Fe_force_GQ(COOR,e,H_e,s);
        for a = 1:n_nodeE
            A = CN(e,a);
            Ff(A) = Ff(A) + Fe(a);
        end
    end

end
