function Plot_2nd_day(DataMatrix,delete_unskilled)
define_colors
Data_by_Sub = delete_sub(DataMatrix,delete_unskilled);

tDCSday1 = nan(7,1);
% tRNSday1 = nan(7,1);
Shamday1 = nan(7,1);
for day = 1:2
    tDCSday = nan(7,10);
    tRNSday = nan(7,10);
    Shamday = nan(7,10);
    j_tDCS = 1;
    j_tRNS = 1;
    j_Sham = 1;
    for i = 1:length(Data_by_Sub)
        traindata = Data_by_Sub(i).TrainData;
        code = Data_by_Sub(i).code{1};
        dayscore = traindata(traindata(:,1)==day,6);
        if length(dayscore)>10
            dayscore = dayscore(1:end-1);
        end
        if code == 'A'
            tDCSday(j_tDCS,1:size(dayscore,1)) = dayscore';
            j_tDCS = j_tDCS + 1;
        elseif code == 'C'
            Shamday(j_Sham,1:size(dayscore,1)) = dayscore';
            j_Sham = j_Sham + 1;
        else
            fprintf('there is a problem!\n')
        end
    end
    
    
    
    %  std( data ) / sqrt( length( data ))
    tDCSday(:,sum(~isnan(tDCSday))==0) = [];
    Shamday(:,sum(~isnan(Shamday))==0) = [];

    
    if day == 1
        tDCSday1 = tDCSday;
        Shamday1 = Shamday;
    end
    if day == 2
        figure
        hold on
        y1 = [nanmean(tDCSday1),nanmean(tDCSday)];
        y_e1 = [nanstd(tDCSday1)./sum(~isnan(tDCSday1)),nanstd(tDCSday)./sum(~isnan(tDCSday))];
        y3 = [nanmean(Shamday1),nanmean(Shamday)];
        y_e3 = [nanstd(Shamday1)./sum(~isnan(Shamday1)),nanstd(Shamday)./sum(~isnan(Shamday))];
        line_width = 1.0;
        errorbar(0,y1(1),y_e1(1),'color',tDCS_color, 'linewidth',line_width)
        errorbar(0,y3(1),y_e3(1),'color',Sham_color, 'linewidth',line_width)

        errorbar(1:size(tDCSday,2),y1(2:end),y_e1(2:end),'color',tDCS_color, 'linewidth',line_width)
        errorbar(1:size(Shamday,2),y3(2:end),y_e3(2:end),'color',Sham_color, 'linewidth',line_width)
        
        plot([0.5 0.5],[0 250],'k:')
        title_string = sprintf('day %d scores',day);
        title(title_string)
        xlabel('Trial number')
        ylabel('FLS score')
        legend('tDCS','Sham','location','northeastoutside')
        set(gca,'FontSize',14)
        box on
        set(gcf, 'Position',  [100, 100, 300, 230])
        xlim([-0.5 size(Shamday,2)+0.5])
    end
    
end