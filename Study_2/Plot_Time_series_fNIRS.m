close all
fs = 1/0.128;
load('../../../Processed_Data/TSHbMatrix.mat','Hb')
tRNS_color = [56,181,254]./256;
tDCS_color = [253,145,80]./256;
Sham_color = [90,90,90]./256;

bio = 1;
brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
figure
hold on
for brain_area = 1:length(brain_areas)
    data = Hb{bio}.train1{brain_area};
%     data = Hb{bio}.train2{brain_area};
%     data = Hb{bio}.follow{brain_area};
%     data = Hb{bio}.transfer1{brain_area};
%     data = Hb{bio}.transfer2{brain_area};
%     data = Hb{bio}.Day1{brain_area};
%     figure
%     hold on
    subplot(2,4,brain_area)
    hold on
    Sham_y = data(3,:)';
    Sham_dy = 2*1.96*data(6,:)'./sqrt(data(9,:)');
    x = (1:size(data,2))';
    fill([x;flipud(x)],[Sham_y-Sham_dy/2;flipud(Sham_y+Sham_dy/2)],[0.7 0.7 0.7],'linestyle','none');
%     alpha 0.9
    plot(x,Sham_y,'color',Sham_color,'linewidth',1)
    hold on
    
    tDCS_y = data(1,:)';
    tDCS_dy = 2*1.96*data(4,:)'./sqrt(data(7,:)');
    x = (1:size(data,2))';
    fill([x;flipud(x)],[tDCS_y-tDCS_dy/2;flipud(tDCS_y+tDCS_dy/2)],[236 150 164]./255,'linestyle','none');
    alpha 0.3
    plot(x,tDCS_y,'color',tDCS_color,'linewidth',1)
    hold on

    tRNS_y = data(2,:)';
    tRNS_dy = 2*1.96*data(5,:)'./sqrt(data(8,:)');
    x = (1:size(data,2))';
    fill([x;flipud(x)],[tRNS_y-tRNS_dy/2;flipud(tRNS_y+tRNS_dy/2)],[150 207 236]./255,'linestyle','none');
    alpha 0.3
    plot(x,tRNS_y,'color',tRNS_color,'linewidth',1)
    hold on
    
    % train1
    if ismember(brain_area, [3 4 5])
        plot(round(fs*28),3*1e-7,'*','color',tRNS_color,'HandleVisibility','off','markersize',6)
    end
% %     train 2
%     if ismember(brain_area, [1 3 7])
%         plot(round(fs*28),3*1e-7,'*','color',tRNS_color,'HandleVisibility','off','markersize',6)
%     end
%     if ismember(brain_area, [2 4 7 8])
%         plot(round(fs*28),4*1e-7,'*','color',tDCS_color,'HandleVisibility','off','markersize',6)
%     end
%     % follow
%     if brain_area==7
%         plot(round(fs*28),12*1e-7,'*','color',tRNS_color,'HandleVisibility','off','markersize',6)
%     end
%     if brain_area==6
%         plot(round(fs*28),12*1e-7,'*','color',tDCS_color,'HandleVisibility','off','markersize',6)
%     end

    
    ylim_value = get(gca,'ylim');
    plot([round(fs*10) round(fs*10)],ylim_value*1.5,'--','color','k')
    title(brain_areas{brain_area})
    ylim(ylim_value*1.5)
    ylabel('Mol')
    xlabel('Second')
    xticks([round(fs*10) round(fs*20) round(fs*30) round(fs*40) round(fs*50) round(fs*60) round(fs*70)])
    xticklabels({'0','10','20','30','40','50', '60'})
    xlim([0 round(fs*70)])

    set(gcf,'position',[125         459        1114         380])
    set(gca,'fontsize',15)
    patch(([10 25 25 10]+10)*fs,[ylim_value(1),ylim_value(1),ylim_value(2),ylim_value(2)]*1.5,...
        [0.4660 0.6740 0.1880],'linestyle','none','FaceAlpha',.1);
    
end