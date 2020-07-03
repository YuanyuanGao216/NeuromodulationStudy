function Sig_Test_Hb(MeanHbMatrix,delete_unskilled,period)
% Sig_Test_Hb do ANOVA test, save the p value to ANOVA.txt, plot boxplot
% and put the pairwise p values on the boxplot, and also plot a errbar plot 

savepath = '../../../Processed_Data/HbOverlay';
MeanHbMatrix = delete_unskilled_fNIRS(MeanHbMatrix,delete_unskilled);
if period.end ~= 0
    savepath = [savepath,'_',num2str(delete_unskilled),'_',num2str(period.start),num2str(period.end)];
end

%% whole follow
sig_Hb(MeanHbMatrix,'follow',savepath)
sig_Hb(MeanHbMatrix,'transfer',savepath)
sig_Hb(MeanHbMatrix,'day2-6',savepath)
sig_Hb(MeanHbMatrix,'day7-12',savepath)
sig_Hb(MeanHbMatrix,'day1',savepath)