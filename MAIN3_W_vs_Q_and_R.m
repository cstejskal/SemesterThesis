clear, clc, close all
addpath(genpath('./fcns'))
addpath(genpath('./fcns/LQR_OT_fcns'))
addpath(genpath('./pics'))
addpath(genpath('./setup_files'))
warning('off','all');


%% System setup

example = 'Example5';
[A,B,~,~,tf,X0,eta,mu_star,gm,K,tau,eps,lF,Omega,tol] = initExample(example);


%% Sweep over values

QRvals = 1./(10.^(1:0.1:3));
W = zeros(size(QRvals));
for i = 1:length(QRvals)

    fprintf('Q = R = %0.3e, ',QRvals(i))
    
    [Qx,Qy,Qxy] = getCostMatrices(A,B,QRvals(i),QRvals(i),tf);

    [Xtf, X_buffer_OT, mass_buffer, simtime_iter, tau] = ...
        solveOptimalTransport(Qx,Qy,Qxy,X0,eta,mu_star,K,tau,eps,lF,tol);
    
    W(i) = getWassersteinDistance(Xtf,random(gm,1e5));
    
end


%% Load solution from setup_files

% load('setup_files/Example5.mat')


%% Results

clc
plotResults;








