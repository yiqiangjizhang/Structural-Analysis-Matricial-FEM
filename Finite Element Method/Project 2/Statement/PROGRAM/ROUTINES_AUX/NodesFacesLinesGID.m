function [NODES_FACES,NODES_LINES] = NodesFacesLinesGID(NAMEFILE)


nameDAT1 = [NAMEFILE,'.dat'] ;
nameDAT2 = [NAMEFILE,'-1.dat'] ;
NODES_FACES = {} ;
if exist(nameDAT1,'file')
    DDD = load(nameDAT1) ;
    if ~isempty(DDD)
        LABELS_FACES = unique(DDD(:,2)) ;
        nmaxLABEL = max(LABELS_FACES) ;
        NODES_FACES = cell(1,nmaxLABEL) ;
        for ifaceLOC = 1:length(LABELS_FACES)
            iface = LABELS_FACES(ifaceLOC) ;
            INDX = find(DDD(:,2) == iface) ;
            NODES_FACES{iface} = DDD(INDX,1) ;
        end
    end
else
    error(['You have not generated the .dat file  (Export > Calculation File >',...
        NAMEFILE,'.dat). Don t forget to identify lines  (Data>Conditions>Assign Lines),','generate the mesh and export again'])
end
NODES_LINES = {} ;
if exist(nameDAT2,'file')
    DDD = load(nameDAT2) ;
    if ~isempty(DDD)
        LABELS_LINES = unique(DDD(:,2)) ;
        nmaxLABEL = max(LABELS_LINES) ;
        NODES_LINES = cell(1,nmaxLABEL) ;
        for ilineLOC = 1:length(LABELS_LINES)
            iline = LABELS_LINES(ilineLOC) ;
            INDX = find(DDD(:,2) == iline) ;
            NODES_LINES{iline} = DDD(INDX,1) ;
        end
    end
    
end

for i = 1:length(NODES_FACES)
    NODES_FACES{i} = unique(NODES_FACES{i}) ;
end
for i = 1:length(NODES_LINES)
    NODES_LINES{i} = unique(NODES_LINES{i}) ;
end