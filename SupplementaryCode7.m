clear
tic
%transmissibility functions and their derivatives
B = inline('m*(x/(theta + x))', 'x', 'm', 'theta');
diffB = inline('m*theta/(x+theta)^2', 'x', 'm', 'theta');
%step-size for finding ESS; controls how much strategies can change per
%step
dA = 0.5;
%once norm of selection gradient is smaller then this value, ESS is assumed to be
%reached
tol0 = 0.0001;
%this is criteria used to assume resident equilibrium has been found using
%ode45
tol1 = 0.001;

%    
Nrho = 20;
rhoval = linspace(0.05, 0.95, Nrho);

%contraint matrices used for one pop models
CHO = [1,0,1,0; 0,1,0,1; 1,0,1,0; 0,1,0,1]; %constraint matrix for host of origin conditioning
CSS = [1,1,0,0; 1,1,0,0; 0,0,1,1; 0,0,1,1]; %constraint matrix for sex-specific conditioning
CUC = [1,0,0,0; 0,1,0,0; 0,0,1,0; 0,0,0,1]; %unconstrained evolution
CFC = [1,1,1,1; 1,1,1,1; 1,1,1,1; 1,1,1,1]; %no plasticity

%specify theta arrays
%no dependence
theta000 = ones(2,2,2);
%beta_{1**} > beta_{2**}
thetaI(1,1,1) = 1; thetaI(1,1,2) = 1;
thetaI(1,2,1) = 1; thetaI(1,2,2) = 1;
thetaI(2,1,1) = 3; thetaI(2,1,2) = 3;
thetaI(2,2,1) = 3; thetaI(2,2,2) = 3;

%\beta_{**1} > \beta_{**2}
thetaK(1,1,1) = 1; thetaK(1,1,2) = 3;
thetaK(1,2,1) = 1; thetaK(1,2,2) = 3;
thetaK(2,1,1) = 1; thetaK(2,1,2) = 3;
thetaK(2,2,1) = 1; thetaK(2,2,2) = 3;

%\beta_{1*1} > \beta_{2*2} > \beta_{1*2} > \beta_{2*1}
thetaIK(1,1,1) = 1; thetaIK(1,1,2) = 3;
thetaIK(1,2,1) = 1; thetaIK(1,2,2) = 3;
thetaIK(2,1,1) = 4; thetaIK(2,1,2) = 2;
thetaIK(2,2,1) = 4; thetaIK(2,2,2) = 2;

%\beta_{*1*} > \beta_{*2*}
thetaJ(1,1,1) = 1; thetaJ(1,1,2) = 1;
thetaJ(1,2,1) = 3; thetaJ(1,2,2) = 3;
thetaJ(2,1,1) = 1; thetaJ(2,1,2) = 1;
thetaJ(2,2,1) = 3; thetaJ(2,2,2) = 3;

 %\beta_{11*} > \beta_{22*} > \beta_{12*} > \beta_{21*}
thetaIJ(1,1,1) = 1; thetaIJ(1,1,2) = 1;
thetaIJ(1,2,1) = 3; thetaIJ(1,2,2) = 3;
thetaIJ(2,1,1) = 4; thetaIJ(2,1,2) = 4;
thetaIJ(2,2,1) = 2; thetaIJ(2,2,2) = 2;

%\beta_{*11} > \beta_{*22} > \beta_{*12} > \beta_{*21}
thetaJK(1,1,1) = 1; thetaJK(1,1,2) = 3;
thetaJK(1,2,1) = 4; thetaJK(1,2,2) = 2;
thetaJK(2,1,1) = 1; thetaJK(2,1,2) = 3;
thetaJK(2,2,1) = 4; thetaJK(2,2,2) = 2;

%\beta_{111} > \beta_{222} > \beta_{112} > \beta_{121}
thetaIJK(1,1,1) = 1; thetaIJK(1,1,2) = 3;
thetaIJK(1,2,1) = 4; thetaIJK(1,2,2) = 2;
thetaIJK(2,1,1) = 1; thetaIJK(2,1,2) = 3;
thetaIJK(2,2,1) = 4; thetaIJK(2,2,2) = 2;
    
