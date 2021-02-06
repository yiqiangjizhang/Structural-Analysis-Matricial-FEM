function CNb = ElemBnd(CONNECTb,NODESb)
% CONNECTb=  Connectivity matrix for   boundary elements 
% NODESb = Given set of boundary nodes 
% CNb =  Connectivity matrix for  the boundary elements formed by nodes NODESb
setBelem = [] ;
for ielemB=1:size(CONNECTb,1) 
    isSET = 1; 
    for jnode=1:size(CONNECTb,2)
         jnodeG = CONNECTb(ielemB,jnode) ; 
         isSET = isSET*any(jnodeG ==NODESb) ;             
    end
    if isSET == 1
        setBelem = [setBelem ielemB] ;
    end
end
CNb = CONNECTb(setBelem,:) ; 