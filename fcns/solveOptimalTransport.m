function [X_K, X_buffer, mass_buffer, K, tau] = ...
    solveOptimalTransport(Qx,Qy,Qxy,X0,NN,mu_star,K,tau,eps,lF,tol)

% setup
N = size(X0,1);
n_iter = K*(1/tau);
mass_buffer = zeros(N,n_iter+1);
X_buffer = zeros(n_iter+1,N,2);


phi = zeros(N,1); % init phi

Xk = X0;

[start_time, percent_complete] = initProgressBar('Solving transport');

for k = 1:(n_iter) % in parallel
    X_buffer(k,:,:) = Xk;
    
    % determine neighbor positions
    neighbors = knnsearch(Xk,Xk,'K',NN);
    A = zeros(N,N);
    for i = 1:N
        Ni = neighbors(i,2:NN);
        for j = 1:length(Ni)
            A(i,Ni(j)) = costfcn(Xk(i,:), ...
                Xk(Ni(j),:), Qx, Qy, Qxy);
        end
    end
    
    % get Voronoi cells and masses
    agent_neighbor_ids = knnsearch(Xk, mu_star.sample_pts);
    for pt = 1:size(mu_star.sample_pts,1)
        sample_pt_mass = mu_star.sample_pts_pdf(pt);
        sample_pt_NN = agent_neighbor_ids(pt);
            
        mass_buffer(sample_pt_NN,k) = ...
            mass_buffer(sample_pt_NN,k) + sample_pt_mass;
    end
    
    
    % check for convergence
    [converged, K] = checkConvergence(mass_buffer, k, n_iter, tol);
    if converged
        break
    end
    
    
    % primal-dual update
    L = diag(sparse(sum(0.5*(A+A'),2))) - 0.5*(A+A');
    Dhalf = diag(sparse(1./sqrt(sparse(sum(0.5*(A+A'),2)))));
    L = Dhalf*(L*Dhalf);
    for l = 1:lF 
        phi = phi - (1/(NN+1))*L*phi + ...
            (1/N)*ones(N,1) - mass_buffer(:,k);
    end
    
    
    
    for i = 1:N % synchronous
        
        % local estimate of Phi
        Ni = neighbors(i,2:NN);
        Phi = scatteredInterpolant(Xk(Ni,1), Xk(Ni,2), phi(Ni,1), 'linear');

        % transport step
        Xk(i,:) = solveTransportStep(Phi, ...
            Xk(i,:),eps, Qx, Qy, Qxy);
    end
    
 
    percent_complete = updateProgressBar(start_time, ...
        0.01, percent_complete, k, n_iter);
    
end

X_K = squeeze(X_buffer(K,:,:));
X_buffer = X_buffer(1:K,:,:);
mass_buffer = mass_buffer(:,1:K);

end