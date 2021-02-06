function K = AssemblyK(COOR,CN,lambda)
% COOR: Coordinate matrix
% CN % Element connectivy matrix  ;
nelem = size(CN,1) ; % Number of rows and columns SIZE
nnode = nelem+1 ;
nnodeE = size(CN,2) ;
K =sparse(nnode, nnode) ;
for e=1:nelem  % Loop over number of elements 
    % Element matrix
    NODOSe = CN(e,:);    % Global numbering of nodes of element "e"
    COOR_e = COOR(NODOSe) ;
    he = COOR_e(2)-COOR_e(1) ; % Size finite element
    % Elemental matrix
    Ke = 1/he*[1 -1; -1 1] -lambda*[] ;  % ??????  
    % Assembly
    for a = 1:nnodeE
        for b = 1:nnodeE
            A = CN(e,a)
            B = CN(e,b)
            K(A,B) = K(A,B) + Ke(a,b) ;
        end
    end
end