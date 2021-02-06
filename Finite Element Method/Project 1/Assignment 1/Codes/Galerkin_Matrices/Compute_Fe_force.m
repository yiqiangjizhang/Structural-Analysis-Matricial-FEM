function Fe = Compute_Fe_force(COOR,e,H_e,Fe_eq)
    
    syms xe_1_sym xe_2_sym

    xe_1 = COOR(e);
    xe_2 = COOR(e+1);
    
    %Fe = 0.5*H_e(e)*[-(9741*xe_1^2)/20000 - (3247*xe_1*xe_2)/10000 - (3247*xe_2^2)/20000 ;
    %                 -(3247*xe_1^2)/20000 - (3247*xe_1*xe_2)/10000 - (9741*xe_2^2)/20000];
             
    Fe = 0.5*H_e(e)*subs(subs(Fe_eq,xe_1_sym,xe_1),xe_2_sym,xe_2);
    
end