function [Error_u, Error_u_prime] = Error_calculation(COOR,H_e,n_elem,u_approx)
   
    d_e = u_approx;
    
for e=1:n_elem
       
    xe_1 = COOR(e);
    xe_2 = COOR(e+1);
    B_e = 1/H_e(e)*[-1 1];
    % poner como calculo la u prime
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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
    x_e = [xe_1;xe_2];
    x = N_e*x_e;
    
% Compute vector Fe
Sum_u = 0;
Sum_u_prime = 0;
    for g = 1:1:length(w)
        % Gauss Quadrature u
        Sum_u = Sum_u + w(g)*(0.01.*cos(3.141592654.*x(g))+0.03141592654.*sin(3.141592654.*x(g)) ... 
        +0.09869604401.*x(g).^2-0.02 - N_e(g,:)*d_e(e:(e+1))').^2;   
        % Gauss Quadrature u prime
        Sum_u_prime = Sum_u_prime + w(g)*(0.197392088.*x(g) + 0.09869604401.*cos(3.141592654.*x(g)) ...
        - 0.03141592654.*sin(3.141592654.*x(g)) - B_e*d_e(e:(e+1))').^2;
    end 
    Error_u(e) = 0.5*H_e(e)*Sum_u;
    Error_u_prime(e) = 0.5*H_e(e)*Sum_u_prime;
  
end
    
end

 