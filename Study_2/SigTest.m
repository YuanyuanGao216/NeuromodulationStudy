function SigTest(DataMatrix,delete_unskilled)

Data_by_Sub = delete_sub(DataMatrix,delete_unskilled);

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
FollowUp1 = zeros(length(Data_by_Sub),3);
FollowUp2 = zeros(length(Data_by_Sub),3);
FollowUp3 = zeros(length(Data_by_Sub),3);
FollowUpCode = cell(length(Data_by_Sub),1);
TransferMatrix = zeros(length(Data_by_Sub),2);
TransferCode = cell(length(Data_by_Sub),1);
for i = 1:length(Data_by_Sub)
    TrainData = Data_by_Sub(i).TrainData;
    
    n = size(TrainData,1);
    time(j:j+n-1) = TrainData(:,4);
    error(j:j+n-1) = TrainData(:,5)*36;
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
    FollowUp1(i,:) = FollowUpData(1,:);
    FollowUp2(i,:) = FollowUpData(2,:);
    FollowUp3(i,:) = FollowUpData(3,:);
    FollowUpCode(i,1) = {stim_code};
    
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

prompt = 'Which day? ';
d = input(prompt);
if d<13
    fprintf('Day #%d:\t',d)
    index = find(days == d);
    X = dep_var(index);
    Group = stim(index);
    title_string = sprintf('Day #%d %s',d,var_type);
elseif d == 131
    fprintf('FollowUp1:\t')
    X = FollowUp1(:,var_code);
    Group = FollowUpCode;
    title_string = sprintf('Follow Up 1 %s',var_type);
elseif d == 132
    fprintf('FollowUp2:\t')
    X = FollowUp2(:,var_code);
    Group = FollowUpCode;
    title_string = sprintf('Follow Up 2 %s',var_type);
elseif d == 133
    fprintf('FollowUp3:\t')
    X = FollowUp3(:,var_code);
    Group = FollowUpCode;
    title_string = sprintf('Follow Up 3 %s',var_type);
elseif d == 13
    fprintf('FollowUp:\t')
    X = [FollowUp1(:,var_code);FollowUp2(:,var_code);FollowUp3(:,var_code)];
    if var_code == 2
        X = X*36;
    end
    Group = repmat(FollowUpCode,3,1);
    title_string = sprintf('Follow Up %s',var_type);
    figure
    hold on
    plot(1*ones(length(X(strcmp(Group,'tDCS'))),1),X(strcmp(Group,'tDCS')),'b*')
    plot(2*ones(length(X(strcmp(Group,'tRNS'))),1),X(strcmp(Group,'tRNS')),'r*')
    plot(3*ones(length(X(strcmp(Group,'Sham'))),1),X(strcmp(Group,'Sham')),'k*')
    set(gcf, 'Position',  [100, 100, 250, 200])
    xticks(1:3)
    xticklabels({'tDCS','tRNS','Sham'})
    xtickangle(90)
    xlim([0.5 3.5])
    set(gca,'FontSize',12)
    title(title_string)
elseif d == 14
    fprintf('Transfer1:\t')
    X = TransferMatrix(:,1);
    Group = TransferCode;
    title_string = sprintf('Transfer#1 time');
    figure
    hold on
    plot(1*ones(length(X(strcmp(TransferCode,'tDCS'))),1),X(strcmp(TransferCode,'tDCS')),'b*')
    plot(2*ones(length(X(strcmp(TransferCode,'tRNS'))),1),X(strcmp(TransferCode,'tRNS')),'r*')
    plot(3*ones(length(X(strcmp(TransferCode,'Sham'))),1),X(strcmp(TransferCode,'Sham')),'k*')
    set(gcf, 'Position',  [100, 100, 250, 200])
    xticks(1:3)
    xticklabels({'tDCS','tRNS','Sham'})
    xlim([0.5 3.5])
    set(gca,'FontSize',12)
    title(title_string)
elseif d == 15
    fprintf('Transfer2:\t')
    X = TransferMatrix(:,2);
    Group = TransferCode;
    title_string = sprintf('Transfer#2 time');
    figure
    hold on
    plot(1*ones(length(X(strcmp(TransferCode,'tDCS'))),1),X(strcmp(TransferCode,'tDCS')),'b*')
    plot(2*ones(length(X(strcmp(TransferCode,'tRNS'))),1),X(strcmp(TransferCode,'tRNS')),'r*')
    plot(3*ones(length(X(strcmp(TransferCode,'Sham'))),1),X(strcmp(TransferCode,'Sham')),'k*')
    set(gcf, 'Position',  [100, 100, 250, 200])
    xticks(1:3)
    xticklabels({'tDCS','tRNS','Sham'})
    xlim([0.5 3.5])
    set(gca,'FontSize',12)
    title(title_string)
end
[p,~,stats] = anova1(X,Group,'on');
fprintf('Anova p = %.3f:\n',p)
[c,m,h,nms] = multcompare(stats);
display([nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))])
figure
hold on
boxplot(X,Group,'GroupOrder',{'tDCS','tRNS','Sham'},'colors','rbk','symbol','k.','outliersize',3)
xtickangle(45)
hold on
% yt = get(gca, 'YTick');
% y_limits = ylim;
% xt = get(gca, 'XTick');
% 
% 
% alpha = 0.05;
% post_hoc_p = c(:,6);
%     for i = 1:length(post_hoc_p)
%         p_value = c(i,6);
%         stim1 = string(nms(c(i,1)));
%         stim2 = string(nms(c(i,2)));
%         if p_value < alpha
%             if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
%                 axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
%             else
%                 axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
%             end
%             if (strcmp(stim1,'tDCS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'Sham'))
%                 axis([xlim    y_limits(1)  ceil(max(yt)*1.8)])
%                 plot(xt([1 3]), [1 1]*max(yt)*1.5, '-k')
%                 text(xt(2)-0.3,max(yt)*1.6,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
%             elseif (strcmp(stim1,'tRNS')&& strcmp(stim2,'Sham'))||(strcmp(stim2,'tRNS')&& strcmp(stim1,'Sham'))
%                 axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
%                 plot(xt([2 3]), [1 1]*max(yt)*1.3, '-k')
%                 text((xt(2)+xt(3))/2-0.3,max(yt)*1.4,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
%             elseif (strcmp(stim1,'tDCS')&& strcmp(stim2,'tRNS'))||(strcmp(stim2,'tDCS')&& strcmp(stim1,'tRNS'))
%                 axis([xlim    y_limits(1)  ceil(max(yt)*1.5)])
%                 plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k')
%                 text((xt(1)+xt(2))/2-0.3,max(yt)*1.2,sprintf('p=%.3f%s',p_value,'*'),'FontSize',10)
%             end
%         end
%     end


hold off
%     title(title_string)
ax1 = gca;
% ax1_old_pos=ax1.Position;
% Yscale = 0.8;
% ax1.Position=[ax1_old_pos(1)*Yscale ax1_old_pos(2) ax1_old_pos(3) ax1_old_pos(4)];
ax1.Position = [0.2,0.3,0.72,0.67];
set(gcf, 'Position',  [100   234    115    96])
set(gca,'FontSize',8)
set(gca, 'FontName', 'helvetica')

box off

%     ifContinue = input('Continue? ');
%     close all
%     close all hidden
