function Plot_1_12_f(Data, var)
define_colors
line_width = 0.8;
if strcmp(var, 'time')
    Sham_data = Data.Sham_TIME;
    tDCS_data = Data.tDCS_TIME;
%     tRNS_data = Data.tRNS_TIME;
elseif strcmp(var, 'error')
    Sham_data = Data.Sham_ERROR;
    tDCS_data = Data.tDCS_ERROR;
%     tRNS_data = Data.tRNS_ERROR;
elseif strcmp(var, 'score')
    Sham_data = Data.Sham_SCORE;
    tDCS_data = Data.tDCS_SCORE;
%     tRNS_data = Data.tRNS_SCORE;
end
[mean_sham,std_sham,mean_follow_sham,std_follow_sham] = cal_mean_std(Sham_data);
[mean_tDCS,std_tDCS,mean_follow_tDCS,std_follow_tDCS] = cal_mean_std(tDCS_data);
% [mean_tRNS,std_tRNS,mean_follow_tRNS,std_follow_tRNS] = cal_mean_std(tRNS_data);

figure
hold on

bar_width   =   0.30;

b           =   bar([1,2,3] - 0.2,[mean_tDCS([1,12])',mean_follow_tDCS], bar_width,'facecolor',tDCS_color);
b.FaceColor =   'flat';
b(1).CData  =   tDCS_color;



b           =   bar([1,2,3] + 0.2,[mean_sham([1,12])',mean_follow_sham], bar_width,'facecolor',Sham_color);
b.FaceColor =   'flat';
b.CData     =   Sham_color;

% b           =   bar([1,2,3],[mean_tRNS([1,12])',mean_follow_tRNS], bar_width);
% b.FaceColor =   'flat';
% b(1).CData  =   tRNS_color;


errorbar([1,2,3] - 0.2,[mean_tDCS([1,12])',mean_follow_tDCS],...
    [std_tDCS([1,12])',std_follow_tDCS],...
    'color','k','LineWidth',line_width,'marker','.','markersize',0.5, 'linestyle', 'none','HandleVisibility','off')

errorbar([1,2,3] + 0.2,[mean_sham([1,12])',mean_follow_sham],...
    [std_sham([1,12])',std_follow_sham],...
    'color','k','LineWidth',line_width,'marker','.','markersize',0.5, 'linestyle', 'none','HandleVisibility','off')

% errorbar([1,2,3],[mean_tRNS([1,12])',mean_follow_tRNS],...
%     [std_tRNS([1,12])',std_follow_tRNS],...
%     'color','k','LineWidth',line_width,'marker','.','markersize',0.5, 'linestyle', 'none','HandleVisibility','off')
if strcmp(var, 'time')
    ylim([0 800])
    yticks([0 400 800])
    ylabel('Time (s)')
elseif strcmp(var, 'error')
    ylim([0 600])
    yticks([0 300 600])
    ylabel('Error (mm^2)')
elseif strcmp(var, 'score')
    ylim([0 300])
    ylabel('FLS score')
end
xlim([0.4,3.5])
xticks([1 2 3])
xticklabels({'Day1','Day12','FollowUp'})
xtickangle(45)
set(gca,'FontSize',12)
set(gca, 'FontName', 'helvetica')
set(gcf, 'Position',  [396        1134         254         196])
box off
% legend('Sham','tDCS','tRNS','location','best')