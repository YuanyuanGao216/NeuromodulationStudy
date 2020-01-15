function SigTest(DataMatrix,delete_unskilled)

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
N = 0;
for i = 1:length(Data_by_Sub)
    N = N + size(Data_by_Sub(i).TrainData,1);
end
time = zeros(N,1);
error = zeros(N,1);
score = zeros(N,1);
days = zeros(N,1);
stim = cell(N,1);
subj = cell(N,1);
j = 1;
FollowUpMatrix = zeros(length(Data_by_Sub)*3,3);
FollowUpCode = cell(length(Data_by_Sub)*3,1);
TransferMatrix = zeros(length(Data_by_Sub),2);
TransferCode = cell(length(Data_by_Sub),1);
for i = 1:length(Data_by_Sub)
    TrainData = Data_by_Sub(i).TrainData;
    
    n = size(TrainData,1);
    time(j:j+n-1) = TrainData(:,4);
    error(j:j+n-1) = TrainData(:,5);
    score(j:j+n-1) = TrainData(:,6);
    days(j:j+n-1) = TrainData(:,1);
    if string(Data_by_Sub(i).code) == 'C'
        stim_code = 'Sham';
    elseif string(Data_by_Sub(i).code) == 'A'
        stim_code = 'tDCS';
    else
        stim_code = 'tRNS';
    end
    stim(j:j+n-1) = repmat({stim_code},n,1);
    subj(j:j+n-1) = repmat(Data_by_Sub(i).name,n,1);
    j = j+n;
    
    FollowUpData = Data_by_Sub(i).FollowUpData;
    FollowUpMatrix((i-1)*3+1:i*3,:) = FollowUpData;
    FollowUpCode((i-1)*3+1:i*3,1) = repmat({stim_code},3,1);
    
    TransferData = Data_by_Sub(i).TransferData;
    TransferMatrix(i,:) = TransferData';
    TransferCode(i,1) = {stim_code};
end

prompt = 'Which var? 1 for time, 2 for error, 3 for score ';
var_code = input(prompt);
if var_code ==1
    var_type = 'time';
elseif var_code == 2
    var_type = 'error';
elseif var_code == 3
    var_type = 'score';
end
exp_str = ['dep_var = ' var_type ';'];
eval(exp_str);
ifContinue = 1;
while ifContinue == 1
    prompt = 'Which day? ';
    d = input(prompt);
    if d<13
        fprintf('Day #%d:\t',d)
        index = find(days == d);
        X = dep_var(index);
        Group = stim(index);
        title_string = sprintf('Day #%d %s',d,var_type);
    elseif d == 13
        fprintf('FollowUp:\t')
        X = FollowUpMatrix(:,var_code);
        Group = FollowUpCode;
        title_string = sprintf('Follow Up %s',var_type);
    elseif d == 14
        fprintf('Transfer:\t')
        X = FollowUpMatrix(:,1);
        Group = FollowUpCode;
        title_string = sprintf('Transfer time');
    elseif d == 15
        fprintf('Transfer:\t')
        X = FollowUpMatrix(:,2);
        Group = FollowUpCode;
        title_string = sprintf('Transfer time');
    end
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
    axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
    xt = get(gca, 'XTick');
    
    
    alpha = 0.05;
    post_hoc_p = c(:,6);
    for i = length(post_hoc_p):-1:1
        p_value = c(i,6);
        if p_value < alpha
            if i == 1
                axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
                plot(xt([1 3]), [1 1]*max(yt)*1.5, '-k')
                text(xt(2)-0.3,max(yt)*1.6,sprintf('p=%.3f%s',p_value,'*'),'FontSize',12)
            elseif i == 2
                axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
                plot(xt([2 3]), [1 1]*max(yt)*1.3, '-k')
                text((xt(2)+xt(3))/2-0.3,max(yt)*1.4,sprintf('p=%.3f%s',p_value,'*'),'FontSize',12)
            elseif i == 3
                axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
                plot(xt([1 2]), [1 1]*max(yt)*1.2, '-k')
                text((xt(1)+xt(2))/2-0.3,max(yt)*1.3,sprintf('p=%.3f%s',p_value,'*'),'FontSize',12)
            end
        end
    end

    
    hold off
    title(title_string)
    set(gcf, 'Position',  [100, 100, 250, 200])
    set(gca,'FontSize',12)
    
    ifContinue = input('Continue? ');
    close all
    close all hidden
end