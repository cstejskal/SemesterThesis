clear, clc, close all
addpath(genpath('./fcns'))
addpath(genpath('./fcns/LQR_OT_fcns'))
addpath(genpath('./pics'))
addpath(genpath('./setup_files'))
warning('off','all');


%% System setup

% SELECT AN EXAMPLE FROM:
% 'Example1' --> Gaussian to Gaussian
% 'Example2' --> Gaussian Mixed to Gaussian Mixed
% 'Example3' --> Uniform to ETH logo

example = 'Example2';

[A,B,Q,R,tf,X0,eta,mu_star,gm,K,tau,eps,lF,Omega,tol] = initExample(example);


%% Solution

[Qx,Qy,Qxy] = getCostMatrices(A,B,Q,R,tf);

[Xtf, X_buffer_OT, mass_buffer, simtime_iter, tau] = ...
    solveOptimalTransport(Qx,Qy,Qxy,X0,eta,mu_star,K,tau,eps,lF,tol);

[U_buffer, X_buffer] = solveOptimalControl(A, B, tf, X0, Xtf);


%% Load solution from setup_files

load('setup_files/Example2.mat')


%% Plots

clc
plotResults;






