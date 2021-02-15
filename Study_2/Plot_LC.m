function Plot_LC(Data,var)
x_positions = [1:12,14,15,16];
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


figure
hold on

% Sham
[mean_sham,std_sham,mean_follow_sham,std_follow_sham] = cal_mean_std(Sham_data);
errorbar(x_positions(1:12)-0.2,mean_sham(1:12),std_sham(1:12),'color',Sham_color,'LineWidth',line_width,'marker','o','markersize',4)

% tDCS
[mean_tDCS,std_tDCS,mean_follow_tDCS,std_follow_tDCS] = cal_mean_std(tDCS_data);
errorbar(x_positions(1:12)+0.2,mean_tDCS(1:12),std_tDCS(1:12),'color',tDCS_color,'LineWidth',line_width,'marker','o','markersize',4)

t_test_each_day(Sham_data,tDCS_data,var);

if strcmp(var, 'time')
    yticks([200 600 1000])
    ylabel('Time (s)')
elseif strcmp(var, 'error')
    plot(7:12,ones(1,6)*530,'*','color','k','HandleVisibility','off','markersize',4)
    ylim([0,600])
    yticks([0 200 400 600])
    ylabel('Error (mm^2)')
elseif strcmp(var, 'score')
    plot(6, 250,'*','color','k','HandleVisibility','off','markersize',4)
    ylim([0 260])
    ylabel('FLS score')
end
xlim([0,13])
xticks(x_positions([1 6 12]))
xticklabels({'Day1','Day6','Day12'})
xtickangle(45)
% legend('Sham','tDCS','location','bestoutside')
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')
set(gcf, 'Position',  [548   579   273   186])
box off

end


