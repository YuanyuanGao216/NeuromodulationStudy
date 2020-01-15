function PlotLearningCurveByDay(DataMatrix,delete_unskilled)

f = fieldnames(DataMatrix)';
f{2,1} = {};
Data_by_Sub = struct(f{:});

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


f_time = figure;
f_error = figure;
f_score = figure;
x_positions = [1:12,15];
tDCS_TIME = nan(13,7*11);
tRNS_TIME = nan(13,7*11);
Sham_TIME = nan(13,7*11);
tDCS_ERROR = nan(13,7*11);
tRNS_ERROR = nan(13,7*11);
Sham_ERROR = nan(13,7*11);
tDCS_SCORE = nan(13,7*11);
tRNS_SCORE = nan(13,7*11);
Sham_SCORE = nan(13,7*11);
for d = 1:13
    tDCS_time = [];
    tRNS_time = [];
    Sham_time = [];
    tDCS_error = [];
    tRNS_error = [];
    Sham_error = [];
    tDCS_score = [];
    tRNS_score = [];
    Sham_score = [];
    for i = 1:length(Data_by_Sub)
        data = Data_by_Sub(i).TrainData;
        code = Data_by_Sub(i).code;
        f_data = Data_by_Sub(i).FollowUpData;
        if d ~=13
            data = data(data(:,1)==d,:);
            if strcmp(code, 'A')
                tDCS_time = [tDCS_time;data(:,4)];
                tDCS_error = [tDCS_error;data(:,5)];
                tDCS_score = [tDCS_score;data(:,6)];
            elseif strcmp(code, 'B')
                tRNS_time = [tRNS_time;data(:,4)];
                tRNS_error = [tRNS_error;data(:,5)];
                tRNS_score = [tRNS_score;data(:,6)];
            elseif strcmp(code, 'C')
                Sham_time = [Sham_time;data(:,4)];
                Sham_error = [Sham_error;data(:,5)];
                Sham_score = [Sham_score;data(:,6)];
    %             if size(data(:,6),1) > 10
    %                 fprintf('%d\n',i)
    %             end
            end
        else
            if strcmp(code, 'A')
                tDCS_time = [tDCS_time;f_data(:,1)];
                tDCS_error = [tDCS_error;f_data(:,2)];
                tDCS_score = [tDCS_score;f_data(:,3)];
            elseif strcmp(code, 'B')
                tRNS_time = [tRNS_time;f_data(:,1)];
                tRNS_error = [tRNS_error;f_data(:,2)];
                tRNS_score = [tRNS_score;f_data(:,3)];
            elseif strcmp(code, 'C')
                Sham_time = [Sham_time;f_data(:,1)];
                Sham_error = [Sham_error;f_data(:,2)];
                Sham_score = [Sham_score;f_data(:,3)];
            end
        end
    end
    tDCS_TIME(d,1:size(tDCS_time,1)) = tDCS_time;
    tRNS_TIME(d,1:size(tRNS_time,1)) = tRNS_time;
    Sham_TIME(d,1:size(Sham_time,1)) = Sham_time;
    tDCS_ERROR(d,1:size(tDCS_error,1)) = tDCS_error;
    tRNS_ERROR(d,1:size(tRNS_error,1)) = tRNS_error;
    Sham_ERROR(d,1:size(Sham_error,1)) = Sham_error;
    tDCS_SCORE(d,1:size(tDCS_score,1)) = tDCS_score;
    tRNS_SCORE(d,1:size(tRNS_score,1)) = tRNS_score;
    Sham_SCORE(d,1:size(Sham_score,1)) = Sham_score;
end
figure(f_time)
hold on
boxplot(tDCS_TIME','positions',x_positions-0.25,'width',0.18,'notch','off','color','b')
boxplot(tRNS_TIME','positions',x_positions,'width',0.18,'notch','off','color','r')
boxplot(Sham_TIME','positions',x_positions+0.25,'width',0.18,'notch','off','color','k')
title('Time')
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
x_lim = xlim;
xlim([0,x_lim(2)])

figure(f_error)
hold on
boxplot(tDCS_ERROR','positions',x_positions-0.25,'width',0.18,'notch','off','color','b')
boxplot(tRNS_ERROR','positions',x_positions,'width',0.18,'notch','off','color','r')
boxplot(Sham_ERROR','positions',x_positions+0.25,'width',0.18,'notch','off','color','k')
title('Error')
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
x_lim = xlim;
xlim([0,x_lim(2)])

figure(f_score)
hold on
boxplot(tDCS_SCORE','positions',x_positions-0.25,'width',0.18,'notch','off','color','b')
boxplot(tRNS_SCORE','positions',x_positions,'width',0.18,'notch','off','color','r')
boxplot(Sham_SCORE','positions',x_positions+0.25,'width',0.18,'notch','off','color','k')
title('Score')
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 1000, 300])
x_lim = xlim;
xlim([0,x_lim(2)])

tDCS = [];
tRNS = [];
Sham = [];
for i = 1:length(Data_by_Sub)
    data = Data_by_Sub(i).TransferData;
    code = Data_by_Sub(i).code;
    if strcmp(code, 'A')
        tDCS = [tDCS,data];
    elseif strcmp(code, 'B')
        tRNS = [tRNS,data];
    elseif strcmp(code, 'C')
        Sham = [Sham,data];
    end
end

f_transfer = figure;
hold on
boxplot(tDCS','positions',[0.75 1.75],  'width',0.2,'notch','off','color','b')
boxplot(tRNS','positions',[1 2],        'width',0.2,'notch','off','color','r')
boxplot(Sham','positions',[1.25 2.25],  'width',0.2,'notch','off','color','k')
title('Transfer time')
set(gca,'FontSize',18)
set(gcf, 'Position',  [100, 100, 500, 300])
xlim([0 3])