% MIT License
% 
% Copyright (c) 2021 Mathias Hudoba de Badyn
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
%     Running this software requires a local Gurobi installation. Academic
%     licenses, at the time of writing, are available at no cost at
%     http://www.gurobi.com

function [Omega, Psi, S1, S2, S, Ione, Ione1, GamEye, ...
    s2row, s2col, GamXY, GamV1, GamY, GamX, AX, AY, AV1, P,...
    H1, H2, H3, H4, K1, K2, K3, K4...
] = getMatrices(A, B, Tf, Qtil, Rtil,sys_type)

% get all the matrices for the LQR OT problem


[n,m,~] = size(B);

Omega = getOmega(A, Tf, sys_type);
Psi = getPsi(A, B, Tf, sys_type);
[S1 S2 S] = getS(A, B, Tf, sys_type);
Ione = kron(ones(Tf,1),eye(n));
Ione1 = kron(ones(Tf+1,1),eye(n,n));

GamEye = eye((Tf-n)*m);
[s2row, s2col] = size(pinv(S2));
GamXY  = zeros((Tf-n)*m, s2col);

GamV1 = [GamEye; -pinv(S2)*S1];
GamY  = [GamXY; pinv(S2)];
PhiTf1 = getStateTransition(A,Tf+1,1);
GamX  = -GamY * PhiTf1;

AX = Omega + Psi*GamX;
AY = Psi*GamY - Ione;
AV1 = Psi*GamV1;

P = AV1'*Qtil*AV1 + GamV1'*Rtil*GamV1;

H1 = eye(Tf*n) - AV1*(P\AV1'*Qtil);
H2 = -AV1*(P\GamV1'*Rtil);
H3 = eye(Tf*m) - GamV1*(P\GamV1'*Rtil);
H4 = -GamV1*(P\AV1'*Qtil);

K1 = H1*AX + H2*GamX;
K2 = H1*AY + H2*GamY;
K3 = H3*GamX + H4*AX;
K4 = H3*GamY + H4*AY;


end

