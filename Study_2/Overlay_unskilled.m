function Overlay_unskilled(MeanHbMatrix,delete_unskilled,period)
% MeanHbMatrix.Train = nan(3,7,12,11,2,28)
% 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
% biomarkers(HbO&HbR); 28 channels;
% MeanHbMatrix.Follow = nan(3,7,1,3,2,28)
% MeanHbMatrix.Transfer = nan(3,7,2,1,2,28)
% unskilled : B1;A1;A2;B6
savepath = '../../../Processed_Data/HbOverlay';


if delete_unskilled == 2
    temp.Train(2,1,:,:,:,:) = MeanHbMatrix.Train(2,1,:,:,:,:);
    temp.Train(1,1,:,:,:,:) = MeanHbMatrix.Train(1,1,:,:,:,:);
    temp.Train(1,2,:,:,:,:) = MeanHbMatrix.Train(1,2,:,:,:,:);
    temp.Train(2,2,:,:,:,:) = MeanHbMatrix.Train(2,6,:,:,:,:);
    
    MeanHbMatrix = temp;
end
if period.end ~= 0
    savepath = [savepath,'_',num2str(delete_unskilled),'_',num2str(period.start),num2str(period.end)];
end
% get group structure
filepath = '../../../Raw_Data/Study_#2/L2';
oldpath = cd(filepath);
load('groupResults.mat')
cd(oldpath)
t = 0.128:0.128:0.128*10;
group.procResult.tHRF = t;
% ANOVA file
brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
brain_channels = [2,2,2,5,4,4,5,4];
biomarkers = {'HbO','HbR'};
stim_codes = {'tDCS','tRNS','Sham'};


% day 2-6
% overlay
for stim = 1:2
    % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
    data = MeanHbMatrix.Train(stim,:,2:6,:,:,:);
    HbData = nanmean(nanmean(nanmean(data,2),4),3);
    HbData = squeeze(HbData);
    dc(:,1,:) = repmat(HbData(1,:),10,1);
    dc(:,2,:) = repmat(HbData(2,:),10,1);
    group.procResult.dcAvg = dc*1e6;
    path = [savepath,'/day2-6/',char(stim_codes{stim}),'/groupResults.mat'];
    save(path,'group')
end

% day 7-12
% overlay
for stim = 1:2
    % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
    data = MeanHbMatrix.Train(stim,:,7:12,:,:,:);
    HbData = nanmean(nanmean(nanmean(data,2),4),3);
    HbData = squeeze(HbData);
    dc(:,1,:) = repmat(HbData(1,:),10,1);
    dc(:,2,:) = repmat(HbData(2,:),10,1);
    group.procResult.dcAvg = dc*1e6;
    path = [savepath,'/day7-12/',char(stim_codes{stim}),'/groupResults.mat'];
    save(path,'group')
end
