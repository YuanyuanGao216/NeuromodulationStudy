function Plot_std_trial(Data,var)
define_colors
line_width = 0.8;
anovafile = fopen('../../../Processed_Data/std_anova.txt','a+');
fprintf(anovafile,'%s\n',var);
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
% tRNS_data_reshape = reshape(tRNS_data,[15,11,7]);
tDCS_data_reshape = reshape(tDCS_data,[15,11,7]);
Sham_data_reshape = reshape(Sham_data,[15,11,7]);


% std_tRNS = squeeze(nanstd(tRNS_data_reshape,0,2));
std_tDCS = squeeze(nanstd(tDCS_data_reshape,0,2));
std_Sham = squeeze(nanstd(Sham_data_reshape,0,2));

% mean_std_tRNS = nanmean(std_tRNS,2);
mean_std_tDCS = nanmean(std_tDCS,2);
mean_std_Sham = nanmean(std_Sham,2);

% std_std_tRNS = 2*1.96*nanstd(std_tRNS,0,2)./sqrt(sum(~isnan(std_tRNS)));
std_std_tDCS = 2*1.96*nanstd(std_tDCS,0,2)./sqrt(sum(~isnan(std_tDCS)));
std_std_Sham = 2*1.96*nanstd(std_Sham,0,2)./sqrt(sum(~isnan(std_Sham)));

errorbar((2:12) - 0.2,mean_std_Sham(2:12),std_std_Sham(2:12),'color',Sham_color,'LineWidth',line_width,'Marker','o','markersize',4)
% errorbar(2:12,mean_std_tRNS(2:12),std_std_tRNS(2:12),'color',tRNS_color,'LineWidth',line_width,'Marker','o','markersize',4)
errorbar((2:12) + 0.2,mean_std_tDCS(2:12),std_std_tDCS(2:12),'color',tDCS_color,'LineWidth',line_width,'Marker','o','markersize',4)

t_test_each_day(std_tDCS,std_Sham,var)

if strcmp(var, 'time')
    ylabel('STD of time (s)','FontSize',9)
%     yticks([20 40 60])
    xlim([1 13])
    set(gcf, 'Position',  [548   579   273   186])
elseif strcmp(var, 'error')
    ylabel('STD of error (mm^2)','FontSize',9)
%     yticks([30 60 90])
    xlim([1 13])
    set(gcf, 'Position',  [548   579   273   186])
elseif strcmp(var, 'score')
    ylabel('STD of FLS score','FontSize',9)
    xlim([1 13])
%     yticks([10 30 50])
    set(gcf, 'Position',  [548   579   273   186])
end

xticks([2 6 12])
xticklabels({'Day2','Day6','Day12'})
xtickangle(45)
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')