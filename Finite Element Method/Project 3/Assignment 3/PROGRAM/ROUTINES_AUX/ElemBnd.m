function CNb = ElemBnd(CONNECTb,NODESb)
% CONNECTb=  Connectivity matrix for   boundary elements 
% NODESb = Given set of boundary nodes 
% CNb =  Connectivity matrix for  the boundary elements formed by nodes NODESb


% NEw version for removing repeated boundary elements (18-May-2017)
if nargin==0
    load('tmp.mat')
    
    CONNECTb = [1   2
                3   1
                4  5
                4    5
               8   7 ] ; 
    
end

%% Remove repeated connectivities
CONNECTb = RemoveREpeatedConnectivities(CONNECTb)  ; 
 
 
 

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