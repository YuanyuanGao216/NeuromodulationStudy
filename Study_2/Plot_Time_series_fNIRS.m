close all
fs = 1/0.128;
load('../../../Processed_Data/TSHbMatrix.mat','Hb')
define_colors
line_width = 0.7;
bio = 1;
brain_areas = {'left PFC';'middle PFC';'right PFC';'left lateral M1';'left middle M1';'right middle M1';'right lateral M1';'SMA'};
figure
hold on
for brain_area = 1:length(brain_areas)
%     data = Hb{bio}.train1{brain_area}; group_data = Hb{bio}.group.train1{brain_area};
    data = Hb{bio}.train2{brain_area};group_data = Hb{bio}.group.train2{brain_area};
%     data = Hb{bio}.follow{brain_area};group_data = Hb{bio}.group.follow{brain_area};
%     data = Hb{bio}.transfer1{brain_area};group_data = Hb{bio}.group.transfer1{brain_area};
%     data = Hb{bio}.transfer2{brain_area};group_data = Hb{bio}.group.transfer2{brain_area};
%     data = Hb{bio}.Day1{brain_area};group_data = Hb{bio}.group.Day1{brain_area};

    data(1:4,:) = data(1:4,:) * 1e6;
    group_data = group_data * 1e6;
    if brain_area < 4
        subplot(2,4,brain_area + 5)
    elseif brain_area == 8
        subplot(2,4, 5)
    else
        subplot(2,4,brain_area - 3)
    end
    hold on
    Sham_y = data(2,:)';
    Sham_dy = 2*1.96*data(4,:)'./sqrt(data(6,:)');
    x = (1:size(data,2))';
    fill([x;flipud(x)],[Sham_y-Sham_dy/2;flipud(Sham_y+Sham_dy/2)],[150 207 236]./255,'linestyle','none');
%     alpha 0.9
    plot(x,Sham_y,'color',Sham_color,'linewidth',1)
    
    tDCS_y = data(1,:)';
    tDCS_dy = 2*1.96*data(3,:)'./sqrt(data(5,:)');
    x = (1:size(data,2))';
    fill([x;flipud(x)],[tDCS_y-tDCS_dy/2;flipud(tDCS_y+tDCS_dy/2)],[236 150 164]./255,'linestyle','none');
    alpha 0.5
    plot(x,tDCS_y,'color',tDCS_color,'linewidth',1)
    
    tDCS = group_data(1,:);
    Sham = group_data(2,:);
    
    [h_Sham,~] = kstest(Sham);
    [h_tDCS,~] = kstest(tDCS);
    if h_Sham == 0 && h_tDCS == 0 % if they are all normally distrubuted
        [h,p] = ttest(Sham,tDCS);
    else
        [p,h] = ranksum(Sham,tDCS);
    end
    
    x = ([70 80] + 10).*fs;
    
    errorbar(x(1),nanmean(tDCS),2*1.96*nanstd(tDCS)./sqrt(sum(~isnan(tDCS))),'Marker','o','MarkerSize',3,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
    errorbar(x(2),nanmean(Sham),2*1.96*nanstd(Sham)./sqrt(sum(~isnan(Sham))),'Marker','o','MarkerSize',3,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
    
    ylim_value = get(gca,'ylim');
%     train 2
    if ismember(brain_area, [3 7 8])
        plot([80 90].*fs, [ylim_value(2),ylim_value(2)]*0.9,'color','k','linewidth',1)
    end
    
    plot([round(fs*10) round(fs*10)],ylim_value*0.99,'--','color','k')
    title(brain_areas{brain_area})
%     ylim(ylim_value*1.5)
    ylabel('\muMol')
    xticks([round(fs*10)  round(fs*70)  round(fs*80)  round(fs*90)  round(fs*100)])
    xticklabels({'0s', '60s'})
    xlim([0 round(fs*105)])
    patch(([10 40 40 10]+10)*fs,[ylim_value(1),ylim_value(1),ylim_value(2),ylim_value(2)]*0.99,...
        [102, 153, 153]./255,'linestyle','none','FaceAlpha',.1);
    ylim(ylim_value)
    set(gca,'FontSize',12)
    set(gca, 'FontName', 'Arial')
end


set(gcf,'position',[125   333   911   372])