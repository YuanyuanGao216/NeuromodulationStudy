function sig_Hb(MeanHbMatrix,stage,savepath)

define_colors
filename = [savepath,'/brain_sig.txt'];
ANOVA_file = fopen(filename,'a');
line_width = 0.5;
brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
brain_channels = [2,2,2,5,4,4,5,4];
biomarkers = {'HbO','HbR'};

if strcmp(stage,'transfer')
    trial_no = 2;
else
    trial_no = 1;
end
for t = 1:trial_no
    if strcmp(stage,'transfer')
        fprintf(ANOVA_file,'Transfer #%d:\n',t);
    elseif strcmp(stage,'day2-6')
        fprintf(ANOVA_file,'Day 2-6:\n');
    elseif strcmp(stage,'day7-12')
        fprintf(ANOVA_file,'Day 7-12:\n');
    elseif strcmp(stage,'day1')
        fprintf(ANOVA_file,'Day 1:\n');
    elseif strcmp(stage,'follow')
        fprintf(ANOVA_file,'FollowUp:\n');
    end
    for bio = 1:1
        fprintf(ANOVA_file,'Bio #%s:\n',string(biomarkers{bio}));
        h_errbar = figure('name', stage );
        hold on
        for brain_area = 1:length(brain_areas)
            channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            if strcmp(stage,'transfer')
                data = MeanHbMatrix.Transfer(:,:,t,:,bio,channels);
            elseif strcmp(stage,'day2-6')
                data = MeanHbMatrix.Train(:,:,2:6,:,bio,channels);
            elseif strcmp(stage,'day7-12')
                data = MeanHbMatrix.Train(:,:,7:12,:,bio,channels);
            elseif strcmp(stage,'day1')
                data = MeanHbMatrix.Train(:,:,1,:,bio,channels);
            elseif strcmp(stage,'follow')
                data = MeanHbMatrix.Follow(:,:,:,:,bio,channels);
            end
            channel_mean = nanmean(data,6).*1e6;
            tDCS = reshape(channel_mean(1,:,:,:),[],1);
            Sham = reshape(channel_mean(2,:,:,:),[],1);
            [h_Sham,~] = kstest(Sham);
            [h_tDCS,~] = kstest(tDCS);
            if h_Sham == 0 && h_tDCS == 0 % if they are all normally distrubuted
                [h,p] = ttest(Sham,tDCS);
            else
                [p,h] = ranksum(Sham,tDCS);
            end
            fprintf(ANOVA_file,'Brain %s \tp = %.3f\n',brain_areas{brain_area},p);
           
            % errbar
            figure(h_errbar)
            x = [-0.2 0 0.2]+ brain_area;
            errorbar(x(1),nanmean(tDCS),2*1.96*nanstd(tDCS)./sqrt(sum(~isnan(tDCS))),'Marker','o','MarkerSize',2,'Color',tDCS_color,'LineWidth',line_width,'MarkerEdgeColor',tDCS_color,'MarkerFaceColor',tDCS_color,'capsize',1);
            errorbar(x(2),nanmean(Sham),2*1.96*nanstd(Sham)./sqrt(sum(~isnan(Sham))),'Marker','o','MarkerSize',2,'Color',Sham_color,'LineWidth',line_width,'MarkerEdgeColor',Sham_color,'MarkerFaceColor',Sham_color,'capsize',1);
        end
        % edit error bar plot
%         figure(h_errbar)
%         if strcmp(stage,'day2-6')
%             plot([3 4 6],[0.35 0.35 0.35],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
%         elseif strcmp(stage,'day7-12')
%             plot([1 3 7],[0.4 0.4 0.4],'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
%             plot([2 4 7 8]-0.2,[0.4 0.4 0.4 0.4],'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
%         elseif strcmp(stage,'follow')
%             plot(7,0.8,'*','color',tRNS_color,'HandleVisibility','off','markersize',4)
%             plot(6-0.2,0.8,'*','color',tDCS_color,'HandleVisibility','off','markersize',4)
%         end
        xticks(1:8)
        xticklabels(brain_areas)
        xtickangle(90)
        ylabel('\muMol')
        if strcmp(stage,'transfer')
            ylim([-2 2])
            figpath = [savepath,'/transfer',num2str(t),'/boxplot/'];
        elseif strcmp(stage,'day2-6')
            figpath = [savepath,'/day2-6/boxplot/'];
        elseif strcmp(stage,'day7-12')
            figpath = [savepath,'/day7-12/boxplot/'];
        elseif strcmp(stage,'day1')
            figpath = [savepath,'/day1/boxplot/'];
        elseif strcmp(stage,'follow')
            ylim([-1.7 1])
            figpath = [savepath,'/follow/boxplot/'];
        end
        xlim([0.5 8.5])
        set(gca,'FontSize',9)
        set(gca, 'FontName', 'helvetica')
        box off
        set(h_errbar, 'Position',  [100 100 250   120])
        
        oldfolder = cd(char(figpath));
        saveas(h_errbar,['errbar',char(biomarkers{bio})],'fig')
        saveas(h_errbar,['errbar',char(biomarkers{bio})],'svg')
        cd(oldfolder)
    end
end