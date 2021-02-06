function [] = findAllFixNod(n_i, n_dof, KG, Fext, inFileName, outFileName, maxR, maxCond)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i        Number of DOFs for each node
%                  n_dof      Number of nodes for each element
%   - KG    Global stiffness matrix
%   - Fext  External force matrix
%   - inFileName    Input file containing all possibilities of restrictions
%                   except that in which there are no displacement
%                   restrictions. Every possibility is represented by a
%                   [3x4] matrix, where:
%                       if a(i,j) = 1, there is a displacement restriction
%                       on DOF i of node j
%                       if a(i,j) = 0, there is no displacemente
%                       restriction of DOF i of node j
%                   These matrices where created using recursion in a C++
%                   program
%   - outFileName   Output file containing all the reasonable
%                   restriction possibilities. A possibility is considered
%                   to be reasonable if the matrix KLL has a condition
%                   number less or equal to maxCond and all the reactions
%                   are between -maxR and maxR. The possibilities are
%                   written in the file.
%   - maxR Maximum reaction allowed
%   - maxCond Maximum condition number allowed in KLL
%--------------------------------------------------------------------------
% It must provide as output:
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------

% Read all the matrices
file = importdata(inFileName);
% Create the out file
outFile = fopen(outFileName, 'w');
fprintf(outFile, "Valid FixNod\n\n");
fclose(outFile);

% Since the matrix of restrictions has dimensions [3x4] and the possible
% entries are 0 or 1, there are 2^12-1 possibilities (null matrix not considered)
for i = 1:size(file,1)/3
    matrix = file(3*(i-1)+1:3*i, 1:4);
    fixNod = assemblyFixNod(matrix); %Create fixNod matrix
    [vL,vR,uR] = applyCond(n_i,n_dof,fixNod); 
    [u,R,canSolve] = solveSys2(vL,vR,uR,KG,Fext,maxCond);
    if canSolve == 1 && max(abs(R)) <= maxR
        printMatrixToFile(fixNod, outFileName);
    end
end
    

end