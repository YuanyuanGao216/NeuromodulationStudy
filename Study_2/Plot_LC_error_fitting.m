
define_colors
x = 1:12;

x_array = reshape(repmat(x',1,77),[],1);
Sham_error_array = reshape(Data.Sham_ERROR(1:12,:),[],1);
tDCS_error_array = reshape(Data.tDCS_ERROR(1:12,:),[],1);
tRNS_error_array = reshape(Data.tRNS_ERROR(1:12,:),[],1);
idx_sham = isnan(Sham_error_array);
idx_tDCS = isnan(tDCS_error_array);
idx_tRNS = isnan(tRNS_error_array);

P_Sham = polyfit(x_array(~idx_sham),Sham_error_array(~idx_sham),1);
P_tDCS = polyfit(x_array(~idx_tDCS),tDCS_error_array(~idx_tDCS),1);
P_tRNS = polyfit(x_array(~idx_tRNS),tRNS_error_array(~idx_tRNS),1);
yfit_Sham = P_Sham(1)*(0:13)+P_Sham(2);
yfit_tDCS = P_tDCS(1)*(0:13)+P_tDCS(2);
yfit_tRNS = P_tRNS(1)*(0:13)+P_tRNS(2);

figure

subplot(1,3,1)
hold on
p_dot2 = plot(x_array,tDCS_error_array,'color',tDCS_color,'marker','.','markersize',1,'linestyle','none');
p2 = plot((0:13),yfit_tDCS,'color',tDCS_color,'LineWidth',2,'LineStyle','-','DisplayName','fitted line');
xticks([1 6 12])
xticklabels({'Day1','Day6','Day12'})
xtickangle(45)
xlim([0,13])
ylim([0,1000])
ylabel('Error (mm^2)')
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')

subplot(1,3,3)
hold on
p_dot1 = plot(x_array,Sham_error_array,'color',Sham_color,'marker','.','markersize',1,'linestyle','none');
p1 = plot((0:13),yfit_Sham,'color',Sham_color,'LineWidth',2,'LineStyle','-','DisplayName','fitted line');
xticks([1 6 12])
xticklabels({'Day1','Day6','Day12'})
xtickangle(45)
xlim([0,13])
ylim([0,1000])
ylabel('Error (mm^2)')
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')


subplot(1,3,2)
hold on
p_dot3 = plot(x_array,tRNS_error_array,'color',tRNS_color,'marker','.','markersize',1,'linestyle','none');
p3 = plot((0:13),yfit_tRNS,'color',tRNS_color,'LineWidth',2,'LineStyle','-','DisplayName','fitted line');
xticks([1 6 12])
xticklabels({'Day1','Day6','Day12'})
xtickangle(45)
xlim([0,13])
ylim([0,1000])
ylabel('Error (mm^2)')
% title('tRNS')
set(gca,'FontSize',9)
set(gca, 'FontName', 'helvetica')
set(gcf, 'Position',  [53   347   639   132])