function [dZdt] = TwohostOnepopODE(t,Z,beta, gamma, mu, alpha,lambda, tol1)

%Z = [S, x]
%S = [S_{1}, S_{2}]
%x = [x_{11},x_{12},x_{21},x_{22}]
%lambda = [lambda_{1A}, lambda_{2A}, lambda_{1B}, lambda_{2B}]
%beta = 2 x 2 x 2 array so that alpha can freely evolve
%in subpopulation a
%\gamma = [gamma_1,gamma_2]
%\mu = [\mu_1, \mu_2]
%alpha = 2x2 matrix


S = Z(1:2);
x = Z(3:6);

dSdt(1) = lambda(1) - S(1)*(beta(1,1,1)*x(1)+beta(1,1,2)*x(2)) - S(1)*(beta(1,2,1)*x(3)+beta(1,2,2)*x(4)) - mu(1)*S(1) + gamma(1)*(x(1)+x(2));
dSdt(2) = lambda(2) - S(2)*(beta(2,1,1)*x(1)+beta(2,1,2)*x(2)) - S(2)*(beta(2,2,1)*x(3)+beta(2,2,2)*x(4)) - mu(2)*S(2) + gamma(2)*(x(3)+x(4)); 

dxdt(1) = S(1)*(beta(1,1,1)*x(1)+beta(1,1,2)*x(2))-(alpha(1,1)+mu(1)+gamma(1))*x(1);
dxdt(2) = S(1)*(beta(1,2,1)*x(3)+beta(1,2,2)*x(4))-(alpha(1,2)+mu(1)+gamma(1))*x(2);
dxdt(3) = S(2)*(beta(2,1,1)*x(1)+beta(2,1,2)*x(2))-(alpha(2,1)+mu(2)+gamma(2))*x(3);
dxdt(4) = S(2)*(beta(2,2,1)*x(3)+beta(2,2,2)*x(4))-(alpha(2,2)+mu(2)+gamma(2))*x(4);

dZdt = [dSdt, dxdt]';

end

