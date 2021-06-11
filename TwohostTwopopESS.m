function [alpha, LEig, REig] = TwohostTwopopESS(alpha, m, theta, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, ind)
%m is multiplying parameter
%\theta are 2x2x2 arrays storing values for beta functions
%gamma is recovery rate (1 x 2 vector)
%mu is natural mortality (1 x 2 vector)
%B is beta function
%diffB is the derivative of beta function wrt alpha
%dA is amount strategy can change per time step
%lambda is contains influx rates
%tol0 is convergence criteria for finding ESS
%tol1 is convergence criteria for finding resident equilibrium values
%sigma is mixing between subpopulations
%c is the 2x2x2 array that controls how different host types interact
%within subpopulations
%ind determines any constraints: ind == 1 origin-and-sex-specific; 2 =
%sex-specific; 3 = origin-specific; 4 = no-plasticity

%initial conditions
ics1 = [0.25, 0.25, 0.25, 0.25, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]; 
tspace = [0, 1000];
selectgrad = ones(2,2);
NZ1 = norm(selectgrad);
while (NZ1 > tol0)
    xz(1,1,1) = 1; xz(1,1,2) = 2; xz(1,2,1) = 3; xz(1,2,2) = 4;
    xz(2,1,1) = 5; xz(2,1,2) = 6; xz(2,2,1) = 7; xz(2,2,2) = 8;
    
    %compute transmission values with new virulence levels
    for i1 = 1:2
        for i2 = 1:2
            for i3 = 1:2
                beta(i1,i2,i3) = B(alpha(i2,i3),m,theta(i1,i2,i3));
                dB(i1,i2,i3) = diffB(alpha(i2,i3),m,theta(i1,i2,i3));
            end
        end
    end
    %find resident equilibrium
    xoverFcn = @(t,x) event_function2pop(t, x, beta, sigma, gamma, mu, alpha, c, lambda, tol1);
    options = odeset('Events',xoverFcn);
    [t,y] = ode45(@(t,x)TwohostTwopopODE(t, x, beta, sigma, gamma, mu, alpha, c, lambda, tol1), tspace, ics1, options);
    %equilibrium density of susceptibles
    maxt = size(t);
    S = y(maxt(1),1:4);
    %Jacobian evaluated at resident equilibrium
    J = [S(1)*c(1,1,1)*beta(1,1,1)-mu(1)-sigma-alpha(1,1)-gamma(1), c(1,1,1)*S(1)*beta(1,1,2), 0, 0, sigma, 0, 0, 0;
        0, -alpha(1,2)-mu(1)-gamma(1)-sigma, c(1,1,2)*S(1)*beta(1,2,1), c(1,1,2)*S(1)*beta(1,2,2), 0, sigma, 0, 0;
        c(1,1,2)*S(2)*beta(2,1,1), c(1,1,2)*S(2)*beta(2,1,2), -alpha(2,1)-mu(2)-gamma(2)-sigma, 0, 0, 0, sigma, 0;
        0, 0, c(1,2,2)*S(2)*beta(2,2,1), S(2)*c(1,2,2)*beta(2,2,2)-mu(2)-sigma-alpha(2,2)-gamma(2), 0, 0, 0, sigma;
        sigma, 0, 0, 0, S(3)*c(2,1,1)*beta(1,1,1)-mu(1)-sigma-alpha(1,1)-gamma(1), c(2,1,1)*S(3)*beta(1,1,2), 0, 0;
        0, sigma, 0, 0, 0, -alpha(1,2)-mu(1)-gamma(1)-sigma, c(2,1,2)*S(3)*beta(1,2,1), c(2,1,2)*S(3)*beta(1,2,2);
        0, 0, sigma, 0, c(2,1,2)*S(4)*beta(2,1,1), c(2,1,2)*S(4)*beta(2,1,2), -alpha(2,1)-mu(2)-gamma(2)-sigma, 0;
        0, 0, 0, sigma, 0, 0, c(2,2,2)*S(4)*beta(2,2,1), S(4)*c(2,2,2)*beta(2,2,2)-mu(2)-sigma-alpha(2,2)-gamma(2)];

    %right eigenvector of J associated with zero eigenvalue
    REig = y(maxt(1),5:12)';
    %find left eigenvectors of J
    [W,D2] = eig(J');
    %find zero eigenvalue and associated eigenvector
    [minval, minind1] = min(abs(sum(D2)));
    %make sure eigenvector is positive
    LEig= W(:,minind1)*sign(W(1,minind1));
    selectgrad = zeros(2,2);
    Sc = [S(1), S(2); S(3), S(4)];
    %compute selection gradients
    for j1 = 1:2
        for k1 = 1:2
            for l1 = 1:2
                Xp = 0;
                for m1 = 1:2
                    Xp = Xp + LEig(xz(l1,m1,j1))*c(l1,m1,j1)*dB(m1,j1,k1)*Sc(l1,m1);
                end
                selectgrad(j1,k1) = (Xp - LEig(xz(l1,j1,k1)))*REig(xz(l1,j1,k1)) + selectgrad(j1,k1);
            end
        end
    end
    %update new values of alpha_{ij}
    if (ind == 1)
        %origin-and-sex-specific
        alpha = (selectgrad)*dA + alpha;
        NZ1 = norm(selectgrad);
    elseif (ind == 2)
        %SS alone
        SSa = sum(selectgrad');
        alpha = alpha + dA*[SSa',SSa'];
        NZ1 = norm(sum(selectgrad'));
    elseif (ind == 3)
        %OS alone
        OSa = sum(selectgrad);
        alpha = alpha + dA*[OSa; OSa];
        NZ1 = norm(sum(selectgrad));
    elseif (ind == 4)
        %no plasticity
        NP = sum(sum(selectgrad));
        alpha = alpha + dA*NP;
        NZ1 = norm(sum(sum(selectgrad)));
    end
        
        
    %make sure step size doesn't result in alpha being negative
    alpha(alpha<0) = 0;
end


