function Sig_Test_Hb(MeanHbMatrix,delete_unskilled,period)

% tRNS_color = [0,0,255]./255;
% tDCS_color = [255,0,0]./255;
% Sham_color = [0,0,0]./255;
tRNS_color = [0,0,255]./255;
tDCS_color = [255,0,0]./255;
% Sham_color = [0,0,0]./255;
Sham_color = [0,192,0]./255;

% Sig_Test_Hb do ANOVA test, save the p value to ANOVA.txt, plot boxplot
% and put the pairwise p values on the boxplot, and also plot a errbar plot 
% MeanHbMatrix.Train = nan(3,7,12,11,2,28)
% 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
% biomarkers(HbO&HbR); 28 channels;
% MeanHbMatrix.Follow = nan(3,7,1,3,2,28)
% MeanHbMatrix.Transfer = nan(3,7,2,1,2,28)
% unskilled : B1;A1;A2;B6
savepath = '../../../Processed_Data/HbOverlay';


if delete_unskilled == 1
    MeanHbMatrix.Train(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Train(2,6,:,:,:,:) = nan;
    
    MeanHbMatrix.Follow(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Follow(2,6,:,:,:,:) = nan;
    
    MeanHbMatrix.Transfer(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(2,6,:,:,:,:) = nan;
    savepath = '../../../Processed_Data/HbOverlay_del_unskilled';
end
if period.end ~= 0
    savepath = [savepath,num2str(period.start),num2str(period.end)];
end

% ANOVA file
filename = [savepath,'/ANOVA.txt'];

ANOVA_file = fopen(filename,'w');

brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
brain_channels = [2,2,2,5,4,4,5,4];
biomarkers = {'HbO','HbR'};
stim_codes = {'tDCS','tRNS','Sham'};

% %% train
% for day = 1:12
%     fprintf(ANOVA_file,'Day #%d:\n',day);
%     % boxplot with sig test
%     for bio = 1:length(biomarkers)
%         fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
%         h_boxplot = figure; % this figure is boxplot
%         hold on
%         h_errbar = figure; % this figure is for error bar
%         hold on
%         plot([0.5 8.5],[0 0],'g-.')
%         for brain_area = 1:length(brain_areas)
%             channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
%             data = MeanHbMatrix.Train(:,:,day,:,bio,channels);
%             channel_mean = nanmean(data,6).*1e6;
%             X1 = reshape(channel_mean(1,:,:,:),[],1);
%             X2 = reshape(channel_mean(2,:,:,:),[],1);
%             X3 = reshape(channel_mean(3,:,:,:),[],1);
%             X = [X1;X2;X3].*1e6;
%             Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
%             title_string = sprintf('Day #%d %s %s',day,string(biomarkers{bio}),string(brain_areas{brain_area}));
%             p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
%             fprintf(ANOVA_file,'p = %.3f\n',p);
%             % errbar
%             figure(h_errbar)
%             x = [-0.2 0 0.2]+ brain_area;
%             errorbar(x(1),nanmean(X1),nanstd(X1),'Marker','*','MarkerSize',2,'Color',tDCS_color,'LineWidth',1);
%             errorbar(x(2),nanmean(X2),nanstd(X2),'Marker','*','MarkerSize',2,'Color',tRNS_color,'LineWidth',1);
%             errorbar(x(3),nanmean(X3),nanstd(X3),'Marker','*','MarkerSize',2,'Color',Sham_color,'LineWidth',1);
%         end
%         % edit error bar plot
%         figure(h_errbar)
%         xticks(1:8)
%         xticklabels(brain_areas)
%         xtickangle(90)
%         ylabel('\muMol')
%         ylim_values = get(gca,'ylim');
%         ylim(ylim_values*1.3)
%         xlim([0.5 8.5])
%         set(gca,'FontSize',9)
%         box on
%         set(h_errbar, 'Position',  [100, 100, 500, 230])
%         
%         set(h_boxplot, 'Position',  [100, 100, 1000, 400])
%         % save both plots
%         figpath = [savepath,'/day',char(string(day)),'/boxplot/'];
%         oldfolder = cd(char(figpath));
%         saveas(h_boxplot,char(biomarkers{bio}),'fig')
%         saveas(h_boxplot,char(biomarkers{bio}),'svg')
%         saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
%         saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
%         cd(oldfolder)
%         close(h_boxplot)
%         close(h_errbar)
%     end
% end
%% Day1, Day2-6, Day7-12, Transfer1,FollowUp, Transfer2
tDCSTrendMean = nan(6, 8);
tDCSTrendError = nan(6, 8);
tRNSTrendMean = nan(6, 8);
tRNSTrendError = nan(6, 8);
ShamTrendMean = nan(6, 8);
ShamTrendError = nan(6, 8);
line_width = 0.5;

%% whole follow
fprintf(ANOVA_file,'FollowUp 1-3:\n');
for bio = 1:1
    fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
    h_boxplot = figure;
    hold on
    h_errbar = figure; % this figure is for error bar
    hold on
%     plot([0.5 8.5],[0 0],'g-.')
    for brain_area = 1:length(brain_areas)
        channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
        data = MeanHbMatrix.Follow(:,:,:,:,bio,channels);
        channel_mean = nanmean(data,6).*1e6;
        X1 = reshape(channel_mean(1,:,:,:),[],1);
        X2 = reshape(channel_mean(2,:,:,:),[],1);
        X3 = reshape(channel_mean(3,:,:,:),[],1);
        X = [X1;X2;X3].*1e6;
        Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
        title_string = sprintf('Follow %s %s',string(biomarkers{bio}),string(brain_areas{brain_area}));
        p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
        fprintf(ANOVA_file,'p = %.3f\n',p);
        % errbar
        figure(h_errbar)
        x = [-0.2 0 0.2]+ brain_area;
        errorbar(x(1),nanmean(X1),2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
        errorbar(x(2),nanmean(X2),2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2))),'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);
        errorbar(x(3),nanmean(X3),2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
        tDCSTrendMean(5,brain_area) = nanmean(X1);
        tDCSTrendError(5,brain_area) = 2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1)));
        tRNSTrendMean(5,brain_area) = nanmean(X2);
        tRNSTrendError(5,brain_area) = 2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2)));
        ShamTrendMean(5,brain_area) = nanmean(X3);
        ShamTrendError(5,brain_area) = 2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3)));
    end
    figure(h_errbar)
    plot(7,0.8,'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot(6-0.2,0.8,'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    xticks(1:8)
    xticklabels(brain_areas)
    xtickangle(90)
    ylabel('\muMol')
%     ylim_values = get(gca,'ylim');
%     ylim(ylim_values*1.3)
    xlim([0.5 8.5])
    set(gca,'FontSize',9)
    set(gca, 'FontName', 'helvetica')
    box off
    set(h_errbar, 'Position',  [100 100 250   120])
%     ax = gca;
%     ax.XGrid = 'off';
%     ax.YGrid = 'on';
%     legend('tDCS','tRNS','Sham','location','bestoutside')
    
    
    set(h_boxplot, 'Position',  [100, 100, 1000, 400])
    figpath = [savepath,'/follow/boxplot/'];
    oldfolder = cd(char(figpath));
    saveas(h_boxplot,char(biomarkers{bio}),'fig')
    saveas(h_boxplot,char(biomarkers{bio}),'svg')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
    cd(oldfolder)
%     close(h_boxplot)
%     close(h_errbar)
end


%% transfer
for t = 1:2
    fprintf(ANOVA_file,'Transfer #%d:\n',t);
    for bio = 1:1
        fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
        h_boxplot = figure;
        hold on
        h_errbar = figure; % this figure is for error bar
        hold on
%         plot([0.5 8.5],[0 0],'g-.')
        for brain_area = 1:length(brain_areas)
            channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            data = MeanHbMatrix.Transfer(:,:,t,:,bio,channels);
            channel_mean = nanmean(data,6).*1e6;
            X1 = reshape(channel_mean(1,:,:,:),[],1);
            X2 = reshape(channel_mean(2,:,:,:),[],1);
            X3 = reshape(channel_mean(3,:,:,:),[],1);
            X = [X1;X2;X3];
            Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
            title_string = sprintf('Transfer #%d %s %s',t,string(biomarkers{bio}),string(brain_areas{brain_area}));
            p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
            fprintf(ANOVA_file,'p = %.3f\n',p);
            % errbar
            figure(h_errbar)
            x = [-0.2 0 0.2]+ brain_area;
            errorbar(x(1),nanmean(X1),2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
            errorbar(x(2),nanmean(X2),2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2))),'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);
            errorbar(x(3),nanmean(X3),2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
            if t == 1
                idx = 4;
            else
                idx = 6;
            end
            tDCSTrendMean(idx,brain_area) = nanmean(X1);
            tDCSTrendError(idx,brain_area) = 2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1)));
            tRNSTrendMean(idx,brain_area) = nanmean(X2);
            tRNSTrendError(idx,brain_area) = 2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2)));
            ShamTrendMean(idx,brain_area) = nanmean(X3);
            ShamTrendError(idx,brain_area) = 2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3)));
        end
        % edit error bar plot
        figure(h_errbar)
        xticks(1:8)
        xticklabels(brain_areas)
        xtickangle(90)
        ylabel('\muMol')
    %     ylim_values = get(gca,'ylim');
        ylim([-2 2])
        xlim([0.5 8.5])
        set(gca,'FontSize',9)
        set(gca, 'FontName', 'helvetica')
        box off
        set(h_errbar, 'Position',  [100 100 250   120])
