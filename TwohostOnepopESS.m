function [alpha, LEig, REig] = TwohostOnepopESS(alpha, m, theta, gamma, mu, tol0, tol1, B, diffB, C, dA, lambda)
ics1 = [0.25, 0.25, 0.01, 0.01, 0.01, 0.01]; 
%m is multiplying parameter
%\theta are 2x2x2 arrays storing values for beta functions
%gamma is recovery rate
%mu is natural mortality
%B is beta function
%diffB is the derivative of beta function wrt alpha
%C is constraint matrix
%dA is amount strategy can change per time step
%lambda is contains influx rates
%tol0 is convergence criteria for finding ESS
%tol1 is convergence criteria for finding resident equilibrium values

%time to run simuation for
tspace = [0 10000];

beta = zeros(2,2,2);
dB = zeros(2,2,2);
selectgrad = ones(2,2);
while (norm(selectgrad) > tol0)
    %compute transmission values with new virulence levels
    for i1 = 1:2
        for i2 = 1:2
            for i3 = 1:2
                beta(i1,i2,i3) = B(alpha(i2,i3), m, theta(i1,i2,i3));
                dB(i1,i2,i3) = diffB(alpha(i2,i3), m, theta(i1,i2,i3));
            end
        end
    end

    %find resident equilibrium
    xoverFcn = @(t,x) event_function1pop(t,x, beta, gamma, mu, alpha, lambda, tol1);
    options = odeset('Events',xoverFcn);
    [t,y] = ode45(@(t,x)TwohostOnepopODE(t,x, beta, gamma, mu, alpha, lambda, tol1), tspace, ics1, options);
    %equilibrium density of susceptibles
    maxt = size(t);
    S = y(maxt(1),1:2);
    %Jacobian evaluated at resident equilibrium
    J = [S(1)*beta(1,1,1)- mu(1)-alpha(1,1)-gamma(1), S(1)*beta(1,1,2), 0, 0;
        0, -alpha(1,2)-mu(1)-gamma(1), S(1)*beta(1,2,1), S(1)*beta(1,2,2);
        S(2)*beta(2,1,1), S(2)*beta(2,1,2), -alpha(2,1)-mu(2)-gamma(2), 0;
        0, 0, S(2)*beta(2,2,1), S(2)*beta(2,2,2)-mu(2)-alpha(2,2)-gamma(2)];
    %right eigenvector of J associated with zero eigenvalue
    REig = y(maxt(1),3:6)';
    %find left eigenvectors of J
    [W,D2] = eig(J');
    %find zero eigenvalue and associated eigenvector
    [minval, minind1] = min(abs(sum(D2)));
    %make sure eigenvector is positive
    LEig= W(:,minind1)*sign(W(1,minind1));

    %next vector used to compute selection gradient
    deltaA(1) = LEig(1)*REig(1)*(S(1)*dB(1,1,1) - 1) + LEig(3)*REig(1)*S(2)*dB(2,1,1);
    deltaA(2) = LEig(1)*REig(2)*S(1)*dB(1,1,2) - LEig(2)*REig(2) + LEig(3)*REig(2)*S(2)*dB(2,1,2);
    deltaA(3) = LEig(2)*REig(3)*S(1)*dB(1,2,1) - LEig(3)*REig(3) + LEig(4)*REig(3)*S(2)*dB(2,2,1);
    deltaA(4) = LEig(2)*REig(4)*S(1)*dB(1,2,2) + LEig(4)*REig(4)*(S(2)*dB(2,2,2) - 1);

    deltaANew = C*deltaA';

    %compute selection gradient on
    %[alpha_{11},alpha_{12}; alpha_{21},alpha_{22}]
    selectgrad =[deltaANew(1), deltaANew(2); deltaANew(3), deltaANew(4)];

    %update new values of alpha_{ij}
    alpha = selectgrad*dA + alpha;

    %make sure step size doesn't result in alpha being negative
    alpha(alpha<0) = 0;
end


