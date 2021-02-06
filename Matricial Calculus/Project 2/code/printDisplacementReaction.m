function [] = printDisplacementReaction(u, R)

fprintf("%10s%15s%15s\n", "DOF", "u (mm)", "R (N)");
for i = 1:size(u,1)
    fprintf("%10d%15.3f%15.3e\n", i, u(i)*1e3, R(i));
end
fprintf("\n");

end