function [A,B, Q,R, tf, X_0, eta, mu_star, gm, K, tau, eps, lF, Omega, tol ...
    ] = initExample(example)

% Example parameters
switch example
    case 'Example1'
        N = 30;
        eta = 10; % number of neighbors
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'Gaussian';
        target_distr_type = 'Gaussian';
        rng(0821)
        K = 2.2; % number of OT algorithm steps
        tf = 3; % control time horizon
        lF = 20; % number of primal dual iters
        tol = 0.2;
        
    case 'Example2'
        N = 400;
        eta = 50;
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'GMM2';
        target_distr_type = 'GMM3';
        rng(1954)
        K = 6;
        tf = 10;
        lF = 50;
        tol = 0.5;
        
    case 'Example3'
        N = 1000;
        eta = 500;
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'Uniform';
        target_distr_type = 'ETH';
        rng(1609)
        K = 12;
        tf = 2;
        lF = 100;
        tol = 0.54;
        
    case 'Example4'
        N = 20;
        eta = 10;
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'Gaussian';
        target_distr_type = 'Gaussian';
        rng(1511)
        K = 3;
        tf = 3;
        lF = 50;
        tol = 0.01;
        
    case 'Example5'
        N = 20;
        eta = 10;
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'Gaussian';
        target_distr_type = 'Gaussian';
        rng(1)
        K = 3;
        tf = 3;
        lF = 50;
        tol = 0.01;
        
    case 'Custom'
        N = 50;
        eta = 35;
        system_dynamics_type = 'Dynamics';
        agent_init_distr_type = 'Gaussian';
        target_distr_type = 'Gaussian';
        rng(1)
        K = 3;
        tf = 3;
        lF = 50;
        tol = 0.01;
end


% System dynamics
switch system_dynamics_type
    case 'Dynamics'
        A = [0.9 -0.1; -0.1 0.8];
        B = [1; 0.5];
     case 'Identity'
        A = eye(2);
        B = eye(2);
end
tau = 0.1;
eps = 1;
Q = 1e-4; R = Q;


% Initial agent positions
switch agent_init_distr_type
    case 'Random'
        X_0 = 20*rand(N,2)-10;
        
    case 'Gaussian'
        mean_init = [5,5];
        var_init = [3,3];
        
        gm_init = gmdistribution(mean_init, var_init);
        X_0 = random(gm_init,N);
        
    case 'Uniform'
        F = 1:ceil(sqrt(N));
        D = F(rem(N,F)==0);
        D = [D sort(N./D)];
        
        x_len = D(ceil(end/2));
        y_len = N/x_len;
        
        [X_vals,Y_vals] = meshgrid(linspace(-9.5,9.5,x_len), ...
            linspace(-9.9,9.9,y_len));
        X_0 = [X_vals(:) Y_vals(:)];
        
    case 'GMM2'
        mean_init1 = [-2,-2] + rand(1,2)-0.5;
        var_init1 = 1*rand(1,2)+0.5;
        mean_init2 = [4,-4] + rand(1,2)-0.5;
        var_init2 = 2*rand(1,2)+0.5;
        
        gm_init1 = gmdistribution(mean_init1, var_init1);
        gm_init2 = gmdistribution(mean_init2, var_init2);
        X_0 = [random(gm_init1,round(N/2));
                                 random(gm_init2,N-round(N/2))];
end


% Target measure
x_space = -10:0.1:10;
y_space = -10:0.1:10;
[X_mat,Y_mat] = meshgrid(x_space,y_space);
spacesize = size(X_mat);

n_sample_pts = 1e5;
sample_pts = 20*2*rand(n_sample_pts,2)-20;
Z = zeros(spacesize);

switch target_distr_type        
    case 'Gaussian'
        mean_des = rand(1,2);
        var_des = [2 0; 0 2];

        sample_pts_pdf = mvnpdf(sample_pts, mean_des,var_des); 
        sample_pts_pdf = sample_pts_pdf / sum(sample_pts_pdf);

        gm = gmdistribution(mean_des, var_des);
        for i=1:spacesize(1)
            for j=1:spacesize(2)
                Z(i,j) = pdf(gm, [X_mat(i,j), Y_mat(i,j)]);
            end
        end
        
    case 'GMM3'
        mean_des1 = [-2,4] + rand(1,2)-0.5;
        var_des1 = [2 0; 0 2] + [rand()-0.5 0; 0 rand()-0.5];
        mean_des2 = [-3,-6] + rand(1,2)-1;
        var_des2 = [2 0; 0 2] + [rand()-0.5 0; 0 rand()-0.5];
        mean_des3 = [6,0] + rand(1,2)-1;
        var_des3 = [2 0; 0 2] + [rand()-0.5 0; 0 rand()-0.5];
        mean_des = NaN;
        var_des = NaN;

        sample_pts_pdf1 = mvnpdf(sample_pts, mean_des1,var_des1); 
        sample_pts_pdf1 = sample_pts_pdf1 / sum(sample_pts_pdf1);
        sample_pts_pdf2 = mvnpdf(sample_pts, mean_des2,var_des2); 
        sample_pts_pdf2 = sample_pts_pdf2 / sum(sample_pts_pdf2);
        sample_pts_pdf3 = mvnpdf(sample_pts, mean_des3,var_des3); 
        sample_pts_pdf3 = sample_pts_pdf3 / sum(sample_pts_pdf3);
        sample_pts_pdf = sample_pts_pdf1+sample_pts_pdf2+sample_pts_pdf3;
        sample_pts_pdf = sample_pts_pdf / sum(sample_pts_pdf);

        Z1 = zeros(spacesize); Z2 = zeros(spacesize); Z3 = zeros(spacesize);
        gm1 = gmdistribution(mean_des1, var_des1);
        gm2 = gmdistribution(mean_des2, var_des2);
        gm3 = gmdistribution(mean_des3, var_des3);
        for i=1:spacesize(1)
            for j=1:spacesize(2)
                Z1(i,j) = pdf(gm1, [X_mat(i,j), Y_mat(i,j)]);
                Z2(i,j) = pdf(gm2, [X_mat(i,j), Y_mat(i,j)]);
                Z3(i,j) = pdf(gm3, [X_mat(i,j), Y_mat(i,j)]);
            end
        end
        Z = (Z1 + Z2 + Z3) ./ sum(sum(Z1 + Z2 + Z3));
        gm = {gm1 gm2 gm3 gm_init1 gm_init2};
        
    case 'ETH'
        mean_des = NaN;
        var_des = NaN;
        
        picture = imcomplement(rgb2gray(im2double(imread('ETH.jpg'))));
        picture = flipud(imresize(picture,spacesize));
        Z = picture / sum(sum(picture));
        
        grid_array = [X_mat(:) Y_mat(:)];
        sample_pts = grid_array(find(picture),:);
        sample_pts_pdf = Z(find(Z));
        gm = NaN;

end

mu_star.sample_pts = sample_pts;
mu_star.sample_pts_pdf = sample_pts_pdf;
mu_star.mean_des = mean_des;
mu_star.var_des = var_des;

Omega.X_mat = X_mat;
Omega.Y_mat = Y_mat;
Omega.Z = Z;

end