%         ax = gca;
%         ax.XGrid = 'off';
%         ax.YGrid = 'on';
%         legend('tDCS','tRNS','Sham','location','bestoutside')


        set(h_boxplot, 'Position',  [100, 100, 1000, 400])
        figpath = [savepath,'/follow/boxplot/'];
        oldfolder = cd(char(figpath));
        saveas(h_boxplot,char(biomarkers{bio}),'fig')
        saveas(h_boxplot,char(biomarkers{bio}),'svg')
        saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
        saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
        cd(oldfolder)
    end
end


%% day 2-6
% sig
fprintf(ANOVA_file,'Day 2-6:\n');
% for bio = 1:length(biomarkers)
for bio = 1:1
    fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
    h_boxplot = figure;
    hold on
    h_errbar = figure; % this figure is for error bar
    hold on
%     plot([0.5 8.5],[0 0],'g-.')
    for brain_area = 1:length(brain_areas)
        channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
        % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
        % 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
        % biomarkers(HbO&HbR); 28 channels;
        data = MeanHbMatrix.Train(:,:,2:6,:,bio,channels);
        channel_mean = nanmean(data,6).*1e6;
        X1 = reshape(channel_mean(1,:,:,:),[],1);
        X2 = reshape(channel_mean(2,:,:,:),[],1);
        X3 = reshape(channel_mean(3,:,:,:),[],1);
        X = [X1;X2;X3].*1e6;
        Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
        title_string = sprintf('Day2-6 %s %s',string(biomarkers{bio}),string(brain_areas{brain_area}));
        p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
        fprintf(ANOVA_file,'p = %.3f\n',p);
        % errbar
        figure(h_errbar)
        x = [-0.2 0 0.2]+ brain_area;
        errorbar(x(1),nanmean(X1),2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
        errorbar(x(2),nanmean(X2),2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2))),'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);
        errorbar(x(3),nanmean(X3),2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
        tDCSTrendMean(2,brain_area) = nanmean(X1);
        tDCSTrendError(2,brain_area) = 2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1)));
        tRNSTrendMean(2,brain_area) = nanmean(X2);
        tRNSTrendError(2,brain_area) = 2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2)));
        ShamTrendMean(2,brain_area) = nanmean(X3);
        ShamTrendError(2,brain_area) = 2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3)));
    end
    % edit error bar plot
    figure(h_errbar)
    plot([3 4 6],[0.35 0.35 0.35],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    xticks(1:8)
    xticklabels(brain_areas)
    xtickangle(90)
    ylabel('\muMol')
%     ylim_values = get(gca,'ylim');
%     ylim(ylim_values*1.3)
    xlim([0.5 8.5])
    set(gca,'FontSize',9)
    set(gca, 'FontName', 'helvetica')
    box off
    set(h_errbar, 'Position',  [100   197   250   120])
%     legend('tDCS','tRNS','Sham','location','bestoutside')
    
    
    set(h_boxplot, 'Position',  [100, 100, 1000, 400])
    figpath = [savepath,'/day2-6/boxplot/'];
    oldfolder = cd(char(figpath));
    saveas(h_boxplot,char(biomarkers{bio}),'fig')
    saveas(h_boxplot,char(biomarkers{bio}),'svg')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
    cd(oldfolder)
%     close(h_boxplot)
%     close(h_errbar)
end

%% day 7-12
% sig
fprintf(ANOVA_file,'Day 7-12:\n');
% for bio = 1:length(biomarkers)
for bio = 1:1
    fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
    h_boxplot = figure;
    hold on
    h_errbar = figure; % this figure is for error bar
    hold on
%     plot([0.5 8.5],[0 0],'g-.')
    for brain_area = 1:length(brain_areas)
        channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
        data = MeanHbMatrix.Train(:,:,7:12,:,bio,channels);
        channel_mean = nanmean(data,6).*1e6;
        X1 = reshape(channel_mean(1,:,:,:),[],1);
        X2 = reshape(channel_mean(2,:,:,:),[],1);
        X3 = reshape(channel_mean(3,:,:,:),[],1);
        X = [X1;X2;X3].*1e6;
        if brain_area == 4
            filename = [savepath,'/power.txt'];
            power_file = fopen(filename,'w');
            fprintf(power_file, 'for llM1:\n');
            tDCS_mean = nanmean(X1);tDCS_std = nanstd(X1);tDCS_n = sum(~isnan(X1));
            tRNS_mean = nanmean(X2);tRNS_std = nanstd(X2);tRNS_n = sum(~isnan(X2));
            Sham_mean = nanmean(X3);Sham_std = nanstd(X3);Sham_n = sum(~isnan(X3));
            fprintf(power_file, 'tDCS: mean = %.2f; std = %.2f; n = %d\n',tDCS_mean,tDCS_std, tDCS_n);
            fprintf(power_file, 'tRNS: mean = %.2f; std = %.2f; n = %d\n',tRNS_mean,tRNS_std, tRNS_n);
            fprintf(power_file, 'Sham: mean = %.2f; std = %.2f; n = %d\n',Sham_mean,Sham_std, Sham_n);
        end
        Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
        title_string = sprintf('Day7-12 %s %s',string(biomarkers{bio}),string(brain_areas{brain_area}));
        p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
        fprintf(ANOVA_file,'p = %.3f\n',p);
        % errbar
        figure(h_errbar)
        x = [-0.2 0 0.2]+ brain_area;
        errorbar(x(1),nanmean(X1),2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
        errorbar(x(2),nanmean(X2),2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2))),'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);
        errorbar(x(3),nanmean(X3),2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
        tDCSTrendMean(3,brain_area) = nanmean(X1);
        tDCSTrendError(3,brain_area) = 2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1)));
        tRNSTrendMean(3,brain_area) = nanmean(X2);
        tRNSTrendError(3,brain_area) = 2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2)));
        ShamTrendMean(3,brain_area) = nanmean(X3);
        ShamTrendError(3,brain_area) = 2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3)));
    end
    % edit error bar plot
    figure(h_errbar)
    plot([1 3 7],[0.4 0.4 0.4],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
    plot([2 4 7 8]-0.2,[0.4 0.4 0.4 0.4],'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
    xticks(1:8)
    xticklabels(brain_areas)
    xtickangle(90)
    ylabel('\muMol')
%     ylim_values = get(gca,'ylim');
%     ylim(ylim_values*1.3)
    xlim([0.5 8.5])
    set(gca,'FontSize',9)
    set(gca, 'FontName', 'helvetica')
    box off
    set(h_errbar, 'Position',  [100   197   250   120])
%     legend('tDCS','tRNS','Sham','location','bestoutside')
    
    set(h_boxplot, 'Position',  [100, 100, 1000, 400])
    figpath = [savepath,'/day7-12/boxplot/'];
    oldfolder = cd(char(figpath));
    saveas(h_boxplot,char(biomarkers{bio}),'fig')
    saveas(h_boxplot,char(biomarkers{bio}),'svg')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
    cd(oldfolder)
%     close(h_boxplot)
%     close(h_errbar)
end

%% Day 1
% sig
fprintf(ANOVA_file,'Day 1:\n');
% for bio = 1:length(biomarkers)
for bio = 1:1
    fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
    h_boxplot = figure;
    hold on
    h_errbar = figure; % this figure is for error bar
    hold on
%     plot([0.5 8.5],[0 0],'g-.')
    for brain_area = 1:length(brain_areas)
        channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
        % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
        % 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
        % biomarkers(HbO&HbR); 28 channels;
        data = MeanHbMatrix.Train(:,:,1,:,bio,channels);
        channel_mean = nanmean(data,6).*1e6;
        X1 = reshape(channel_mean(1,:,:,:),[],1);
        X2 = reshape(channel_mean(2,:,:,:),[],1);
        X3 = reshape(channel_mean(3,:,:,:),[],1);
        X = [X1;X2;X3].*1e6;
        Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
        title_string = sprintf('Day1 %s %s',string(biomarkers{bio}),string(brain_areas{brain_area}));
        p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
        fprintf(ANOVA_file,'p = %.3f\n',p);
        % errbar
        figure(h_errbar)
        x = [-0.2 0 0.2]+ brain_area;
        errorbar(x(1),nanmean(X1),2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
        errorbar(x(2),nanmean(X2),2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2))),'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);
        errorbar(x(3),nanmean(X3),2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
        tDCSTrendMean(1,brain_area) = nanmean(X1);
        tDCSTrendError(1,brain_area) = 2*1.96*nanstd(X1)./sqrt(sum(~isnan(X1)));
        tRNSTrendMean(1,brain_area) = nanmean(X2);
        tRNSTrendError(1,brain_area) = 2*1.96*nanstd(X2)./sqrt(sum(~isnan(X2)));
        ShamTrendMean(1,brain_area) = nanmean(X3);
        ShamTrendError(1,brain_area) = 2*1.96*nanstd(X3)./sqrt(sum(~isnan(X3)));
    end
    % edit error bar plot
    figure(h_errbar)
    xticks(1:8)
    xticklabels(brain_areas)
    xtickangle(90)
    ylabel('\muMol')
    xlim([0.5 8.5])
    set(gca,'FontSize',9)
    set(gca, 'FontName', 'helvetica')
    box off
    set(h_errbar, 'Position',  [100, 100, 250,   120])
%     ax = gca;
%     ax.XGrid = 'off';
%     ax.YGrid = 'on';
%     legend('tDCS','tRNS','Sham','location','bestoutside')
    
    
    set(h_boxplot, 'Position',  [100, 100, 1000, 400])
    figpath = [savepath,'/day2-6/boxplot/'];
    oldfolder = cd(char(figpath));
    saveas(h_boxplot,char(biomarkers{bio}),'fig')
    saveas(h_boxplot,char(biomarkers{bio}),'svg')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
    saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
    cd(oldfolder)
%     close(h_boxplot)
%     close(h_errbar)
end


%% follow

% for f = 1:3
%     fprintf(ANOVA_file,'FollowUp #%d:\n',f);
%     for bio = 1:length(biomarkers)
%         fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
%         h_boxplot = figure;
%         hold on
%         h_errbar = figure; % this figure is for error bar
%         hold on
%         plot([0.5 8.5],[0 0],'g-.')
%         for brain_area = 1:length(brain_areas)
%             channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
%             data = MeanHbMatrix.Follow(:,:,:,f,bio,channels);
%             channel_mean = nanmean(data,6).*1e6;
%             X1 = reshape(channel_mean(1,:,:,:),[],1);
%             X2 = reshape(channel_mean(2,:,:,:),[],1);
%             X3 = reshape(channel_mean(3,:,:,:),[],1);
%             X = [X1;X2;X3].*1e6;
%             Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
%             title_string = sprintf('FollowUp #%d %s %s',f,string(biomarkers{bio}),string(brain_areas{brain_area}));
%             p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
%             fprintf(ANOVA_file,'p = %.3f\n',p);
%             % errbar
%             figure(h_errbar)
%             x = [-0.2 0 0.2]+ brain_area;
%             errorbar(x(1),nanmean(X1),nanstd(X1),'Marker','*','MarkerSize',2,'Color','b','LineWidth',1);
%             errorbar(x(2),nanmean(X2),nanstd(X2),'Marker','*','MarkerSize',2,'Color','r','LineWidth',1);
%             errorbar(x(3),nanmean(X3),nanstd(X3),'Marker','*','MarkerSize',2,'Color','k','LineWidth',1);
%         end
%         % edit error bar plot
%         figure(h_errbar)
%         xticks(1:8)
%         xticklabels(brain_areas)
%         xtickangle(90)
%         ylabel('\muMol')
%         ylim_values = get(gca,'ylim');
%         ylim(ylim_values*1.3)
%         xlim([0.5 8.5])
%         set(gca,'FontSize',9)
%         box on
%         set(h_errbar, 'Position',  [100, 100, 500, 230])
%         
%         set(h_boxplot, 'Position',  [100, 100, 1000, 400])
%         figpath = [savepath,'/follow',char(string(f)),'/boxplot/'];
%         oldfolder = cd(char(figpath));
%         saveas(h_boxplot,char(biomarkers{bio}),'fig')
%         saveas(h_boxplot,char(biomarkers{bio}),'svg')
%         saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
%         saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
%         cd(oldfolder)
%         close(h_boxplot)
%         close(h_errbar)
%     end
% end




%% day 3-6
% % sig
% fprintf(ANOVA_file,'Day 3-6:\n');
% for bio = 1:length(biomarkers)
%     fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
%     h_boxplot = figure;
%     hold on
%     h_errbar = figure; % this figure is for error bar
%     hold on
%     plot([0.5 8.5],[0 0],'g-.')
%     for brain_area = 1:length(brain_areas)
%         channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
%         data = MeanHbMatrix.Train(:,:,3:6,:,bio,channels);
%         channel_mean = nanmean(data,6).*1e6;
%         X1 = reshape(channel_mean(1,:,:,:),[],1);
%         X2 = reshape(channel_mean(2,:,:,:),[],1);
%         X3 = reshape(channel_mean(3,:,:,:),[],1);
%         X = [X1;X2;X3].*1e6;
%         Group = [repmat({'tDCS'},size(X1,1),1);repmat({'tRNS'},size(X2,1),1);repmat({'Sham'},size(X3,1),1)];
%         title_string = sprintf('Day3-6 %s %s',string(biomarkers{bio}),string(brain_areas{brain_area}));
%         p = performANOVA(X,Group,title_string,brain_area,h_boxplot);
%         fprintf(ANOVA_file,'p = %.3f\n',p);
%         % errbar
%         figure(h_errbar)
%         x = [-0.2 0 0.2]+ brain_area;
%         errorbar(x(1),nanmean(X1),nanstd(X1),'Marker','*','MarkerSize',2,'Color','b','LineWidth',1);
%         errorbar(x(2),nanmean(X2),nanstd(X2),'Marker','*','MarkerSize',2,'Color','r','LineWidth',1);
%         errorbar(x(3),nanmean(X3),nanstd(X3),'Marker','*','MarkerSize',2,'Color','k','LineWidth',1);
%     end
%     % edit error bar plot
%     figure(h_errbar)
%     xticks(1:8)
%     xticklabels(brain_areas)
%     xtickangle(90)
%     ylabel('\muMol')
%     ylim_values = get(gca,'ylim');
%     ylim(ylim_values*1.3)
%     xlim([0.5 8.5])
%     set(gca,'FontSize',9)
%     box on
%     set(h_errbar, 'Position',  [100, 100, 500, 230])
%     
%     set(h_boxplot, 'Position',  [100, 100, 1000, 400])
%     figpath = [savepath,'/day3-6/boxplot/'];
%     oldfolder = cd(char(figpath));
%     saveas(h_boxplot,char(biomarkers{bio}),'fig')
%     saveas(h_boxplot,char(biomarkers{bio}),'svg')
%     saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
%     saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
%     cd(oldfolder)
%     close(h_boxplot)
%     close(h_errbar)
% end
%% plot trend
marker_set = '+o*xsdph';
h_trend = figure;
hold on;

brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
for brain_area = 1:8
%     errorbar(1:6,tDCSTrendMean(:,brain_area),tDCSTrendError(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',tDCS_color,'LineWidth',1,'LineStyle',':');
%     errorbar(1:6,tRNSTrendMean(:,brain_area),tRNSTrendError(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',tRNS_color,'LineWidth',1,'LineStyle',':');
%     errorbar(1:6,ShamTrendMean(:,brain_area),ShamTrendError(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',Sham_color,'LineWidth',1,'LineStyle',':');
    plot(1:6,tDCSTrendMean(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',tDCS_color,'LineWidth',1,'LineStyle',':','MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color);
    plot(1:6,tRNSTrendMean(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',tRNS_color,'LineWidth',1,'LineStyle',':','MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color);
    plot(1:6,ShamTrendMean(:,brain_area),'Marker',marker_set(brain_area),'MarkerSize',2,'Color',Sham_color,'LineWidth',1,'LineStyle',':','MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color);
end
xticks(1:6)
xticklabels({'Day1','Day2-6','Day7-12','Transfer#1','FollowUp','Transfer#2'})
xtickangle(45)
ylabel('\muMol')
xlim([0.5 6.5])
set(gca,'FontSize',9)
box off
set(h_trend, 'Position',  [81   210   435   322])
legend('lPFC-tDCS','lPFC-tRNS','lPFC-Sham',...
    'mPFC-tDCS','mPFC-tRNS','mPFC-Sham',...
    'rPFC-tDCS','rPFC-tRNS','rPFC-Sham',...
    'llM1-tDCS','llM1-tRNS','llM1-Sham',...
    'lmM1-tDCS','lmM1-tRNS','lmM1-Sham',...
    'rmM1-tDCS','rmM1-tRNS','rmM1-Sham',...
    'rlM1-tDCS','rlM1-tRNS','rlM1-Sham',...
    'SMA-tDCS','SMA-tRNS','SMA-Sham',...
    'location','northeastoutside','fontsize',9)
set(gca, 'FontName', 'helvetica')
fclose(ANOVA_file);

%% plot trend
h_trend = figure;
hold on;
ShamTrendMean_mean = mean(ShamTrendMean,2);
ShamTrendMean_std = std(ShamTrendMean,0,2);
errorbar(1:6,ShamTrendMean_mean,ShamTrendMean_std,'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
tDCSTrendMean_mean = mean(tDCSTrendMean,2);
tDCSTrendMean_std = std(tDCSTrendMean,0,2);
errorbar(1:6,tDCSTrendMean_mean,tDCSTrendMean_std,'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
tRNSTrendMean_mean = mean(tRNSTrendMean,2);
tRNSTrendMean_std = std(tRNSTrendMean,0,2);
errorbar(1:6,tRNSTrendMean_mean,tRNSTrendMean_std,'Marker','o','MarkerSize',2,'Color',tRNS_color,'LineWidth',line_width,'MarkerEdgeColor',tRNS_color,'MarkerFaceColor',tRNS_color,'capsize',1);

xticks(1:6)
xticklabels({'Day1','Day2-6','Day7-12','Transfer#1','FollowUp','Transfer#2'})
xtickangle(45)
ylabel('\muMol')
xlim([0.5 6.5])
set(gca,'FontSize',9)
box off
set(h_trend, 'Position',  [81   414   156   118])
set(gca, 'FontName', 'helvetica')