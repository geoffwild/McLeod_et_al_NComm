function [dZdt] = TwohostTwopopODE(t,Z,beta, sigma, gamma, mu, alpha, c,lambda, tol1)

%Z = [S, x]
%S = [S_{1A}, S_{2A}, S_{1B}, S_{2B}]
%x = [x_{11A},x_{12A},x_{21A},x_{22A},x_{11B},x_{12B},x_{21B},x_{22B}]
%lambda = [lambda_{1A}, lambda_{2A}, lambda_{1B}, lambda_{2B}]
%beta = 2x2x2 array so that alpha can freely evolve
%c = 2x2x2 array such that c(1,j,k) = c^A_{jk}, c(2,j,k) = c^B_{jk} is
%contact between host type i and j in subpopulation \ell
%\gamma = [gamma_1,gamma_2]
%\mu = [\mu_1, \mu_2]
%alpha = 2x2 matrix
%sigma = dispersal rate between population A and B


S = Z(1:4);
x = Z(5:12);

dSdt(1) = lambda(1) - c(1,1,1)*S(1)*(beta(1,1,1)*x(1)+beta(1,1,2)*x(2)) - c(1,1,2)*S(1)*(beta(1,2,1)*x(3)+beta(1,2,2)*x(4)) - mu(1)*S(1) + gamma(1)*(x(1)+x(2)) + sigma*S(3) - sigma*S(1);
dSdt(2) = lambda(2) - c(1,1,2)*S(2)*(beta(2,1,1)*x(1)+beta(2,1,2)*x(2)) - c(1,2,2)*S(2)*(beta(2,2,1)*x(3)+beta(2,2,2)*x(4)) - mu(2)*S(2) + gamma(2)*(x(3)+x(4)) + sigma*S(4) - sigma*S(2); 
dSdt(3) = lambda(3) - c(2,1,1)*S(3)*(beta(1,1,1)*x(5)+beta(1,1,2)*x(6)) - c(2,1,2)*S(3)*(beta(1,2,1)*x(7)+beta(1,2,2)*x(8))- mu(1)*S(3) + gamma(1)*(x(5)+x(6)) - sigma*S(3) + sigma*S(1); 
dSdt(4) = lambda(4) - c(2,1,2)*S(4)*(beta(2,1,1)*x(5)+beta(2,1,2)*x(6)) - c(2,2,2)*S(4)*(beta(2,2,1)*x(7)+beta(2,2,2)*x(8))- mu(2)*S(4) + gamma(2)*(x(7)+x(8)) - sigma*S(4) + sigma*S(2);

dxdt(1) = c(1,1,1)*S(1)*(beta(1,1,1)*x(1)+beta(1,1,2)*x(2))-(alpha(1,1)+mu(1)+gamma(1))*x(1)+sigma*x(5)-sigma*x(1);
dxdt(2) = c(1,1,2)*S(1)*(beta(1,2,1)*x(3)+beta(1,2,2)*x(4))-(alpha(1,2)+mu(1)+gamma(1))*x(2)+sigma*x(6)-sigma*x(2);
dxdt(3) = c(1,1,2)*S(2)*(beta(2,1,1)*x(1)+beta(2,1,2)*x(2))-(alpha(2,1)+mu(2)+gamma(2))*x(3)+sigma*x(7)-sigma*x(3);
dxdt(4) = c(1,2,2)*S(2)*(beta(2,2,1)*x(3)+beta(2,2,2)*x(4))-(alpha(2,2)+mu(2)+gamma(2))*x(4)+sigma*x(8)-sigma*x(4);

dxdt(5) = c(2,1,1)*S(3)*(beta(1,1,1)*x(5)+beta(1,1,2)*x(6))-(alpha(1,1)+mu(1)+gamma(1))*x(5)-sigma*x(5)+sigma*x(1);
dxdt(6) = c(2,1,2)*S(3)*(beta(1,2,1)*x(7)+beta(1,2,2)*x(8))-(alpha(1,2)+mu(1)+gamma(1))*x(6)-sigma*x(6)+sigma*x(2);
dxdt(7) = c(2,1,2)*S(4)*(beta(2,1,1)*x(5)+beta(2,1,2)*x(6))-(alpha(2,1)+mu(2)+gamma(2))*x(7)-sigma*x(7)+sigma*x(3);
dxdt(8) = c(2,2,2)*S(4)*(beta(2,2,1)*x(7)+beta(2,2,2)*x(8))-(alpha(2,2)+mu(2)+gamma(2))*x(8)-sigma*x(8)+sigma*x(4);

dZdt = [dSdt, dxdt]';

end

