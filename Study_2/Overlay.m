function Overlay(MeanHbMatrix,delete_unskilled,period)

savepath = '../../../Processed_Data/HbOverlay';
MeanHbMatrix = delete_unskilled_fNIRS(MeanHbMatrix,delete_unskilled);
if period.end ~= 0
    savepath = [savepath,'_',num2str(delete_unskilled),'_',num2str(period.start),num2str(period.end)];
end

overlay_Hb(MeanHbMatrix,'transfer',savepath)
overlay_Hb(MeanHbMatrix,'follow',savepath)
overlay_Hb(MeanHbMatrix,'day2-6',savepath)
overlay_Hb(MeanHbMatrix,'day7-12',savepath)
