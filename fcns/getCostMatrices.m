function [Qx,Qy,Qxy] = getCostMatrices(A,B,Q,R,tf)

[nn,mm] = size(B);
t_space = 1:tf+1;
Qtil = Q*eye(tf*nn);
Rtil = R*eye(tf*mm);

[~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
    K1, K2, K3, K4] = getMatrices(A, B, tf, Qtil, Rtil, 'lti');

Qx  = 2*(K1'*Qtil*K1 + K3'*Rtil*K3);
Qy  = 2*(K2'*Qtil*K2 + K4'*Rtil*K4);
Qxy =  -(K1'*Qtil*K2 + K3'*Rtil*K4);

end