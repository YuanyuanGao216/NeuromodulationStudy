function p = performANOVA(X,Group)
% tRNS_color = [56,182,255]./256;
tDCS_color = [255,145,77]./256;
Sham_color = [85,85,85]./256;

if nanmean(X) < 0.0001
    X = X*1000000;
end
% levene test
digit_label = zeros(size(Group));

digit_label(strcmp(Group, 'tDCS')) = 1;
digit_label(strcmp(Group, 'Sham')) = 2;

X_Data = [X,digit_label];
X_Data(isnan(X),:) = [];

% ks test
X1 = X_Data(X_Data(:,2) == 1,1);
X2 = X_Data(X_Data(:,2) == 2,1);

[~,p_ks1] = kstest(X1);
[~,p_ks2] = kstest(X2);
if p_ks1 > 0.05 && p_ks2 >0.05
    [~,p] = ttest2(X1,X2);
else
    [p,~] = ranksum(X1,X2);
end

