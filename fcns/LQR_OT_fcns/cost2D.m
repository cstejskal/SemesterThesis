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
function [C] = cost2D(X0,D,E,F)
%get the quadratic cost in 2D

%X0 contains the points in columnwise order (left to right)

[~,n_var] = size(X0);

C = zeros(n_var,n_var);
f = @(x,y) x'*D*x/2 -x'*E*y + y'*F*y/2;

for ii = 1:n_var
    for jj = 1:n_var
        % compute cost between cols ii, jj of X0 -> C(ii,jj)
        xx = X0(:,ii); 
        yy = X0(:,jj);
        C(ii,jj) = f(xx,yy);
    end
end


end

