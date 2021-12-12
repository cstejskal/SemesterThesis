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

function [x,y] = getRand2D(hist,x_space,y_space)
% get a random value from the 1D distribution in hist supported on x_space

% currently, hist must NOT be normalized via integration. it must be
% normalized to sum to 1. This is because I'm too lazy to do a proper
% function here.

hist = hist/sum(sum(hist));

% x_space is rows, y_space is columns.
% get y marginal

hist_y = sum(hist); %summation is done columnwise
hist_y = hist_y/sum(hist_y);

val = rand;
y = y_space(1);

cumvar = 0;

for ii=1:length(y_space)
    y = y_space(ii);
    cumvar=cumvar + hist_y(ii);
    
    if cumvar>val
        break
        
    end
end
x = 0;


% ii is the value of the column we want to sample on

hist_x = hist(:,ii)/sum(hist(:,ii));

% reset cumvar
cumvar = 0;
val = rand;

for ii=1:length(x_space)
    x = x_space(ii);
    cumvar=cumvar + hist_x(ii);
    
    if cumvar>val
        break
    end
end



end