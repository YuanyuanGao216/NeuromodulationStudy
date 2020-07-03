function Plot_LC(Data,var)
x_positions = [1:12,14,15,16];
define_colors
line_width = 0.8;
if strcmp(var, 'time')
    Sham_data = Data.Sham_TIME;
    tDCS_data = Data.tDCS_TIME;
    tRNS_data = Data.tRNS_TIME;
elseif strcmp(var, 'error')
    Sham_data = Data.Sham_ERROR;
    tDCS_data = Data.tDCS_ERROR;
    tRNS_data = Data.tRNS_ERROR;
elseif strcmp(var, 'score')
    Sham_data = Data.Sham_SCORE;
    tDCS_data = Data.tDCS_SCORE;
    tRNS_data = Data.tRNS_SCORE;
end


y = [];
stim = [];
day = [];

figure
hold on

% Sham
[mean_sham,std_sham,mean_follow_sham,std_follow_sham] = cal_mean_std(Sham_data);
[y,stim,day] = y_stim_day(Sham_data,y,stim,day,'Sham');

errorbar(x_positions(1:12),mean_sham(1:12),std_sham(1:12),'color',Sham_color,'LineWidth',line_width,'marker','o','markersize',4)
errorbar(x_positions(13),mean_follow_sham,std_follow_sham,'color',Sham_color,'LineWidth',line_width,'marker','o','markersize',4,'HandleVisibility','off')

% tDCS
[mean_tDCS,std_tDCS,mean_follow_tDCS,std_follow_tDCS] = cal_mean_std(tDCS_data);
[y,stim,day] = y_stim_day(tDCS_data,y,stim,day,'tDCS');

errorbar(x_positions(1:12),mean_tDCS(1:12),std_tDCS(1:12),'color',tDCS_color,'LineWidth',line_width,'marker','o','markersize',4)
errorbar(x_positions(13),mean_follow_tDCS,std_follow_tDCS,'color',tDCS_color,'LineWidth',line_width,'marker','o','markersize',4,'HandleVisibility','off')

% tRNS
[mean_tRNS,std_tRNS,mean_follow_tRNS,std_follow_tRNS] = cal_mean_std(tRNS_data);
[y,stim,day] = y_stim_day(tRNS_data,y,stim,day,'tRNS');

errorbar(x_positions(1:12),mean_tRNS(1:12),std_tRNS(1:12),'color',tRNS_color,'LineWidth',line_width,'marker','o','markersize',4)
errorbar(x_positions(13),mean_follow_tRNS,std_follow_tRNS,'color',tRNS_color,'LineWidth',line_width,'marker','o','markersize',4,'HandleVisibility','off')

p = anovan(y,{stim,day},'model','interaction','varnames',{'g1','g2'});

if strcmp(var, 'time')
    plot([4 7 8],[900 900 900],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([5,x_positions(13)],[900,900],'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    ylim([0 1000])
    yticks([200 600 1000])
    ylabel('Time (s)')
elseif strcmp(var, 'error')
    plot([2:12,14],ones(1,12)*550,'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([4 7:12 14],ones(1,8)*530,'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    ylim([0,600])
    yticks([0 200 400 600])
    ylabel('Error (mm^2)')
elseif strcmp(var, 'score')
    plot([7 8],ones(1,2)*250,'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([5 6 9],ones(1,3)*250,'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    ylim([0 260])
    ylabel('FLS score')
end
xlim([0,15])
xticks(x_positions(1:13))
xticklabels({'Day1','Day2','Day3','Day4','Day5','Day6','Day7','Day8','Day9','Day10','Day11','Day12','FollowUp'})
xtickangle(45)
legend('Sham','tDCS','tRNS','location','bestoutside')
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')
set(gcf, 'Position',  [112   550   303   155])
box off

% enlarge
if strcmp(var, 'time')
    figure
    hold on
    errorbar(x_positions(1:12),mean_tRNS(1:12),std_tRNS(1:12),'color',tRNS_color,'LineWidth',line_width,'marker','o','markersize',4)
    errorbar(x_positions(1:12),mean_tDCS(1:12),std_tDCS(1:12),'color',tDCS_color,'LineWidth',line_width,'marker','o','markersize',4)
    errorbar(x_positions(1:12),mean_sham(1:12),std_sham(1:12),'color',Sham_color,'LineWidth',line_width,'marker','o','markersize',4)

    plot([4 7 8],[120 120 120],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([5,15],[120,120],'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    xlim([3.5,8.5])
    ylim([40 120])
    xticks(x_positions(4:8))
    xticklabels({'day4','day5','day6','day7','day8'})
    xtickangle(45)
    yticks([50 100])
    set(gca,'FontSize',6)
    set(gca, 'FontName', 'helvetica')
    set(gcf, 'Position',  [452   625   103    80])
    box off
elseif strcmp(var, 'score')
    figure
    hold on
    errorbar(x_positions(1:12),mean_sham(1:12),std_sham(1:12),'color',Sham_color,'LineWidth',line_width,'marker','o','markersize',4)
    errorbar(x_positions(1:12),mean_tDCS(1:12),std_tDCS(1:12),'color',tDCS_color,'LineWidth',line_width,'marker','o','markersize',4)
    errorbar(x_positions(1:12),mean_tRNS(1:12),std_tRNS(1:12),'color',tRNS_color,'LineWidth',line_width,'marker','o','markersize',4)

    plot([7 8],ones(1,2)*250,'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([5 6 9],ones(1,3)*250,'*','color',tDCS_color,'HandleVisibility','off','markersize',4)

    xlim([4.5,9.5])
    ylim([160 260])
    xticks(x_positions(5:9))
    xticklabels({'day5','day6','day7','day8','day9'})
    xtickangle(45)
    yticks([200 250])
    ylabel('FLS score')
    set(gca,'FontSize',6)
    set(gca, 'FontName', 'helvetica')
    set(gcf, 'Position',  [452   625   103    60])
    box off
end

end

function [mean, std, mean_follow, std_follow] = cal_mean_std(Sham_data)
mean = nanmean(Sham_data,2);
std = 2*1.96*nanstd(Sham_data,0,2)./sqrt(sum(~isnan(Sham_data),2));

follow = reshape(Sham_data(13:15,:),1,[]);
mean_follow = nanmean(follow,2);
std_follow = 2*1.96*nanstd(follow,0,2)./sqrt(sum(~isnan(follow),2));
end

function [y,stim,day] = y_stim_day(data,y,stim,day,stim_type)

tmp = data(1,~isnan(data(1,:)));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
elseif strcmp(stim_type,'tRNS')
    stim = [stim, ones(1,n).*2];
end
day = [day, zeros(1,n)];

tmp = data(12,~isnan(data(12,:)));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
elseif strcmp(stim_type,'tRNS')
    stim = [stim, ones(1,n).*2];
end
day = [day, ones(1,n)];

follow = reshape(data(13:15,:),1,[]);
tmp = follow(~isnan(follow));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
elseif strcmp(stim_type,'tRNS')
    stim = [stim, ones(1,n).*2];
end
day = [day, ones(1,n).*2];
end