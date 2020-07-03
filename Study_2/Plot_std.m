function Plot_std(Data,var)
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


figure
hold on
std_tRNS = nanstd(tRNS_data,0,2);
std_tDCS = nanstd(tDCS_data,0,2);
std_Sham = nanstd(Sham_data,0,2);

plot(2:12,std_Sham(2:12),'color',Sham_color,'LineWidth',line_width,'Marker','o','markersize',4)
plot(2:12,std_tRNS(2:12),'color',tRNS_color,'LineWidth',line_width,'Marker','o','markersize',4)
plot(2:12,std_tDCS(2:12),'color',tDCS_color,'LineWidth',line_width,'Marker','o','markersize',4)
if strcmp(var, 'time')
    ylabel('STD of time (s)','FontSize',9)
    yticks([20 40 60])
    set(gcf, 'Position',  [963   569   203   126])
elseif strcmp(var, 'error')
    ylabel('STD of error (mm^2)','FontSize',9)
    yticks([100 200])
    set(gcf, 'Position',  [416   548   234   157])
elseif strcmp(var, 'score')
    ylabel('STD of FLS score','FontSize',9)
    yticks([10 30 50])
    set(gcf, 'Position',  [963   547   203   126])
end

xticks([2 6 12])
xticklabels({'Day2','Day6','Day12'})
xtickangle(45)
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')