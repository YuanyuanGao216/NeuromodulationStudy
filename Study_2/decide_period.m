function period = decide_period(DataMatrix,delete_unskilled)
%% decide whether delete the unskilled
Data_by_Sub = delete_sub(DataMatrix,delete_unskilled);
period_start_array = 0:5:59;
train1_acc = nan(length(period_start_array),length(period_start_array));
train2_acc = nan(length(period_start_array),length(period_start_array));
% transfer_acc = zeros(1,60);
% follow_acc = zeros(1,60);
TSHbMatrix = TSHbMatrix_generate(Data_by_Sub);
fprintf('finished data generate\n')
for period_start_idx = 1:length(period_start_array)-1
    period_start = period_start_array(period_start_idx);
    for period_end_idx = period_start_idx+1:length(period_start_array)
        period_end = period_start_array(period_end_idx);
        period.start = period_start;
        period.end = period_end;
        acc = LDA_fNIRS(TSHbMatrix,period);
        train1_acc(period_start_idx,period_end_idx) = acc.train1;
        train2_acc(period_start_idx,period_end_idx) = acc.train2;
    end
end
% figure
% hold on
% plot(train1_acc,'b-o')
% plot(train2_acc,'b-o')
% set(gca,'FontSize',15)
% set(gca, 'FontName', 'Arial')
% title('LDA classification')
% ylable('Accuracy')
% xlable('period')
figure
imagesc(train1_acc);
colorbar;
ylabel('Start time')
xlabel('End time')
xticks(2:2:12)
xticklabels({'5','15','25','35','45','55'})
yticks(2:2:12)
yticklabels({'5','15','25','35','45','55'})
title('LDA accuracy Day 2-6')
set(gca,'FontSize',15)
set(gca, 'FontName', 'Arial')
set(gcf, 'Position',  [100, 100, 320, 220])
figure
imagesc(train2_acc);
colorbar;
ylabel('Start time')
xlabel('End time')
xticks(2:2:12)
xticklabels({'5','15','25','35','45','55'})
yticks(2:2:12)
yticklabels({'5','15','25','35','45','55'})
title('LDA accuracy Day 7-12')
set(gca,'FontSize',15)
set(gca, 'FontName', 'Arial')
set(gcf, 'Position',  [100, 100, 320, 220])
figure
surf(train1_acc)
hold on
imagesc(train1_acc)
figure
surf(train2_acc)
hold on
imagesc(train2_acc)

max_num = max(train1_acc(:));
[X Y]=find(train1_acc == max_num);
fprintf('train1: max acc is %f; start = %d; end = %d\n',max_num,period_start_array(X),period_start_array(Y))

max_num = max(train2_acc(:));
[X Y]=find(train2_acc == max_num);
fprintf('train2: max acc is %f; start = %d; end = %d\n',max_num,period_start_array(X),period_start_array(Y))