m = 35;
sigma = 0.5;
gamma = [0, 0];

%%%%%figure S.2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma = 0.5;
    m = 35;
    %natural mortality rate, mu(i) = host i
    mu = [0.5, 0.5];
    %recovery rate, gamma(i) = host i
    gamma= [0, 0];
    alphavals000S2 = [0.005, 0.005; 0.005, 0.005]; alphavals000npS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsIS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsInpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsJS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsJnpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsKS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsKnpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsIKS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsIKnpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsIJS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsIJnpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsJKS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsJKnpS2 = [0.005, 0.005; 0.005, 0.005];
    alphavalsIJKS2 = [0.005, 0.005; 0.005, 0.005]; alphavalsIJKnpS2 = [0.005, 0.005; 0.005, 0.005];
    
    for i = 1:Nrho
        i
        lambda = [(mu(1)+mu(2))*rhoval(i), (mu(1)+mu(2))*(1-rhoval(i))];
        alphavals000npS2(:,:,i+1) = TwohostOnepopESS(alphavals000npS2(:,:,i),m,theta000,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsInpS2(:,:,i+1) = TwohostOnepopESS(alphavalsInpS2(:,:,i),m,thetaI,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsJnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsJnpS2(:,:,i),m,thetaJ,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsKnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsKnpS2(:,:,i),m,thetaK,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsIJnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsIJnpS2(:,:,i),m,thetaIJ,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsIKnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsIKnpS2(:,:,i),m,thetaIK,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsJKnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsJKnpS2(:,:,i),m,thetaJK,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsIJKnpS2(:,:,i+1) = TwohostOnepopESS(alphavalsIJKnpS2(:,:,i),m,thetaIJK,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
    end


%%%%%%%%%fig s.4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma = 0.5;
    m = 35;
    %natural mortality rate, mu(i) = host i
    mu = [0.5, 0.5];
    %recovery rate, gamma(i) = host i
    gamma= [0, 0];
    alphavals000S4 = [0.005, 0.005; 0.005, 0.005];
    alphavalsIS4 = [0.005, 0.005; 0.005, 0.005]; 
    alphavalsJS4 = [0.005, 0.005; 0.005, 0.005];
    alphavalsKS4 = [0.005, 0.005; 0.005, 0.005]; 
    alphavalsIKS4 = [0.005, 0.005; 0.005, 0.005]; 
    alphavalsIJS4 = [0.005, 0.005; 0.005, 0.005]; 
    alphavalsJKS4 = [0.005, 0.005; 0.005, 0.005]; 
    alphavalsIJKS4 = [0.005, 0.005; 0.005, 0.005]; 
    
    for i = 1:Nrho
        i
        lambda = [(mu(1)+mu(2))*rhoval(i), (mu(1)+mu(2))*(1-rhoval(i))];
        alphavals000S4(:,:,i+1) = TwohostOnepopESS(alphavals000S4(:,:,i),m,theta000,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsIS4(:,:,i+1) = TwohostOnepopESS(alphavalsIS4(:,:,i),m,thetaI,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsJS4(:,:,i+1) = TwohostOnepopESS(alphavalsJS4(:,:,i),m,thetaJ,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsKS4(:,:,i+1) = TwohostOnepopESS(alphavalsKS4(:,:,i),m,thetaK,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsIJS4(:,:,i+1) = TwohostOnepopESS(alphavalsIJS4(:,:,i),m,thetaIJ,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsIKS4(:,:,i+1) = TwohostOnepopESS(alphavalsIKS4(:,:,i),m,thetaIK,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsJKS4(:,:,i+1) = TwohostOnepopESS(alphavalsJKS4(:,:,i),m,thetaJK,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsIJKS4(:,:,i+1) = TwohostOnepopESS(alphavalsIJKS4(:,:,i),m,thetaIJK,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
     
    end
    
    figure
    subplot(2,4,1)
    scatter(rhoval, alphavals000S4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavals000S4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavals000npS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    ylabel('ES virulence, \alpha_{j,k}')
    title('\beta_{\bullet\leftarrow(\bullet,\bullet)}')
    box on
    lgd = legend;
    lgd.Location = 'northwest';
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,2)
    scatter(rhoval, alphavalsIS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsIS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsInpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    title('\beta_{i\leftarrow(\bullet,\bullet)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,3)
    scatter(rhoval, alphavalsJS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsJS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsJnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    xlabel('population sex ratio, \rho')
    title('\beta_{\bullet\leftarrow(j,\bullet)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,4)
    scatter(rhoval, alphavalsKS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsKS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsKnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    title('\beta_{\bullet\leftarrow(\bullet,k)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,5)
    scatter(rhoval, alphavalsIJS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsIJS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsIJnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    ylabel('ES virulence, \alpha_{j,k}')
    title('\beta_{i\leftarrow(j,\bullet)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,6)
    scatter(rhoval, alphavalsIKS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsIKS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsIKnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    xlabel('population sex ratio, \rho')
    title('\beta_{i\leftarrow(\bullet,k)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,7)
    scatter(rhoval, alphavalsJKS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsJKS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsJKnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    title('\beta_{\bullet\leftarrow(j,k)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
    subplot(2,4,8)
    scatter(rhoval, alphavalsIJKS4(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsIJKS4(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsIJKnpS2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    title('\beta_{i\leftarrow (j,k)}')
    box on
    ylim([0.7, 1.4])
    yticks([0.7, 0.9, 1.1, 1.3])
    xticks([0, 0.5, 1])
    
% %%%%%%%%%fig s.5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma = 0.5;
    m = 35;
    Nrho = 20;
    rhoval = linspace(0.05, 0.95, Nrho);

    %natural mortality, mu_1, mu_2
    mu = [0.5,0.5];
    %recovery rate, gamma(i) = host i
    gamma = [0, 0];
    c = ones(2,2,2);
    %initial values for virulence
    alphavals0S5 = [0.005, 0.005; 0.005, 0.005];
    alphavals0npS5 = [0.005, 0.005; 0.005, 0.005];
    alphavals1S5 = [0.005, 0.005; 0.005, 0.005];
    alphavals1npS5 = [0.005, 0.005; 0.005, 0.005];
    for i = 1:Nrho
        i
        rhoA = 0.5 - rhoval(i)*0.5;
        rhoB = 0.5 + rhoval(i)*0.5;
        lambda =  [(mu(1)+mu(2))*rhoA, (mu(1)+mu(2))*(1 - rhoA), (mu(1) + mu(2))*rhoB, (mu(1)+mu(2))*(1-rhoB)];
        alphavals0S5(:,:,i+1) = TwohostTwopopESS(alphavals0S5(:,:,i),m, thetaI, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 3);
        alphavals0npS5(:,:,i+1) = TwohostTwopopESS(alphavals0npS5(:,:,i),m, thetaI, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 4);

        alphavals1S5(:,:,i+1) = TwohostTwopopESS(alphavals1S5(:,:,i),m, thetaJ, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 3);
        alphavals1npS5(:,:,i+1) = TwohostTwopopESS(alphavals1npS5(:,:,i),m, thetaJ, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 4);

    end
    
    figure
    subplot(1,2,1)
    scatter(rhoval, alphavals0S5(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavals0S5(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavals0npS5(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    %xlabel('difference between subpopulations, \rho_B - \rho_A')
    ylabel('ES virulence, \alpha_{j,k}')
    title('\theta_{1\leftarrow(\bullet,\bullet)} < \theta_{2\leftarrow(\bullet,\bullet)}')
    lgd = legend;
    lgd.Location = 'northwest';
    ylim([0.85, 1.0])
    yticks([0.85, 0.9, 0.95, 1])
    xlim([0, 1])
    xticks([0, 0.5, 1])
    box on
    subplot(1,2,2)
    scatter(rhoval, alphavals1S5(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavals1S5(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavals1npS5(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    xlabel('difference between subpopulations, 1 - 2\rho')
    title('\theta_{\bullet\leftarrow(1,\bullet)} < \theta_{\bullet\leftarrow(2,\bullet)}')
    box on
    ylim([0.8, 0.9])
    yticks([0.8, 0.85, 0.9])
    xlim([0, 1])
    xticks([0, 0.5, 1])
    box on

%%%%%%%% fig S.6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    m = 35;
    mu = [0.5, 0.5];
    gamma = [0, 0];
    thetaIJa1(1,1,1) = 1; thetaIJa1(1,1,2) = 1;
    thetaIJa1(1,2,1) = 3; thetaIJa1(1,2,2) = 3;
    thetaIJa1(2,1,1) = 3; thetaIJa1(2,1,2) = 3;
    thetaIJa1(2,2,1) = 1; thetaIJa1(2,2,2) = 1;
    
    thetaIJa2(1,1,1) = 3; thetaIJa2(1,1,2) = 3;
    thetaIJa2(1,2,1) = 1; thetaIJa2(1,2,2) = 1;
    thetaIJa2(2,1,1) = 1; thetaIJa2(2,1,2) = 1;
    thetaIJa2(2,2,1) = 3; thetaIJa2(2,2,2) = 3;
    
    thetaIJb1(1,1,1) = 1; thetaIJb1(1,1,2) = 1;
    thetaIJb1(1,2,1) = 9; thetaIJb1(1,2,2) = 9;
    thetaIJb1(2,1,1) = 9; thetaIJb1(2,1,2) = 9;
    thetaIJb1(2,2,1) = 1; thetaIJb1(2,2,2) = 1;
    
    thetaIJb2(1,1,1) = 9; thetaIJb2(1,1,2) = 9;
    thetaIJb2(1,2,1) = 1; thetaIJb2(1,2,2) = 1;
    thetaIJb2(2,1,1) = 1; thetaIJb2(2,1,2) = 1;
    thetaIJb2(2,2,1) = 9; thetaIJb2(2,2,2) = 9;
    
    alphavalsS6A1 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6npA1 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6A2 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6npA2 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6B1 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6npB1 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6B2 = [0.05, 0.05; 0.05, 0.05];
    alphavalsS6npB2 = [0.05, 0.05; 0.05, 0.05];
    for i = 1:Nrho
        i
        lambda = [rhoval(i), (1 - rhoval(i))]*(mu(1)+mu(2));
        alphavalsS6A1(:,:,i+1) = TwohostOnepopESS(alphavalsS6A1(:,:,i),m,thetaIJa1,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsS6npA1(:,:,i+1) = TwohostOnepopESS(alphavalsS6npA1(:,:,i),m,thetaIJa1,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        alphavalsS6A2(:,:,i+1) = TwohostOnepopESS(alphavalsS6A2(:,:,i),m,thetaIJa2,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsS6npA2(:,:,i+1) = TwohostOnepopESS(alphavalsS6npA2(:,:,i),m,thetaIJa2,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        
        alphavalsS6B1(:,:,i+1) = TwohostOnepopESS(alphavalsS6B1(:,:,i),m,thetaIJb1,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsS6npB1(:,:,i+1) = TwohostOnepopESS(alphavalsS6npB1(:,:,i),m,thetaIJb1,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);
        alphavalsS6B2(:,:,i+1) = TwohostOnepopESS(alphavalsS6B2(:,:,i),m,thetaIJb2,gamma,mu,tol0,tol1, B, diffB, CHO, dA, lambda);
        alphavalsS6npB2(:,:,i+1) = TwohostOnepopESS(alphavalsS6npB2(:,:,i),m,thetaIJb2,gamma,mu,tol0,tol1, B, diffB, CFC, dA, lambda);

    end
    figure
    subplot(2,2,1)
    scatter(rhoval, alphavalsS6A1(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsS6A1(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsS6npA1(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    ylabel('ES virulence, \alpha_{j,k}')
    title('\theta_{i\leftarrow(j,\bullet)} = 3, \theta_{i\leftarrow(i,\bullet)} = 1')
    lgd = legend;
    lgd.Location = 'northwest'; 
    xticks([0 0.5 1])
    ylim([0.7, 1])
    yticks([0.7, 0.8, 0.9, 1])
    box on
    subplot(2,2,2)
    scatter(rhoval, alphavalsS6A2(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsS6A2(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsS6npA2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    %ylabel('ESS value of \alpha_{j\leftarrow k}')
    title('\theta_{i\leftarrow(j,\bullet)} = 1, \theta_{i\leftarrow(i,\bullet)} = 3')
    %xlabel('population composition, \rho')
    xticks([0 0.5 1])
    box on
    ylim([0.8, 1.2])
    yticks([0.8, 0.9, 1, 1.1, 1.2])
    
    subplot(2,2,3)
    scatter(rhoval, alphavalsS6B1(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsS6B1(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsS6npB1(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    ylabel('ES virulence, \alpha_{j,k}')
    title('\theta_{i\leftarrow(j,\bullet)} = 9, \theta_{i\leftarrow(i,\bullet)} = 1')
    xlabel('population sex ratio, \rho')
    xticks([0 0.5 1])
    ylim([0.7, 0.9])
    yticks([0.7, 0.75, 0.8, 0.85, 0.9])
    box on
    subplot(2,2,4)
    scatter(rhoval, alphavalsS6B2(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{\bullet,1}')
    hold on
    scatter(rhoval, alphavalsS6B2(2,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{\bullet,2}')
    plot(rhoval, reshape(alphavalsS6npB2(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    %ylabel('ESS value of \alpha_{j\leftarrow k}')
    title('\theta_{i\leftarrow(j,\bullet)} = 1, \theta_{i\leftarrow(i,\bullet)} = 9')
    xlabel('population sex ratio, \rho')
    xticks([0 0.5 1])
    ylim([0.7, 1.6])
    yticks([0.7, 0.9, 1.1, 1.3, 1.5])
    box on


%%%%%%%%%% fig S.8%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma = 0.5;
    m = 35;
    Nrho = 20;
    rhoval = linspace(0.05, 0.95, Nrho);

    %natural mortality, mu_1, mu_2
    mu = [0.5,0.5];
    %recovery rate, gamma(i) = host i
    gamma = [0, 0];
    c = ones(2,2,2);
    %initial values for virulence
    alphavals0S8 = [0.005, 0.005; 0.005, 0.005];
    alphavals0npS8 = [0.005, 0.005; 0.005, 0.005];
    for i = 1:Nrho
        i
        rhoA = 0.5 - rhoval(i)*0.5;
        rhoB = 0.5 + rhoval(i)*0.5;
        lambda =  [(mu(1)+mu(2))*rhoA, (mu(1)+mu(2))*(1 - rhoA), (mu(1) + mu(2))*rhoB, (mu(1)+mu(2))*(1-rhoB)];
        alphavals0S8(:,:,i+1) = TwohostTwopopESS(alphavals0S8(:,:,i),m, thetaI, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 1);
        alphavals0npS8(:,:,i+1) = TwohostTwopopESS(alphavals0npS8(:,:,i),m, thetaI, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 4);
    end
    
    figure
    scatter(rhoval, alphavals0S8(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{1,1}')
    hold on
    scatter(rhoval, alphavals0S8(1,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{1,2}')
    scatter(rhoval, alphavals0S8(2,1,2:(Nrho+1)), 'g', 'DisplayName', '\alpha_{2,1}')
    scatter(rhoval, alphavals0S8(2,2,2:(Nrho+1)), 'm', 'DisplayName', '\alpha_{2,2}')
    plot(rhoval, reshape(alphavals0npS8(2,2,2:(Nrho+1)),Nrho,1), 'k-.', 'DisplayName', '\alpha_{\bullet,\bullet}')
    box on
    xlabel('difference between subpopulations, 1-2\rho')
    ylabel('ES virulence, \alpha_{j,k}')
    lgd = legend;
    lgd.Location = 'northwest'; 
    xticks([0 0.5 1])
    yticks([0.8, 0.85, 0.9, 0.95, 1, 1.05])
    ylim([0.8 1.05])
    
%%%%%%fig s.9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mu = [0.5, 0.5];
    gamma = [0, 0];
    c = ones(2,2,2);
     %\beta_{12*} = \beta_{21*} > \beta_{11*} = \beta_{22*}
    thetaIJA(1,1,1) = 3; thetaIJA(1,1,2) = 3;
    thetaIJA(1,2,1) = 1; thetaIJA(1,2,2) = 1;
    thetaIJA(2,1,1) = 1; thetaIJA(2,1,2) = 1;
    thetaIJA(2,2,1) = 3; thetaIJA(2,2,2) = 3;

    
    %\beta_{11*} = \beta_{22*} > \beta_{12*} = \beta_{21*}
    thetaIJB(1,1,1) = 1; thetaIJB(1,1,2) = 1;
    thetaIJB(1,2,1) = 3; thetaIJB(1,2,2) = 3;
    thetaIJB(2,1,1) = 3; thetaIJB(2,1,2) = 3;
    thetaIJB(2,2,1) = 1; thetaIJB(2,2,2) = 1;    
    
    
    alphavals0S9a1 = [0.005, 0.005; 0.005, 0.005];
    alphavals0S9b1 = [0.005, 0.005; 0.005, 0.005];
    alphavals0S9a3 = [0.005, 0.005; 0.005, 0.005];
    alphavals0S9b3 = [0.005, 0.005; 0.005, 0.005];
    Nrho = 25;
    sigmavals = linspace(0.05,1,Nrho);
    for i = 1:Nrho
        i
        sigma = sigmavals(i);
        rhoA = 0.25; rhoB = 0.75;
        lambda =  [(mu(1)+mu(2))*rhoA, (mu(1)+mu(2))*(1 - rhoA), (mu(1) + mu(2))*rhoB, (mu(1)+mu(2))*(1-rhoB)];
        alphavals0S9a1(:,:,i+1) = TwohostTwopopESS(alphavals0S9a1(:,:,i),m, thetaIJA, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 1);
        alphavals0S9b1(:,:,i+1) = TwohostTwopopESS(alphavals0S9b1(:,:,i),m, thetaIJB, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 1);   
        rhoA = 0.05; rhoB = 0.95;
        lambda =  [(mu(1)+mu(2))*rhoA, (mu(1)+mu(2))*(1 - rhoA), (mu(1) + mu(2))*rhoB, (mu(1)+mu(2))*(1-rhoB)];
        alphavals0S9a3(:,:,i+1) = TwohostTwopopESS(alphavals0S9a3(:,:,i),m, thetaIJA, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 1);
        alphavals0S9b3(:,:,i+1) = TwohostTwopopESS(alphavals0S9b3(:,:,i),m, thetaIJB, gamma, mu, tol0, tol1, B, diffB, dA, lambda, sigma, c, 1);   
        
    end

  figure
  subplot(2,2,1)
   scatter(sigmavals, alphavals0S9a1(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{1,1}')
    hold on
    scatter(sigmavals, alphavals0S9a1(1,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{1,2}')
    plot(sigmavals, reshape(alphavals0S9a1(2,1,2:(Nrho+1)),Nrho,1), '-.g', 'DisplayName', '\alpha_{2,1}')
    plot(sigmavals, reshape(alphavals0S9a1(2,2,2:(Nrho+1)),Nrho,1), '-.m', 'DisplayName', '\alpha_{2,2}')
  %  plot([0.5*(sigmavals(8)+sigmavals(9)),0.5*(sigmavals(8)+sigmavals(9))], [0.7, 1.1], ':k', 'HandleVisibility','off')
    box on
    ylabel('ES virulence, \alpha_{j,k}')
    lgd = legend;
    lgd.Location = 'northeast'; 
    xticks([0 0.5 1, 1.5, 2])
    yticks([0.8, 0.9, 1.0, 1.1])
    ylim([0.8, 1.1])
    title('\theta_{1\leftarrow(2,\bullet)} = \theta_{2\leftarrow(1,\bullet)} < \theta_{1\leftarrow(1,\bullet)} = \theta_{2\leftarrow(2,\bullet)}')
    
    
  subplot(2,2,2)
    scatter(sigmavals, alphavals0S9b1(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{1,1}')
    hold on
    scatter(sigmavals, alphavals0S9b1(1,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{1,2}')
    plot(sigmavals, reshape(alphavals0S9b1(2,1,2:(Nrho+1)),Nrho,1), '-.g', 'DisplayName', '\alpha_{2,1}')
    plot(sigmavals, reshape(alphavals0S9b1(2,2,2:(Nrho+1)),Nrho,1), '-.m', 'DisplayName', '\alpha_{2,2}')
   % plot([0.5*(sigmavals(8)+sigmavals(9)),0.5*(sigmavals(8)+sigmavals(9))], [0.7, 1.1], ':k', 'HandleVisibility','off')
    box on 
    xticks([0 0.5 1, 1.5, 2])
    yticks([0.7, 0.75, 0.8, 0.85, 0.9])
    ylim([0.7, 0.9])
    title('\theta_{1\leftarrow(2,\bullet)} = \theta_{2\leftarrow(1,\bullet)} > \theta_{1\leftarrow(1,\bullet)} = \theta_{2\leftarrow(2,\bullet)}')
    
  subplot(2,2,3)
    scatter(sigmavals, alphavals0S9a3(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{1,1}')
    hold on
    scatter(sigmavals, alphavals0S9a3(1,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{1,2}')
    plot(sigmavals, reshape(alphavals0S9a3(2,1,2:(Nrho+1)),Nrho,1), '-.g', 'DisplayName', '\alpha_{2,1}')
    plot(sigmavals, reshape(alphavals0S9a3(2,2,2:(Nrho+1)),Nrho,1), '-.m', 'DisplayName', '\alpha_{2,2}')
   % plot([0.5*(sigmavals(8)+sigmavals(9)),0.5*(sigmavals(8)+sigmavals(9))], [0.7, 1.1], ':k', 'HandleVisibility','off')
    box on
    xlabel('dispersal between subpopulations, \sigma')
    ylabel('ES virulence, \alpha_{j,k}')
    xticks([0 0.5 1, 1.5, 2])
    yticks([0.8, 0.9, 1.0, 1.1])
    ylim([0.8, 1.1])
  subplot(2,2,4)
    scatter(sigmavals, alphavals0S9b3(1,1,2:(Nrho+1)), 'r', 'DisplayName', '\alpha_{1,1}')
    hold on
    scatter(sigmavals, alphavals0S9b3(1,2,2:(Nrho+1)), 'b', 'DisplayName', '\alpha_{1,2}')
    plot(sigmavals, reshape(alphavals0S9b3(2,1,2:(Nrho+1)),Nrho,1), '-.g', 'DisplayName', '\alpha_{2,1}')
    plot(sigmavals, reshape(alphavals0S9b3(2,2,2:(Nrho+1)),Nrho,1), '-.m', 'DisplayName', '\alpha_{2,2}')
  %  plot([sigmavals(8),sigmavals(8)], [0.7, 1.1], ':k', 'HandleVisibility','off')
    box on
    xlabel('dispersal between subpopulations, \sigma')
    xticks([0 0.5 1, 1.5, 2])
    yticks([0.7, 0.75, 0.8, 0.85, 0.9])
    ylim([0.7, 0.9])

    toc