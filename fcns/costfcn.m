function cost = costfcn(x, y, Qx, Qy, Qxy)

cost = x*Qx*x'/2 -x*Qxy*y' + y*Qy*y'/2;

% cost = norm(x-y);

end