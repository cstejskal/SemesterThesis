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

function [MU0, MU1] = get2DdistExample(x_space, y_space, gauss)
%This outputs Mu0, Mu1 for the CDC paper example. This synchronizes the
%pdfs used between the control example script, and the script computing the
%optimal map.

%% eth logo

if gauss==false

    [X,Y] = meshgrid(x_space, y_space);

    eth_3 = imread('eth_35_35.png');

    [nx,ny,~]=size(eth_3);

    assert(length(x_space) == nx);
    assert(length(y_space) == ny);

    backgn = 1;% background density shouldn't be zero)

    MU1 = 255- flipud(double(eth_3(:,:,1)));

    for ii =1:length(x_space)
        for jj  = 1:length(y_space)
            if MU1(ii,jj) == 0
                MU1(ii,jj) = backgn;
            end
        end
    end

    MU0 = ones(size(MU1));
    MU0 = MU0/sum(sum(MU0));
    MU1 = MU1/sum(sum(MU1));

end

%% nice sum-of-gaussians example
if gauss == true
    [X,Y] = meshgrid(x_space, y_space);
    Xtot = [X(:) Y(:)];

    mean0 = [-0.45,-0.65];
    sig0 = diag([0.01, 0.02]);
    mean01 = [-0.15, 0];
    sig01 = diag([0.02, 0.075]);
    mean1 = [0.5,0.5];
    sig1 = diag([0.05, 0.05]);
    mean11 = [0.65,-0.65];
    sig11 = diag([0.075,0.02]);

    MU0 = reshape(mvnpdf(Xtot,mean0,sig0)+mvnpdf(Xtot,mean01,sig01),length(y_space),length(x_space));
    % MU0 = reshape(mvnpdf(Xtot,mean0,sig0),length(y_space),length(x_space)); % single gaussian
    MU0 = MU0/sum(sum(MU0));
    % MU1 = reshape(mvnpdf(Xtot,mean1,sig1),length(y_space),length(x_space)); % single gaussian
    MU1 = reshape(mvnpdf(Xtot,mean1,sig1)+mvnpdf(Xtot,mean11,sig11),length(y_space),length(x_space));
    MU1 = MU1/sum(sum(MU1));
end

end

