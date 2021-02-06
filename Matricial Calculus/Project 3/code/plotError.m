function plotError(nel_min, nel_part, err)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - nel_min   Minimum number of subdomains
%   - nel_part  Number of elements in which every subdomain is divided
%   - err       Vector of absolute error
%--------------------------------------------------------------------------
% The function plots error vs nel_min*nel_part
%--------------------------------------------------------------------------

n_el = nel_min * nel_part;

figure(2);
hold on;
plot(n_el, err, 'b');
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
xlim([0, max(n_el)]);
xticks(nel_part);
xlabel("N\'umero de elementos $\left( n_{el} \right)$");
ylabel("Error relativo $\left( \varepsilon_r \right)$");
set(gca, 'XScale', 'log');
width = 16;
set(gcf,'units','centimeters','Position',[20,2,width,8*width/11]);
grid on;
grid minor;
hold off;

end