function [value, isterminal, direction] = event_function2pop(t, x, beta, sigma, gamma, mu, alpha, c, lambda, tol1)
%this function is just used to stop ODE45 when the simulations are close
%enough to equilibrium. What determines "close enough" is set by tol1; if
%the norm of the derivatives is less then tol1, then it is over
%Obviously as tol1 becomes smaller and smaller, the results become more
%accurate but takes longer to simulate

Z = TwohostTwopopODE(t, x, beta, sigma, gamma, mu, alpha, c, lambda, tol1);

if (norm(Z) < tol1)
    value = 0;
else
    value = 1;
end
isterminal = 1;
direction = 0;
end

