function [U_buffer, X_buffer] = solveOptimalControl(A, B, tf, X_0, X_K)

N = size(X_0,1);

[start_time, percent_complete] = initProgressBar('Solving control');

U_buffer = zeros(tf,N);
X_buffer = zeros(tf+1,N,2);
X_buffer(1,:,:) = X_0;

for agent = 1:N
    x = X_0(agent,:)';
    y = X_K(agent,:)';

    U = solveControlSequence(x,y,A,B,tf);
    
    U_buffer(:,agent) = U;

    % for id dynamics
    if size(B,2) == 2
        idx = 1;
        for u = 1:2:length(U)
            Utemp(idx,:) = [U(u) U(u+1)];
            idx = idx+1;
        end
        U = Utemp;
    end

    xk = x;
    for k = 1:tf        
        xkp1 = A*xk + B*U(k,:)';
        X_buffer(k+1,agent,:) = xkp1;

        xk = xkp1;
    end

    percent_complete = updateProgressBar(start_time, ...
        0.01, percent_complete, agent, N);
end

end