function Ke_local = computeKeLocal(n_d, e, Le, mat, Tmat)

% Define matrix 1
matrix1 = zeros(2*(n_d+1),2*(n_d+1));
% Diagonal
matrix1(2,2) = 12;
matrix1(5,5) = 12;
matrix1(3,3) = 4*Le^2;
matrix1(6,6) = 4*Le^2;
% Out of diagonal
matrix1(2,3) = 6*Le;
matrix1(2,6) = 6*Le;
matrix1(2,5) = -12;
matrix1(2,6) = 6*Le;
matrix1(3,5) = -6*Le;
matrix1(5,6) = -6*Le;
matrix1(3,6) = 2*Le^2;
% Symmetrization automorphism
for i = 1:size(matrix1,1)
    for j = 1:i-1
        matrix1(i,j) = matrix1(j,i);
    end
end
matrix1

% Define matrix 2
matrix2 = zeros(2*(n_d+1),2*(n_d+1));
matrix2(1,1) = 1;
matrix2(4,4) = 1;
matrix2(1,4) = -1;
matrix2(4,1) = -1;
matrix2

% Compute stiffness matrix in local coordinates
Ke_local = (mat(Tmat(e),3)*mat(Tmat(e),1)/Le^3)*matrix1 + (mat(Tmat(e),2)*mat(Tmat(e),1)/Le)*matrix2;

end