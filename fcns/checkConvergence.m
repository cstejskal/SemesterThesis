function [converged, K] = checkConvergence(mass, k, n_iter, tol)

converged = 0;
K = n_iter;

normed_mass = mass(:,k)*size(mass,1);

% var(normed_mass)
if var(normed_mass) < tol
    disp('Solution converged')
    converged = 1;
    K = k;
end

end