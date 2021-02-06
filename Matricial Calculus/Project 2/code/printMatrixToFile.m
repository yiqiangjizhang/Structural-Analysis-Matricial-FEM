function [] = printMatrixToFile(matrix, file_name)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - matrix        fixNod matrix to be printed
%   - file_name     Name of file where the matrix is going to be printed
%--------------------------------------------------------------------------

fileID = fopen(file_name, 'at');
for i = 1:size(matrix,1)
    for j = 1:size(matrix,2)
        fprintf(fileID, "%5d", matrix(i,j));
    end
    fprintf(fileID, "\n");
end
fprintf(fileID, "\n");
fclose(fileID);

end