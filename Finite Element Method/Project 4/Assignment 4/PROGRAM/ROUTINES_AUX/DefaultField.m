function  DATAGEN = DefaultField(DATAGEN,FIELDVAR,dEFval) ; 
%dbstop('3')
if ~isfield(DATAGEN,FIELDVAR)
    DATAGEN.(FIELDVAR) = dEFval ; 
end