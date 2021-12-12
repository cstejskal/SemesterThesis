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
function V = getControl(Tf,x,y,A,AX,AY,AV1,GamX,GamY,GamV1,P,sys_type)

% helper function for the OT script, gets the optimal control given initial
% state x and terminal state y

if strcmp(sys_type,'lti') == 1

    Nq = AX*x + AY*y;
    Nr = GamX*x + GamY*y;
    V1 = -(P\(AV1'*Nq + GamV1'*Nr));
    V = GamV1*V1 + GamY*(y-A^(Tf)*x);

elseif strcmp(sys_type, 'ltv') == 1

    PhiTf1 = getStateTransition(A,Tf+1,1);
    Nq = AX*x + AY*y;
    Nr = GamX*x + GamY*y;
    V1 = -(P\(AV1'*Nq + GamV1'*Nr));
    V = GamV1*V1 + GamY*(y-PhiTf1*x);
    
else
    
    warning('Invalid system type - only LTI or LTV is legit')
end


end

