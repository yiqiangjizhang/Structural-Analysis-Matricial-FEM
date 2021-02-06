function Fe = Compute_Fe_force_GQ(COOR,e,H_e,s)
    
    xe_1 = COOR(e);
    xe_2 = COOR(e+1);

% Retrieve the weigths and the position of the Gauss points
    xiG(1) = sqrt(3/5);
    xiG(2) = -sqrt(3/5);
    xiG(3) = 0;
    w(1) = 5/9;
    w(2) = 5/9;
    w(3) = 8/9;
    
% Evaluate element shape functions at each Gauss point
    for j=1:1:length(xiG)
       N_e(j,1) =  0.5*(1-xiG(j));
       N_e(j,2) =  0.5*(1+xiG(j));
    end
  
% Compute position each Gauss point in physical domain
    x = [xe_1;xe_2];
    x_e = N_e*x;

% Calculate the value of the function f at each Gauss point
    f = -s*x_e.^2;

% Compute vector Fe
Sum = 0;
    for g = 1:1:length(w)
        Sum = Sum + w(g)*N_e(g,:).'*f(g);            
    end
    Fe = 0.5*H_e(e)*Sum;

end

 