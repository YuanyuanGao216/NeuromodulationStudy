define_colors
delete_unskilled = 1;
unskilled = {'L2','L4','L5','L21'};
tDCS_subject = {'L4','L5','L7','L14','L15','L19','L22'};
tRNS_subject = {'L2','L9','L10','L13','L17','L21','L23'};
Sham_subject = {'L3','L6','L11','L18','L24','L25','L26'};

if ismac
    DataPath = '../../../raw_data';
else
    DataPath = '..\..\..\Raw_data';
end
DataFile = 'data collection form 2.xlsx';
if ismac
    filename = [DataPath, '/', DataFile];
else
    filename = [DataPath, '\', DataFile];
end

sheet = 'safety s2';
xlRange = 'A3:AE254';
[num,txt,raw] = xlsread(filename,sheet,xlRange);

data_tDCS = [];
data_tRNS = [];
data_Sham = [];
unskilled_label = zeros(size(num,1),1);
code_label = zeros(size(num,1),1);
for i = 1:size(num,1)
    name = txt(i);
    if any(strcmp(unskilled,name)) 
        unskilled_label(i) = 1;
    end
    if any(strcmp(tDCS_subject,name))
        code_label(i) = 1;
    elseif any(strcmp(tRNS_subject,name))
        code_label(i) = 2;
    elseif any(strcmp(Sham_subject,name))
        code_label(i) = 3;
    end
end
if delete_unskilled == 1
    num(find(unskilled_label),:) = [];
    code_label(find(unskilled_label),:) = [];
end

for i = 1:size(num,1)
    code = code_label(i);
    data = num(i,:);
    if data(1) ~= 1
        if code == 1
            data_tDCS = [data_tDCS; data];
        elseif code == 2
            data_tRNS = [data_tRNS; data];
        elseif code == 3
            data_Sham = [data_Sham; data];
        end
    end
end
tDCS_before = data_tDCS(:,2:15);
tDCS_after = data_tDCS(:,16:29);
tRNS_before = data_tRNS(:,2:15);
tRNS_after = data_tRNS(:,16:29);
Sham_before = data_Sham(:,2:15);
Sham_after = data_Sham(:,16:29);

tDCS_change = tDCS_after - tDCS_before;
tRNS_change = tRNS_after - tRNS_before;
Sham_change = Sham_after - Sham_before;

figure
hold on
x = 14:-1:1;
% y = [mean(tDCS_change,1);mean(tRNS_change,1);mean(Sham_change,1)];
y = [mean(tDCS_change,1);mean(Sham_change,1)];

barh(x-0.2,mean(tDCS_change,1),0.4,'facecolor',Sham_color);
barh(x+0.2,mean(Sham_change,1),0.4,'facecolor',tDCS_color);

legend('tDCS','Sham','location','southeast')
yticks(1:14)
yticklabels(fliplr({'1. Headache','2. Neck Pain','3. Back Pain',...
    '4. Blurred Vision','5.  Scalp Irritation','6. Tingling',...
    '7. Itching','8. Increased Heart Rate','9. Burning Sensation',...
    '10. Hot Flash','11. Dizziness','12. Acute Mood Change',...
    '13. Fatigue','14. Anxiety'}))
set(gca,'FontSize',12)
set(gca, 'FontName', 'Arial')
xlabel('Change in scores')
set(gcf, 'Position',  [360   423   395   275])

%% demo

sheet = 'Demographics S2';
xlRange = 'A2:D22';
[num,txt,raw] = xlsread(filename,sheet,xlRange);

unskilled_label = zeros(size(num,1),1);
code_label = zeros(size(num,1),1);
for i = 1:size(num,1)
    name = txt(i,1);
    if any(strcmp(unskilled,name)) 
        unskilled_label(i) = 1;
    end
    if any(strcmp(tDCS_subject,name))
        code_label(i) = 1;
    elseif any(strcmp(tRNS_subject,name))
        code_label(i) = 2;
    elseif any(strcmp(Sham_subject,name))
        code_label(i) = 3;
    end
end
if delete_unskilled == 1
    num(find(unskilled_label),:) = [];
    txt(find(unskilled_label),:) = [];
    code_label(find(unskilled_label),:) = [];
end

age_tDCS = [];
age_tRNS = [];
age_Sham = [];

F_tDCS = 0;
F_tRNS = 0;
F_Sham = 0;

R_tDCS = 0;
R_tRNS = 0;
R_Sham = 0;

n_tDCS = 0;
n_tRNS = 0;
n_Sham = 0;

for i = 1:size(num,1)
    code = code_label(i);
    age = num(i,1);
    F = txt(i,3);
    if strcmp(F,'F')
        F_code = 1;
    else
        F_code = 0;
    end
    R = txt(i,4);
    if strcmp(R,'R')
        R_code = 1;
    else
        R_code = 0;
    end
    if code == 1
        n_tDCS = n_tDCS +1;
        age_tDCS = [age_tDCS;age];
        F_tDCS = F_tDCS + F_code;
        R_tDCS = R_tDCS + R_code;
    elseif code == 2
        n_tRNS = n_tRNS +1;
        age_tRNS = [age_tRNS;age];
        F_tRNS = F_tRNS + F_code;
        R_tRNS = R_tRNS + R_code;
    elseif code == 3
        n_Sham = n_Sham +1;
        age_Sham = [age_Sham;age];
        F_Sham = F_Sham + F_code;
        R_Sham = R_Sham + R_code;
    end
end
fprintf('Age: %.2f(%.2f)\t %.2f(%.2f)\t %.2f(%.2f)\n',mean(age_tDCS),std(age_tDCS),mean(age_tRNS),std(age_tRNS),mean(age_Sham),std(age_Sham))
fprintf('Sex: %d:%d\t%d:%d\t%d:%d\n',F_tDCS,n_tDCS-F_tDCS,F_tRNS,n_tRNS-F_tRNS,F_Sham,n_Sham-F_Sham);
fprintf('Haned: %d:%d\t%d:%d\t%d:%d\n',R_tDCS,n_tDCS-R_tDCS,R_tRNS,n_tRNS-R_tRNS,R_Sham,n_Sham-R_Sham);
% x = [age_tDCS;age_tRNS;age_Sham];
x = [age_tDCS;age_Sham];
g = [ones(size(age_tDCS));2*ones(size(age_tRNS));3*ones(size(age_Sham))];
figure
% boxplot(x,g)
% hold on
% scatter(ones(size(age_tDCS)).*(1+(rand(size(age_tDCS))-0.5)/10),age_tDCS,'r','filled')
% scatter(2*ones(size(age_tRNS)).*(1+(rand(size(age_tRNS))-0.5)/10),age_tRNS,'b','filled')
% scatter(3*ones(size(age_Sham)).*(1+(rand(size(age_Sham))-0.5)/10),age_Sham,'g','filled')
% Y = {age_tDCS,age_tRNS,age_Sham};
Y = {age_tDCS,age_Sham};

[h,L,MX,MED] = violin(Y,'facealpha',0.1)
hold on
x_position = [ones(size(age_tDCS)).*(1+(rand(size(age_tDCS))-0.5)/10);...
    2*ones(size(age_Sham)).*(1+(rand(size(age_Sham))-0.5)/10)];
% scatter(ones(size(age_tDCS)).*(1+(rand(size(age_tDCS))-0.5)/10),age_tDCS,150,'b','x','linewidth',2)
% scatter(2*ones(size(age_tRNS)).*(1+(rand(size(age_tRNS))-0.5)/10),age_tRNS,150,'b','x','linewidth',2)
% scatter(3*ones(size(age_Sham)).*(1+(rand(size(age_Sham))-0.5)/10),age_Sham,150,'b','x','linewidth',2)
scatter(x_position,x,50,'b','x','linewidth',2,'displayname','data')
xticks([1 2])
xticklabels({'tDCS','Sham'})
set(gca,'FontSize',12)
set(gca, 'FontName', 'Arial')
ylabel('Age')
set(gcf, 'Position',  [360   423   395   275])

[h_Sham,~] = kstest(age_Sham);
[h_tDCS,~] = kstest(age_tDCS);
if h_Sham == 0 && h_tDCS == 0 % if they are all normally distrubuted
    [h,p] = ttest(age_Sham,age_tDCS);
else
    [p,h] = ranksum(age_Sham,age_tDCS);
end
display(h_Sham)
display(h_tDCS)
display(p)