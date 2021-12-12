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

function [S1, S2, S] = getS(A,B,Tf,type)


switch type
    case {'LTI', 'lti'}

        [n,m] = size(B);
        S = zeros(n, m*Tf);
        S(:,end-m+1:end) = B;
        
        for ii = Tf:-1:2
            S(:, (ii-2)*m+1:(ii-1)*m) = A*S(:, (ii-1)*m+1:ii*m);
        end
        
        S1 = S(:,1:(Tf-n)*m);
        S2 = S(:,(Tf-n)*m+1:end);

    case {'LTV', 'ltv'}

        [n,m] = size(B(:,:,1));
        S = getUpsilon(A,B,Tf+1);
        
        S1 = S(:,1:(Tf-n)*m);
        S2 = S(:,(Tf-n)*m+1:end);

end
