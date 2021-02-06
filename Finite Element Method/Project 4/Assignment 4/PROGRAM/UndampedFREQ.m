function [MODES, FREQ] = UndampedFREQ(M,K,neig)
    % neig = Number of nodes to be calculated
   [MODES, EIGENVAL] = eigs(K,M,neig,'sm');
   EIGENVAL = diag(EIGENVAL);
   FREQ = sqrt(EIGENVAL);
   [FREQ,imodes] = sort(FREQ);
   MODES = MODES(:,imodes);
end