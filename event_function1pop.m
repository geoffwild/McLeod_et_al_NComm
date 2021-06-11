function [value, isterminal, direction] = event_function1pop(t,x,beta, gamma, mu, alpha,lambda,tol1)

Z = TwohostOnepopODE(t,x,beta, gamma, mu, alpha,lambda,tol1);

%this function just checks see if the ode45 has reached equilibrium or not
%if the norm of the derivative values is less then tol1, it is assumed
%equilibrium has been reached
%obviously the smaller tol1, the more accurate the results but the longer
%the simulation will take
if (norm(Z) < tol1)
    value = 0;
else
    value = 1;
end
isterminal = 1;
direction = 0;
end

