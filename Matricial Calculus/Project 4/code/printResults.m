function printResults(n_el, n_ne, n_i, n_dof, Tnod, u, Fx_el, Fy_el, Mz_el)

for e = 1:n_el
    fprintf("\nElement %d - (%d,%d)\n", e, Tnod(e,1), Tnod(e,2));
    fprintf("%10s%15s%15s%15s\n", "Node", "Axial (Pa)", "Shear (Pa)", "Bending (N·m)");
    for i = 1:n_ne
        fprintf("%10d%15.3f%15.3f%15.3f\n", Tnod(e,i), Fx_el(e,i), Fy_el(e,i), Mz_el(e,i));
    end
end

fprintf("\nDisplacement components at node 1\n");
fprintf("%10s%15s\n", "DOF", "Magnitude");
for i = 1:n_i
    fprintf("%10d%15.3f\n", i, 1e3*u(i));
end

fprintf("\nDisplacement components\n");
fprintf("%10s%15s\n", "DOF", "Magnitude");
for i = 1:n_dof
    fprintf("%10d%15.3f\n", i, 1e3*u(i));
end

end