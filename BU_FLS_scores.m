clear all
close all
clc

%% pilot study data and sig test
Study_name = 'Pilot_study';
fprintf('%s:\n',Study_name)
XLS_filename = '..\Raw data\data collection form 2.xlsx';
SHEET = 'Pilot Study';
RANGE = 'A3:E279';
[NUM,TXT,RAW]=xlsread(XLS_filename,SHEET,RANGE);
% subject P9 did one more practice
NUM(209,:) = [];
time = NUM(73:end,1);
error = NUM(73:end,2);
score = NUM(73:end,3);
time = reshape(time,[34,6]);
error = reshape(error,[34,6]);
score = reshape(score,[34,6]);
% delete the first 10 practice trials
time(1:10,:) = [];
error(1:10,:) = [];
score(1:10,:) = [];
% get the stim order
XLS_filename = '..\Raw data\data collection form 2.xlsx';
SHEET = 'PS-stim-order';
RANGE = 'A1:B9';
[NUM,TXT,RAW]=xlsread(XLS_filename,SHEET,RANGE);
% change the order to [tDCS, tRNS, Sham]
for i = 4:length(TXT)
    stim_code = TXT{i,2};
    if stim_code == '231'
        time(:,i-3) = time([17:end,1:8,9:16],i-3);
        error(:,i-3) = error([17:end,1:8,9:16],i-3);
        score(:,i-3) = score([17:end,1:8,9:16],i-3);
    else
        time(:,i-3) = time([1:8,17:end,9:16],i-3);
        error(:,i-3) = error([1:8,17:end,9:16],i-3);
        score(:,i-3) = score([1:8,17:end,9:16],i-3);
    end
end
Data = {score,time,error.*36/100};
% plot boxplot
Para_list = {'Score','Time (s)','Error (cm^2)'};
Stim_list = {'tDCS','tRNS','Sham'};
sw_p_value = zeros(length(Para_list),length(Stim_list));
ad_p_value = zeros(length(Para_list),length(Stim_list));
t_test_value = zeros(length(Para_list),length(Stim_list));
ylim_list = [120 300;50 200; 0 8];
figure()
for i = 1:length(Para_list)
    subplot(1,3,i)
    Para = Para_list{i};
    fprintf('%s:\n',Para);
    data = Data{i};
    
    tDCSbefore  =   data(1:4,:);
    tDCSafter   =   data(5:8,:);
    tRNSbefore  =   data(9:12,:);
    tRNSafter   =   data(13:16,:);
    Shambefore  =   data(17:20,:);
    Shamafter   =   data(21:24,:);
    
    tDCSbefore  =   reshape(tDCSbefore, [24,1]);
    tDCSafter   =   reshape(tDCSafter,  [24,1]);
    tRNSbefore  =   reshape(tRNSbefore, [24,1]);
    tRNSafter   =   reshape(tRNSafter,  [24,1]);
    Shambefore  =   reshape(Shambefore, [24,1]);
    Shamafter   =   reshape(Shamafter,  [24,1]);
    
    Data_joined =   [tDCSbefore,tDCSafter,tRNSbefore,tRNSafter,Shambefore,Shamafter];
    box_plot_pilot(Data_joined,Stim_list,Para,ylim_list(i,:));
    
    if i == 1 % score
        tail = 'right';
    elseif i == 2 %time
        tail = 'left';
    else% error
        tail = 'left';
    end
    for j = 1:3
        Stim = Stim_list{j};
        databefore          =   Data_joined(:,j*2-1);
        dataafter           =   Data_joined(:,j*2);
        [sw, ad, t_test, signrank]     =   sig_test(databefore, dataafter, tail);
        sw_p_value(i,j)     =   sw;
        ad_p_value(i,j)     =   ad;
        % for sample size < 50, sw test is recommended
        % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3693611/
        if sw > 0.01
            t_test_value(i,j)   =   t_test;
        else
            t_test_value(i,j)   =   signrank;
        end
        fprintf('%s: sw_p = %.3f\t ad_p = %.3f:\t sig_p = %.3f:\n',Stim,sw,ad,t_test_value(i,j));
    end
end
set(gcf,'Position',[500 500 850 250])

