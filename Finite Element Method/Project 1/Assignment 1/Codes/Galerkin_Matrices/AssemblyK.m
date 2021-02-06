function [K,H_e] = AssemblyK(COOR,CN,n_elem,n_nodes,n_nodeE,rho)

K = sparse(n_nodes, n_nodes);

for e=1:n_elem  % Loop over number of elements 
    
    % Element matrix
    NODES_e = CN(e,:);            % Global numbering of nodes of element "e"
    COOR_e = COOR(NODES_e);
    h_e = COOR_e(2)-COOR_e(1);    % Size finite element
    H_e(e) = h_e;
    
    % Elemental matrix
    Ke = 1/h_e * [1 -1; -1 1] - rho*h_e/6 * [2 1; 1 2];
    
    % Assembly
    for a = 1:n_nodeE
        for b = 1:n_nodeE
            A = CN(e,a);
            B = CN(e,b);
            K(A,B) = K(A,B) + Ke(a,b);
        end
    end
end
