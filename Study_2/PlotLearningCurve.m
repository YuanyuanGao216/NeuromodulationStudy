function PlotLearningCurve(DataMatrix,delete_unskilled)
% Stim_array = {'tDCS','tRNS','Sham'};
f = fieldnames(DataMatrix)';
f{2,1} = {};
Data_by_Sub = struct(f{:});

c = rand(21,3);


j = 1;
if delete_unskilled == 1
    for i = 1:length(DataMatrix)
        if DataMatrix(i).skilled  == 1
            Data_by_Sub(j) = DataMatrix(i);
            j = j + 1;
        end
    end
else
    Data_by_Sub = DataMatrix;
end

Sub_array = cell(length(Data_by_Sub),1);
for i = 1:length(Data_by_Sub)
    Sub_array(i) = Data_by_Sub(i).name;
end


f_LC_time = figure;
f_LC_error = figure;
f_LC_score = figure;

f_LC_time_by_stim = figure;
f_LC_error_by_stim = figure;
f_LC_score_by_stim = figure;
for i = 1:length(Data_by_Sub)
    Data = Data_by_Sub(i).TrainData;
    time = Data(:,4);
    error = Data(:,5);
    score = Data(:,6);
    
    TransferData = Data_by_Sub(i).TransferData;
    time_t = TransferData;
    FollowUpData = Data_by_Sub(i).FollowUpData;
    time_f = FollowUpData(:,1);
    error_f = FollowUpData(:,2);
    score_f = FollowUpData(:,3);
    score(score<0) = 0;
    
    code = Data_by_Sub(i).code;
    
    figure(f_LC_time)
    plot(time,'color',c(i,:),'LineStyle','-','Marker','o')
    hold on
    plot([110,115,120,125,130],[time_t(1);time_f;time_t(2)],...
        'color',c(i,:),'LineStyle','none','Marker','o')
    hold on
    
    figure(f_LC_error)
    plot(error,'color',c(i,:),'LineStyle','-','Marker','o')
    hold on
    plot([115,120,125],error_f,...
        'color',c(i,:),'LineStyle','-','Marker','o')
    hold on
    
    figure(f_LC_score)
    plot(score,'color',c(i,:),'LineStyle','-','Marker','o')
    plot([115,120,125],score_f,...
        'color',c(i,:),'LineStyle','-','Marker','o')
    hold on
    
    if strcmp(code,'A')
        color_code = 'b';
        display_name = 'tDCS';
    elseif strcmp(code,'B')
        color_code = 'r';
        display_name = 'tRNS';
    elseif strcmp(code,'C')
        color_code = 'k';
        display_name = 'Sham';
    end
    figure(f_LC_time_by_stim)
    plot(time,'color',color_code,'LineStyle','-','Marker','o')
    hold on
    plot([110,115,120,125,130],[time_t(1);time_f;time_t(2)],...
        'color',color_code,'LineStyle','none','Marker','o')
    hold on
    
    figure(f_LC_error_by_stim)
    plot(error,'color',color_code,'LineStyle','-','Marker','o')
    hold on
    plot([115,120,125],error_f,...
        'color',color_code,'LineStyle','-','Marker','o')
    hold on
    
    figure(f_LC_score_by_stim)
    plot(score,'color',color_code,'LineStyle','-','Marker','o','DisplayName',display_name)
    plot([115,120,125],score_f,...
        'color',color_code,'LineStyle','-','Marker','o')
    hold on
end

figure(f_LC_time)
set(gca,'FontSize',9)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Time')
xticks([1:20:110,110,115,120,125,130])
xticklabels({'1','21','41','61','81','101','T1','F1','F2','F3','T2'})
xtickangle(45)
legend(Sub_array,'Location','northeastoutside')

figure(f_LC_error)
set(gca,'FontSize',9)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Error')
xticks([1:20:110,115,120,125])
xticklabels({'1','21','41','61','81','101','F1','F2','F3'})
xtickangle(45)
legend(Sub_array,'Location','northeastoutside')

figure(f_LC_score)
set(gca,'FontSize',9)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Score')
xticks([1:20:110,115,120,125])
xticklabels({'1','21','41','61','81','101','F1','F2','F3'})
xtickangle(45)
legend(Sub_array,'Location','northeastoutside')

figure(f_LC_time_by_stim)
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Time')
xticks([1:20:110,110,115,120,125,130])
xticklabels({'1','21','41','61','81','101','T1','F1','F2','F3','T2'})
xtickangle(45)

figure(f_LC_error_by_stim)
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Error')
xticks([1:20:110,115,120,125])
xticklabels({'1','21','41','61','81','101','F1','F2','F3'})
xtickangle(45)

figure(f_LC_score_by_stim)
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
title('Score')
xticks([1:20:110,115,120,125])
xticklabels({'1','21','41','61','81','101','F1','F2','F3'})
xtickangle(45)