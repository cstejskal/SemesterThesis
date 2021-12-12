function new_pos = solveTransportStep(PHI,posm,c, Qx, Qy, Qxy)

new_pos = posm;
converged = 0;
tol = 0.001;
iters = 0;
alpha = c/10; % GD step size

while ~converged    
    
    posm_last = new_pos;

    cost_pos = costfcn(posm_last,posm_last,Qx,Qy,Qxy) + PHI(posm_last);
    
    % positions for gradient
    pos_r = [posm_last(1)+0.01      posm_last(2)]; % right
    pos_l = [posm_last(1)-0.01      posm_last(2)]; % left
    pos_u = [posm_last(1)      posm_last(2)+0.01]; % up
    pos_d = [posm_last(1)      posm_last(2)-0.01]; % down
        
    cost_r = costfcn(posm_last,pos_r, Qx, Qy, Qxy) + PHI(pos_r);
    cost_l = costfcn(posm_last,pos_l, Qx, Qy, Qxy) + PHI(pos_l);
    cost_u = costfcn(posm_last,pos_u, Qx, Qy, Qxy) + PHI(pos_u);
    cost_d = costfcn(posm_last,pos_d, Qx, Qy, Qxy) + PHI(pos_d);
    
    % check for NaN in PHI
%     if isnan(PHI(pos_r))
%         cost_r = costfcn(posm_last,pos_r, Qx, Qy, Qxy) + 2*PHI(posm_last) - (PHI(pos_l));
%     end
%     if isnan(PHI(pos_l))
%         cost_l = costfcn(posm_last,pos_l, Qx, Qy, Qxy) + 2*PHI(posm_last) - (PHI(pos_r));
%     end
%     if isnan(PHI(pos_u))
%         cost_u = costfcn(posm_last,pos_u, Qx, Qy, Qxy) + 2*PHI(posm_last) - (PHI(pos_d));
%     end
%     if isnan(PHI(pos_d))
%         cost_d = costfcn(posm_last,pos_d, Qx, Qy, Qxy) + 2*PHI(posm_last) - (PHI(pos_u));
%     end

    cost_x_grad = ((cost_r - cost_pos)/0.01 + ...
        (cost_pos - cost_l)/0.01)/2;
    cost_y_grad = ((cost_u - cost_pos)/0.01 + ...
        (cost_pos - cost_d)/0.01)/2;
    
    new_pos = posm_last - alpha*[cost_x_grad, cost_y_grad];
   
    
    % movement limit
    if norm(new_pos - posm) > c
        new_pos = posm_last;
        converged = 1;
    end
    
    % check for convergence
    new_pos_cost = costfcn(posm,new_pos, Qx, Qy, Qxy)+PHI(new_pos);
    if norm(new_pos - posm_last) <= tol
        converged = 1;
    end
    
    iters = iters + 1;
    if iters > 50
        % transport step is stuck in a cycle
        converged = 1;
    end

end






%% Visualization of cost surface
%{
posm_cost = costfcn(posm,posm,Qx,Qy,Qxy) + PHI(posm);

figure, hold on
xlim_lo = round(posm(1),1)-c-0.25;
xlim_hi = round(posm(1),1)+c+0.25;
ylim_lo = round(posm(2),1)-c-0.25;
ylim_hi = round(posm(2),1)+c+0.25;

[X,Y] = meshgrid(xlim_lo:0.01:xlim_hi,ylim_lo:0.01:ylim_hi);

grid_array = [X(:) Y(:)];
ex_pt = posm;
costsurface = zeros(size(X));
% cost to example point
for i = 1:length(grid_array)
    costsurface(i) = costfcn(ex_pt,grid_array(i,:),Qx,Qy,Qxy) + PHI(grid_array(i,:));
end
surf(X,Y,costsurface);
colorbar
shading interp
title('cost plus PHI')
% view([-1 -1 1])
scatter3(posm(1),posm(2),posm_cost+0.1,'g','filled')
scatter3(new_pos(1),new_pos(2),new_pos_cost+0.1,'r','filled')
hold off

% figure, hold on
% xlim_lo = round(posm(1),1)-c-0.25;
% xlim_hi = round(posm(1),1)+c+0.25;
% ylim_lo = round(posm(2),1)-c-0.25;
% ylim_hi = round(posm(2),1)+c+0.25;
% 
% [X,Y] = meshgrid(-10:0.1:10,-10:0.1:10);
% 
% grid_array = [X(:) Y(:)];
% ex_pt = posm;
% costsurface = zeros(size(X));
% % cost to example point
% for i = 1:length(grid_array)
%     costsurface(i) = costfcn(ex_pt,grid_array(i,:),Qx,Qy,Qxy) + PHI(grid_array(i,:));
% end
% surf(X,Y,costsurface);
% colorbar
% shading interp
% title('cost plus PHI')
% % view([-1 -1 1])
% scatter3(posm(1),posm(2),posm_cost+0.1,'g','filled')
% scatter3(new_pos(1),new_pos(2),new_pos_cost+0.1,'r','filled')
% hold off
%}










end