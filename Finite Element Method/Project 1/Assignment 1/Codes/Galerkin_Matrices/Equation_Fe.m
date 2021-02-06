function Fe_eq = Equation_Fe(s)

    syms xi xe_1_sym xe_2_sym
    
    N_xi = 0.5*[(1-xi) (1+xi)];
    x = N_xi*[xe_1_sym;xe_2_sym];
    f = -s*x^2;
    
    Fe_eq = int(N_xi.'*f,xi,-1,+1);
end