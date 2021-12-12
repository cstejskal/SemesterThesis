clear, clc, close all
addpath(genpath('./fcns'))
addpath(genpath('./fcns/LQR_OT_fcns'))
addpath(genpath('./pics'))
addpath(genpath('./setup_files'))
warning('off','all');

%% System setup

example = 'Example4';
[A,B,Q,R,tf,X0,~,mu_star,gm,K,tau,eps,lF,Omega,tol] = initExample(example);
[Qx,Qy,Qxy] = getCostMatrices(A,B,Q,R,tf);
N = size(X0,1); clear('X0')


%% Sweep over number of neighbors

load('seedbuffer.mat')
num_seeds = length(seedbuffer);

etavals = 4:19;

Wbuffer = zeros([num_seeds,size(etavals,2)]);
eig2buffer = zeros([num_seeds,size(etavals,2)]);

count = 1;
for random_seed = seedbuffer

    fprintf('\nRandom seed #%0.0f\n',count)
    
    rng(random_seed)
    mean_init = [5,5];
    var_init = [3,3];
    gm_init = gmdistribution(mean_init, var_init);
    X0 = random(gm_init,N);
    
    W = zeros(size(etavals));
    eig2 = zeros(size(etavals));
    for i = 1:length(etavals)
        fprintf('eta = %0.0f, ',etavals(i))

        [Xtf, X_buffer_OT, mass_buffer, simtime_iter, tau, eig2i] = ...
            solveOptimalTransport_staticGraph(Qx,Qy,Qxy,X0,etavals(i),mu_star,K,tau,eps,lF,tol);

        W(i) = getWassersteinDistance(Xtf,random(gm,1e5));
        eig2(i) = eig2i;

    end
    
    Wbuffer(count,:) = W;
    eig2buffer(count,:) = eig2;
    count = count+1;

end

Wavg = sum(Wbuffer)/num_seeds;
eig2avg = sum(eig2buffer)/num_seeds;


%% Load solution from setup_files

load('setup_files/Example4_N20.mat')


%% Results

clc
plotResults;




