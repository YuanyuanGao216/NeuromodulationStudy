function [mean, std, mean_follow, std_follow] = cal_mean_std(Sham_data)
mean = nanmean(Sham_data,2);
std = 2*1.96*nanstd(Sham_data,0,2)./sqrt(sum(~isnan(Sham_data),2));

follow = reshape(Sham_data(13:15,:),1,[]);
mean_follow = nanmean(follow,2);
std_follow = 2*1.96*nanstd(follow,0,2)./sqrt(sum(~isnan(follow),2));