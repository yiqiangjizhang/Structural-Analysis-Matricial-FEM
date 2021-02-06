function matrix2latex(MATRIX,precision)
if nargin == 0
    MATRIX = [4 6 3.7234234223e5; 6 8 9]
    precision = 3; 
end 

 
MATRIXcell = cell(size(MATRIX)); 
for i = 1:size(MATRIX,1)
    for j = 1:size(MATRIX,2)
        if abs(MATRIX(i,j))<1e-14 
            MATRIX(i,j) = 0 ;
        end 
         MATRIXcell{i,j} = num2str(MATRIX(i,j),precision);
        %MATRIXcell{i,j} = num2str(MATRIX(i,j),['%10.',num2str(precision),'f']);
    end
end

matrixLATEX = cellstring2latex(MATRIXcell);

NAME = [cd,'/AUXILIAR.txt'] ;
fid =fopen(NAME,'w');
%SCRIPT
for i = 1:length(matrixLATEX)
    
    fprintf(fid,'%s\n',[matrixLATEX{i}]);
    %     catch
    % dbstop('126')
    %         d = 5
    %     end
end
fod =fclose(fid);

open(NAME)