saveas(gcf,'..\Results\Figures\Raw\Pilot_study_boxplot.svg')
save(['..\Results\Tables\',Study_name,'_swtest.txt'], 'sw_p_value',  '-ascii')
save(['..\Results\Tables\',Study_name,'_adtest.txt'], 'ad_p_value',  '-ascii')
save(['..\Results\Tables\',Study_name,'_sigtest.txt'], 't_test_value',  '-ascii')
%% Study #1 data and sig test
Study_name = 'Study_1';
fprintf('\n\n%s:\n',Study_name)
XLS_filename = '..\Raw data\data collection form 2.xlsx';
SHEET = 'Study 1';
RANGE = 'A3:E314';
[NUM,TXT,RAW]=xlsread(XLS_filename,SHEET,RANGE);
% subject P9 did one more practice
% NUM(209,:) = [];
time = NUM(1:end,1);
error = NUM(1:end,2);
score = NUM(1:end,3);
time = reshape(time,[26,12]);
error = reshape(error,[26,12]);
score = reshape(score,[26,12]);
% delete the first 10 practice trials
time(1:10,:) = [];
error(1:10,:) = [];
score(1:10,:) = [];
% get the stim order
XLS_filename = '..\Raw data\data collection form 2.xlsx';
SHEET = 'S1-stim-order';
RANGE = 'A1:B12';
[NUM,TXT,RAW]=xlsread(XLS_filename,SHEET);
% change the order to [tDCS, tRNS, Sham]
for i = 1:length(TXT)
    stim_code = TXT{i,2};
    if stim_code == '32'
        time(:,i) = time([9:16,1:8],i);
        error(:,i) = error([9:16,1:8],i);
        score(:,i) = score([9:16,1:8],i);
    end
end
Data = {score, time,error.*36/100,};
% plot boxplot
Para_list = {'Score','Time (s)','Error (cm^2)'};
Stim_list = {'tRNS','Sham'};
sw_p_value = zeros(length(Para_list),length(Stim_list));
ad_p_value = zeros(length(Para_list),length(Stim_list));
t_test_value = zeros(length(Para_list),length(Stim_list));
ylim_list = [50 300;0 250; 0 8];
figure()
% for i = 1:length(Para_list)
for i = 2:2
    subplot(1,3,i)
    Para = Para_list{i};
    fprintf('%s:\n',Para);
    data = Data{i};
    
    tRNSbefore  =   data(1:4,:);
    tRNSafter   =   data(5:8,:);
    Shambefore  =   data(9:12,:);
    Shamafter   =   data(13:16,:);
    
    tRNSbefore  =   reshape(tRNSbefore, [],1);
    tRNSafter   =   reshape(tRNSafter,  [],1);
    Shambefore  =   reshape(Shambefore, [],1);
    Shamafter   =   reshape(Shamafter,  [],1);
    
    Data_joined =   [tRNSbefore,tRNSafter,Shambefore,Shamafter];
    box_plot_study1(Data_joined,Stim_list,Para,ylim_list(i,:));
    
    if i == 1 % score
        tail = 'right';
    elseif i == 2 %time
        tail = 'left';
    else% error
        tail = 'left';
    end
    for j = 1:length(Stim_list)
        Stim = Stim_list{j};
        databefore              =   Data_joined(:,j*2-1);
        dataafter               =   Data_joined(:,j*2);
        [sw, ad, t_test, signrank]     =   sig_test(databefore, dataafter, tail);
        sw_p_value(i,j)     =   sw;
        ad_p_value(i,j)     =   ad;
        if sw > 0.01
            t_test_value(i,j)   =   t_test;
        else
            t_test_value(i,j)   =   signrank;
        end
        fprintf('%s: sw_p = %.3f\t ad_p = %.3f:\t sig_p = %.3f:\n',Stim,sw,ad,t_test_value(i,j));
    end
end
set(gcf,'Position',[500 100 850 250])
saveas(gcf,'..\Results\Figures\Raw\Study_1_boxplot.svg')
save(['..\Results\Tables\',Study_name,'_swtest.txt'], 'sw_p_value',  '-ascii')
save(['..\Results\Tables\',Study_name,'_adtest.txt'], 'ad_p_value',  '-ascii')
save(['..\Results\Tables\',Study_name,'_sigtest.txt'], 't_test_value',  '-ascii')
% 
% 
% figure()
% Para_list = {'time','error','score'};
% Stim_list = {'tRNS','Sham'};
% sw_p_value = zeros(2,3);
% ad_p_value = zeros(2,3);
% t_test_value = zeros(2,3);
% for i = 1:length(Stim_list)
%     Stim = Stim_list{i};
%     for j = 1:length(Data)
%         subplot(2,3,(i-1)*3+j)
%         Para = Para_list{i};
%         data = Data{j};
%         data_before = data(((i-1)*8+1):((i-1)*8+4),:);
%         data_after = data(((i-1)*8+5):i*8,:);
%         data_before = reshape(data_before,[48,1]);
%         data_after = reshape(data_after,[48,1]);
%         boxplot([data_before,data_after],'Labels',{'before','after'})
%         [~, sw_p, W] = swtest(data_before - data_after, 0.05);
%         sw_p_value(i,j) = sw_p;
%         [~,ad_p]  = adtest(data_before - data_after);
%         ad_p_value(i,j) = ad_p;
%         if j == 1
%             tail = 'right';
%             ylim([20 200])
%         elseif j == 2
%             tail = 'left';
%             ylim([0 20])
%         else
%             tail = 'right';
%             ylim([70 270])
%             yticks([100 150 200 250])
%         end
%         if sw_p > 0.05 && ad_p > 0.05
%             [~,p] = ttest(data_after,data_before,'tail',tail);
%         else
%             p = signrank(data_after,data_before,'tail',tail);
%         end
%         t_test_value(i,j) = p;
%     end
% end
% set(gcf,'Position',[100 100 550 250])
% disp('sw test:')
% disp(sw_p_value)
% disp('ad test:')
% disp(ad_p_value)
% disp('t test:')
% disp(t_test_value)
% saveas(gcf,'..\Results\Figures\Raw\Study_1_boxplot.svg')
% save('..\Results\Tables\Study_1_swtest.txt', 'sw_p_value',  '-ascii')
% save('..\Results\Tables\Study_1_adtest.txt', 'ad_p_value',  '-ascii')


%% Study #2 data
XLS_filename = '..\Raw data\data collection form 2.xlsx';
SHEET = 'Study 2';
RANGE = 'A3:I94';
[NUM,TXT,RAW]=xlsread(XLS_filename,SHEET,RANGE);
Subj_list = {'L2'};
n = length(Subj_list);
m = length(NUM);
figure()
plot(NUM(1:87,8),'b.')
set(gcf,'Position',[100 100 550 250])
ylim([0 300])
% for i = 1:n
%     Subj = Subj_list{i};
%     
% end
%% functions
function box_plot_pilot(data,Stim_list,Para,ylimvalue)

positions = [2 2.25 2.75 3 3.5 3.75];
boxplot(data,'positions',positions,'colors','k');
set(gca,'xtick',[ 2.15 2.90 3.65])
set(gca,'xticklabel',Stim_list)
% set(gca,'xlim',[1.75 4.5])
color = ['r', 'w', 'r', 'w', 'r', 'w'];
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.4);
end
c = get(gca, 'Children');
set(gca,'FontName','Times New Roman','fontsize',11); 
hleg1 = legalpha(c(1:2), 'Before', 'After','location','northeast','fontsize',8);

% legend boxoff
ylabel(Para)
ylim(ylimvalue)
axis square
end
function [sw_p, ad_p, t_test_p, signrank_p] = sig_test(data_before, data_after,tail)
[~, sw_p, ~]        =   swtest(data_before - data_after, 0.05);
[~,ad_p]            =   adtest(data_before - data_after);
[~,t_test_p]        =   ttest(data_after,data_before,'tail',tail);
signrank_p          =   signrank(data_after,data_before,'tail',tail);
end
function box_plot_study1(data,Stim_list,Para,ylimvalue)

positions = [2 2.25 2.75 3];
boxplot(data,'positions',positions,'colors','k');
set(gca,'xtick',[ 2.15 2.90])
set(gca,'xticklabel',Stim_list)
% set(gca,'xlim',[1.75 4.5])
color = ['r', 'w', 'r', 'w'];
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.4);
end
c = get(gca, 'Children');
set(gca,'FontName','Times New Roman','fontsize',11); 
hleg1 = legalpha(c(1:2), 'Before', 'After','location','northeast','fontsize',8);

% legend boxoff
ylabel(Para)
ylim(ylimvalue)
axis square
end