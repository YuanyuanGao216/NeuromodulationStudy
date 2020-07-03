function p = performANOVA(X,Group,title_string,brain_area,h_boxplot)
tRNS_color = [56,182,255]./256;
tDCS_color = [255,145,77]./256;
Sham_color = [85,85,85]./256;

if nanmean(X) < 0.0001
    X = X*1000000;
end

[p,~,stats] = anova1(X,Group,'off');
[c,m,h,nms] = multcompare(stats,'Display','off');
figure(h_boxplot)
subplot(2,4,brain_area);
boxplot(X,Group,'GroupOrder',{'tDCS','tRNS','Sham'},'Color','brk')
hold on
yt = get(gca, 'YTick');
y_limits = ylim;
xt = get(gca, 'XTick');


alpha = 0.05;
post_hoc_p = c(:,6);
flag = 0;
for i = 1:length(post_hoc_p)
    p_value = c(i,6);
    stim1 = string(nms(c(i,1)));
    stim2 = string(nms(c(i,2)));
    if p_value < alpha
        if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
            flag = 1;
        end
    end
end
for i = 1:length(post_hoc_p)
    p_value = c(i,6);
    stim1 = string(nms(c(i,1)));
    stim2 = string(nms(c(i,2)));
%     if p_value < alpha
        if flag == 1
            axis([xlim    y_limits(1)  y_limits(2)+(y_limits(2)-y_limits(1))*0.8])
        else
            axis([xlim    y_limits(1)  y_limits(2)+(y_limits(2)-y_limits(1))*0.6])
        end
        FS = 12;
        if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
            plot(xt([1 3]), [1 1]*(y_limits(2)+(y_limits(2)-y_limits(1))*0.5), '-k')
            text(xt(2)-0.4,...
                y_limits(2)+(y_limits(2)-y_limits(1))*0.6,sprintf('p=%.3f%s',p_value,'*'),'FontSize',FS)
        elseif (strcmp(stim1,'tRNS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tRNS')&& strcmp(stim1,'Sham'))
            plot(xt([2 3]), [1 1]*(y_limits(2)+(y_limits(2)-y_limits(1))*0.3), '-k')
            text((xt(2)+xt(3))/2-0.4,...
                y_limits(2)+(y_limits(2)-y_limits(1))*0.4,sprintf('p=%.3f%s',p_value,'*'),'FontSize',FS)
        elseif (strcmp(stim1,'tDCS')&& strcmp(stim2,'tRNS'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'tRNS'))
            plot(xt([1 2]), [1 1]*(y_limits(2)+(y_limits(2)-y_limits(1))*0.1), '-k')
            text((xt(1)+xt(2))/2-0.4,...
                y_limits(2)+(y_limits(2)-y_limits(1))*0.2,sprintf('p=%.3f%s',p_value,'*'),'FontSize',FS)
        end
%     end
end


hold off
title(title_string)
ylabel('\muMol')
set(gca,'FontSize',14)