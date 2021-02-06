function [] = printEpsSig(eps, sig)

fprintf("%10s%15s%15s\n", "e", "eps", "sig (MPa)");
for i = 1:size(eps,1)
    fprintf("%10d%15.3e%15.3f\n", i, eps(i), sig(i)*1e-6);
end
fprintf("\n");

end