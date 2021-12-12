% clc, close all % get rid of this

switch example
    case 'Example1'
        % start and end positions, mass convergence
        f1a = figure;
        f1a.Position = [100 500 700 300];
        sp(1) = subplot(1,2,1); hold on
        surf(Omega.X_mat,Omega.Y_mat,-Omega.Z);
        colormap(gray);
        shading interp;
        view(2);
        N = size(X0,1);
        for i = 1:N
            plot([X0(i,1),Xtf(i,1)],[X0(i,2),Xtf(i,2)],'Color',[0, 0.4470, 0.7410])
        end
        scatter(X0(:,1),X0(:,2),'filled','g')
        scatter(Xtf(:,1),Xtf(:,2),'filled','r')
        axis([-5.2 10.1 -5.2 10.1])
        xlabel('x')
        ylabel('y')
        ax = gca;
        ax.Layer = 'top';
        box on
        sp(2) = subplot(1,2,2);
        plot(0:length(var(mass_buffer))-1,var(mass_buffer*size(X0,1)), ...
            'k','LineWidth',1.5)
        xlabel('k')
        ylabel('Var($\mu^*(\mathcal{V}_i) \cdot N$)','Interpreter','latex')
        yticks([0:3:18])
        axis([0 20 0 18])
        hold off
        print(f1a,'-dpng','-r300','results/Example1_convergence.png')
        
        % comparison of target and actual final distribution
        [f,xi] = ksdensity(Xtf);
        f1b = figure;
        f1b.Position = [100 100 700 300];
        sp(1) = subplot(1,2,1); hold on
        surf(Omega.X_mat,Omega.Y_mat,Omega.Z), hold on
        view(2)
        shading interp
        xlabel('x')
        ylabel('y')
        axis([-5.2 10.1 -5.2 10.1])
        ax = gca;
        ax.Layer = 'top';
        box on
        sp(2) = subplot(1,2,2); hold on
        ksdensity(Xtf,xi)
        shading interp
        xlabel('x')
        ylabel('y')
        axis([-5.2 10.1 -5.2 10.1])
        ax = gca;
        ax.Layer = 'top';
        box on
        colormap(sp(1),flip(gray))
        colormap(sp(2),flip(gray))
        print(f1b,'-dpng','-r300','results/Example1_mustar_vs_muhat.png')
        
        W = getWassersteinDistance(Xtf,random(gm,1e5));
        fprintf('Wasserstein-1 distance: %0.3f\n',W)
        
    
    case 'Example2'
        % initial and target distribution
        Z1 = zeros(size(Omega.X_mat)); Z2 = Z1;
        for i=1:size(Omega.X_mat,1)
            for j=1:size(Omega.X_mat,2)
                Z1(i,j) = pdf(gm{4}, [Omega.X_mat(i,j), Omega.Y_mat(i,j)]);
                Z2(i,j) = pdf(gm{5}, [Omega.X_mat(i,j), Omega.Y_mat(i,j)]);
            end
        end
        Z = (Z1 + Z2) ./ sum(sum(Z1 + Z2));
        f2 = figure; hold on
        f2.Position = [100 600 700 300];
        sp(1) = subplot(1,2,1); hold on
        surf(Omega.X_mat,Omega.Y_mat,Z), hold on
        view(2)
        shading interp
        xlabel('x')
        ylabel('y')
        axis([-10 10 -10 10])
        ax = gca;
        ax.Layer = 'top';
        box on
        sp(2) = subplot(1,2,2); hold on
        surf(Omega.X_mat,Omega.Y_mat,Omega.Z), hold on
        view(2)
        shading interp
        xlabel('x')
        ylabel('y')
        axis([-10 10 -10 10])
        ax = gca;
        ax.Layer = 'top';
        box on
        colormap(sp(1),flip(gray))
        colormap(sp(2),flip(gray))
        print(f2,'-dpng','-r300','results/Example2_mu0_and_mustar.png')
        
        % histogram of positions at certain times
        f2a = figure; hold on
        f2a.Position = [100 50 700 450];
        num = 1;
        for i = [1 3 5 7 9 11]
            Xi = squeeze(X_buffer(i,:,:));
            [f,xi] = ksdensity(Xi);
            subplot(2,3,num)
            ksdensity(Xi,xi)
            shading interp
            colormap('hot')
            xlabel('x'); ylabel('y');
            set(gca,'Color','k')
            axis([floor(min(Xi(:,1)))-1 ceil(max(Xi(:,1)))+1 ...
                floor(min(Xi(:,2)))-1 ceil(max(Xi(:,2)))+1])
            view(2)
            num = num + 1;
        end
        print(f2a,'-dpng','-r300','results/Example2_control.png')
        
        % clustering
        idx = kmeans(Xtf,3);
        c1_0 = []; c2_0 = []; c3_0 = [];
        c1_tf = []; c2_tf = []; c3_tf = [];
        for i = 1:size(X0,1)
            cluster = idx(i);
            switch cluster
                case 1
                    c1_0 = [c1_0; X0(i,1),X0(i,2)];
                    c1_tf = [c1_tf; Xtf(i,1),Xtf(i,2)];
                case 2
                    c2_0 = [c2_0; X0(i,1),X0(i,2)];
                    c2_tf = [c2_tf; Xtf(i,1),Xtf(i,2)];
                case 3
                    c3_0 = [c3_0; X0(i,1),X0(i,2)];
                    c3_tf = [c3_tf; Xtf(i,1),Xtf(i,2)];
            end
        end
        f2b = figure;
        f2b.Position = [850 50 900 300];
        subplot(1,3,1), hold on
        surf(Omega.X_mat,Omega.Y_mat,-Omega.Z)
        colormap(gray)
        shading interp
        view(2);
        scatter(c1_0(:,1),c1_0(:,2),5,'filled','m')
        scatter(c2_0(:,1),c2_0(:,2),5,'filled','m')
        scatter(c3_0(:,1),c3_0(:,2),5,'filled','m')
        axis equal
        axis([-10.1 10.1 -10.1 10.1])
        xlabel('x')
        ylabel('y')
        box on
        subplot(1,3,2), hold on
        surf(Omega.X_mat,Omega.Y_mat,-Omega.Z);
        colormap(gray);
        shading interp;
        view(2);
        scatter(c1_0(:,1),c1_0(:,2),5,'filled','g')
        scatter(c2_0(:,1),c2_0(:,2),5,'filled','r')
        scatter(c3_0(:,1),c3_0(:,2),5,'filled','b')
        axis equal
        axis([-10.1 10.1 -10.1 10.1])
        xlabel('x')
        ylabel('y')
        box on
        subplot(1,3,3), hold on
        surf(Omega.X_mat,Omega.Y_mat,-Omega.Z);
        colormap(gray);
        shading interp;
        view(2);
        scatter(c1_tf(:,1),c1_tf(:,2),5,'filled','g')
        scatter(c2_tf(:,1),c2_tf(:,2),5,'filled','r')
        scatter(c3_tf(:,1),c3_tf(:,2),5,'filled','b')
        axis equal
        axis([-10.1 10.1 -10.1 10.1])
        xlabel('x')
        ylabel('y')
        box on
        hold off
        print(f2b,'-dpng','-r300','results/Example2_clustering.png')
        
        W = getWassersteinDistance(Xtf,[random(gm{1},round(1e5/3)); ...
            random(gm{2},round(1e5/3)); random(gm{3},round(1e5/3))]);
        fprintf('Wasserstein-1 distance: %0.3f\n',W)
        
        
    case 'Example3'
        
        f3 = figure; hold on
        f3.Position = [100 100 450 450];
        
        % target distribution
        sp(1) = subplot(2,2,1); hold on
        surf(Omega.X_mat,Omega.Y_mat,Omega.Z)
        colormap(gray)
        shading interp
        view(2)
        xlabel('x'); ylabel('y')
        axis equal
        axis([-10 10 -10 10])
        
        % final distribution
        x_space = -10:0.5:10;
        y_space = -10:0.5:10;
        sp(2) = subplot(2,2,2); hold on
        [n_out, C] = hist3(Xtf,[length(x_space), length(y_space)]);
        [XIN, YIN] = meshgrid(C{1}, C{2});
        hold on
        pcolor(XIN,YIN,n_out'); shading interp
        colormap('hot')
        xlabel('x'); ylabel('y')
        axis equal
        axis([-10 10 -10 10])
        set(gca,'Color','k')
        set(gcf,'Color','w')
        set(gcf, 'InvertHardcopy', 'off')
        
        % final positions
        subplot(2,2,3), hold on
        scatter(Xtf(:,1),Xtf(:,2),5,'filled')
        xlabel('x'); ylabel('y')
        axis equal
        box on
        axis([-10 10 -10 10])
        
        % convergence of mass variance
        subplot(2,2,4)
        plot(var(mass_buffer*size(X0,1)))
        xlabel('k')
        ylabel('Var($\mu^*(\mathcal{V}_i) \cdot N$)','Interpreter','latex')
        hot = hot;
        colormap(sp(1),hot(1:100,:))
        colormap(sp(2),hot)
        picture = imcomplement(rgb2gray(im2double(imread('ETH.jpg'))));
        picture = flipud(imresize(picture,size(Omega.X_mat)));
        grid_array = [Omega.X_mat(:) Omega.Y_mat(:)];
        sample_pts = grid_array(find(picture),:);
        
        print(f3,'-dpng','-r300','results/Example3.png')
        
        W = getWassersteinDistance(Xtf,sample_pts);
        fprintf('Wasserstein-1 distance: %0.3f\n',W)
        
    case 'Example4'
        % W vs graph connectivity
        f4 = figure;
        f4.Position = [100 100 400 300];
        plot(eig2avg,Wavg,'k','LineWidth',1.5)
        xlim([0 ceil(eig2avg(end))+0.5])
        xlabel('Graph algebraic connectivity, \lambda_2')
        ylabel('$W_1\big(\hat{\mu}_N(t_f),\mu^*\big)$','Interpreter','latex')
        figname = sprintf('results/Example4_Wveta_%0.0f.png',N);
        print(f4,'-dpng','-r300',figname)
        
    case 'Example5'
        % W vs Q,R
        f5 = figure; 
        f5.Position = [100 100 400 300];
        semilogx(QRvals,W','k','LineWidth',1.5)
        set(gca,'xdir','reverse')
        xlabel('Q, R')
        ylabel('$W_1\big(\hat{\mu}_N(t_f),\mu^*\big)$','Interpreter','latex')
        print(f5,'-dpng','-r300','results/Example5_WvQR.png')
        
    otherwise
        % start and end positions
        figure, hold on
        surf(Omega.X_mat,Omega.Y_mat,-Omega.Z);
        colormap(gray);
        shading interp;
        view(2);
        N = size(X0,1);
        for i = 1:N
            plot([X0(i,1),Xtf(i,1)],[X0(i,2),Xtf(i,2)],'Color',[0, 0.4470, 0.7410])
        end
        scatter(X0(:,1),X0(:,2),'filled','g')
        scatter(Xtf(:,1),Xtf(:,2),'filled','r')
        xlabel('x')
        ylabel('y')
        ax = gca;
        ax.Layer = 'top';
        box on
        hold off
        
        % mass variance convergence
        figure, hold on
        plot(0:length(var(mass_buffer))-1,var(mass_buffer*size(X0,1)), ...
            'k','LineWidth',1.5)
        xlabel('k')
        ylabel('Var($\mu^*(\mathcal{V}_i) \cdot N$)','Interpreter','latex')
        hold off
end