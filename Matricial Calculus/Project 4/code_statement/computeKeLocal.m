function [Ke_local] = computeKeLocal(inputArg1,inputArg2)

% First matrix
Ke_1 = zeros(2*n_i, 2*n_i);
Ke_1(2,2) = 12;
Ke_1(2,3) = 6*Le;
Ke_1(2,5) = -12;
Ke_1(2,6) = 6*Le;
Ke_1(3,3) = 4*Le^2;
Ke_1(3,5) = -6*Le;
Ke_1(3,6) = 2*Le^2;
Ke_1(5,5) = 12;
Ke_1(5,6) = -6*Le;
Ke_1(6,6) = 4*Le^2;
for i = 1:size(Ke_1,1)
    for j = 1:i
        Ke_1(i,j) = Ke_1(j,i);
    end
end
Ke_1 = 


end

