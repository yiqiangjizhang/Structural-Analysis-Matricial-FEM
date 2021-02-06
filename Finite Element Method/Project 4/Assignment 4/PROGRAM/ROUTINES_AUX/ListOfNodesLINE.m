function rnod = ListOfNodesLINE(NameFileMesh,ILINE) 


try

[NODES_FACES,NODES_LINES] = NodesFacesLinesGID(NameFileMesh(1:end-4)) ; 

catch
    NAME_DATA = [NameFileMesh(1:end-4),'.gid',filesep,NameFileMesh(1:end-4)] ; 
    [NODES_FACES,NODES_LINES] = NodesFacesLinesGID(NAME_DATA) ; 
end


rnod = unique(cell2mat(NODES_LINES(ILINE))) ; 