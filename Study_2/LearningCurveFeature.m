function LearningCurveFeature(DataMatrix,delete_unskilled)

% OLS model:
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
N = length(Data_by_Sub);
LR = zeros(N,3);
StimCode = cell(N,1);
for i = 1:N
    Data = Data_by_Sub(i).TrainData;
    Time = Data(:,4);
    Error = Data(:,5);
    Score = Data(:,6);
%     Score = 300 - Score;
    LR_Time = OLSmodel(Time,'time');
    ts = sprintf('S%d time',i);
    title(ts);
    LR_Error = OLSmodel(Error,'error');
    ts = sprintf('S%d error',i);
    title(ts);
    LR_Score = OLSmodel(Score,'score');
    ts = sprintf('S%d score',i);
    title(ts);
    LR(i,:) = [LR_Time,LR_Error,LR_Score];
    if string(Data_by_Sub(i).code) == 'C'
        stim_code = 'Sham';
    elseif string(Data_by_Sub(i).code) == 'A'
        stim_code = 'tDCS';
    else
        stim_code = 'tRNS';
    end
    StimCode(i) = {stim_code};
end
for j = 1:3
    X = LR(:,j);
    Group = StimCode;
    [p,~,stats] = anova1(X,Group,'on');
    fprintf('Anova p = %.3f:\n',p)
    [c,m,h,nms] = multcompare(stats);
    display([nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))])
    figure
    hold on
    boxplot(X,Group,'GroupOrder',{'tDCS','tRNS','Sham'})
    hold on
    yt = get(gca, 'YTick');
    y_limits = ylim;
    xt = get(gca, 'XTick');
    
    alpha = 0.05;
    post_hoc_p = c(:,6);
    for i = 1:length(post_hoc_p)
        p_value = c(i,6);
        stim1 = string(nms(c(i,1)));
        stim2 = string(nms(c(i,2)));
        if p_value < alpha
            if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
                axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
            else
                axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
            end
            if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
                axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
                plot(xt([1 3]), [1 1]*max(yt)*1.5, '-k')
                text(xt(2)-0.3,max(yt)*1.6,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
            elseif (strcmp(stim1,'tRNS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tRNS')&& strcmp(stim1,'Sham'))
                axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
                plot(xt([2 3]), [1 1]*max(yt)*1.3, '-k')
                text((xt(2)+xt(3))/2-0.3,max(yt)*1.4,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
            elseif (strcmp(stim1,'tDCS')&& strcmp(stim2,'tRNS'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'tRNS'))
                axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
                plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k')
                text((xt(1)+xt(2))/2-0.3,max(yt)*1.2,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
            end
        end
    end


    hold off
    if j == 1
        title('time')
    elseif j == 2
        title('error')
    elseif j == 3
        title('score')
    end
    set(gcf, 'Position',  [100, 100, 250, 200])
    set(gca,'FontSize',12)
end

