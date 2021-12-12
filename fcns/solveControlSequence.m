function U = solveControlSequence(x,y,A,B,Tf)

[n,m] = size(B);

Omega = getOmega(A, Tf, 'lti');
Psi = getPsi(A, B, Tf, 'lti');
[~,~,S] = getS(A, B, Tf, 'lti');

Ione = kron(ones(Tf,1),eye(n));

PhiTf1 = getStateTransition(A,Tf+1,1);

cvx_begin quiet

    variables Z(n*(Tf+1),1) U(m*Tf,1) V1((Tf-n)*m,1) V2(n*m,1)
    expression J2
    J2 = (Z)'*(Z) + U'*U;
    
    minimize J2
    subject to
    
    Z(1:n*Tf,:) == Omega*x + Psi*U - Ione*y;
    Z(n*Tf+1,:) == zeros(3,1);

    U == [V1 ; V2];
    
    y - PhiTf1*x == S*U;

cvx_end


end