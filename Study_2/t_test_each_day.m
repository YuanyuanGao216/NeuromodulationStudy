function t_test_each_day(Sham_data,tDCS_data,var)

Sham_data(13,:) = nansum(Sham_data(13:15,:),1);
Sham_data(14:15,:) = [];
tDCS_data(13,:) = nansum(tDCS_data(13:15,:),1);
tDCS_data(14:15,:) = [];

n_days = size(Sham_data,1);
ttest_result_file = fopen('performance_ttest.txt','a');
fprintf(ttest_result_file,'For:%s\n',var);

for day = 1:n_days
    Sham = Sham_data(day,~isnan(Sham_data(day,:)));
    tDCS = tDCS_data(day,~isnan(tDCS_data(day,:)));
    [h_Sham,p_norm_Sham] = kstest(Sham);
    [h_tDCS,p_norm_tDCS] = kstest(tDCS);
    if h_Sham == 0 && h_tDCS == 0 % if they are all normally distrubuted
        [h,p] = ttest(Sham,tDCS);
    else
        [p,h] = ranksum(Sham,tDCS);
    end
    fprintf(ttest_result_file,'Day %d p = %.3f\n',day,p);
end