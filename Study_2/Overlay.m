function Overlay(MeanHbMatrix,delete_unskilled,period)
% MeanHbMatrix.Train = nan(3,7,12,11,2,28)
% 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
% biomarkers(HbO&HbR); 28 channels;
% MeanHbMatrix.Follow = nan(3,7,1,3,2,28)
% MeanHbMatrix.Transfer = nan(3,7,2,1,2,28)
% unskilled : B1;A1;A2;B6
savepath = '../../../Processed_Data/HbOverlay';


if delete_unskilled == 1
    MeanHbMatrix.Train(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Train(2,6,:,:,:,:) = nan;
    
    MeanHbMatrix.Follow(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Follow(2,6,:,:,:,:) = nan;
    
    MeanHbMatrix.Transfer(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,2,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(2,6,:,:,:,:) = nan;
    savepath = '../../../Processed_Data/HbOverlay_del_unskilled';
% elseif delete_unskilled == 2
%     temp.Train(2,1,:,:,:,:) = MeanHbMatrix.Train(2,1,:,:,:,:);
%     
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

% train
for day = 1:12
    % overlay
    for stim = 1:3
        % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
        data = MeanHbMatrix.Train(stim,:,day,:,:,:);
        HbData = nanmean(nanmean(data,2),4);
        HbData = squeeze(HbData);
        dc(:,1,:) = repmat(HbData(1,:),10,1);
        dc(:,2,:) = repmat(HbData(2,:),10,1);
        group.procResult.dcAvg = dc*1e6;
        path = [savepath,'/day',char(string(day)),'/',char(stim_codes{stim}),'/groupResults.mat'];
        save(path,'group')
    end
end
% transfer
for t = 1:2
    % overlay
    for stim = 1:3
        % MeanHbMatrix.Transfer = nan(3,7,2,1,2,28)
        data = MeanHbMatrix.Transfer(stim,:,t,:,:,:);
        HbData = nanmean(nanmean(data,2),4);
        HbData = squeeze(HbData);
        dc(:,1,:) = repmat(HbData(1,:),10,1);
        dc(:,2,:) = repmat(HbData(2,:),10,1);
        group.procResult.dcAvg = dc*1e6;
        path = [savepath,'/transfer',char(string(t)),'/',char(stim_codes{stim}),'/groupResults.mat'];
        save(path,'group')
    end
end
% follow

for f = 1:3
    % overlay
    for stim = 1:3
        % MeanHbMatrix.Follow = nan(3,7,1,3,2,28)
        data = MeanHbMatrix.Follow(stim,:,:,f,:,:);
        HbData = nanmean(nanmean(data,2),4);
        HbData = squeeze(HbData);
        dc(:,1,:) = repmat(HbData(1,:),10,1);
        dc(:,2,:) = repmat(HbData(2,:),10,1);
        group.procResult.dcAvg = dc*1e6;
        path = [savepath,'/follow',char(string(f)),'/',char(stim_codes{stim}),'/groupResults.mat'];
        save(path,'group')
    end
end

% whole follow
% overlay
for stim = 1:3
    data = MeanHbMatrix.Follow(stim,:,:,:,:,:);
    HbData = nanmean(nanmean(data,2),4);
    HbData = squeeze(HbData);
    dc(:,1,:) = repmat(HbData(1,:),10,1);
    dc(:,2,:) = repmat(HbData(2,:),10,1);
    group.procResult.dcAvg = dc*1e6;
    path = [savepath,'/follow/',char(stim_codes{stim}),'/groupResults.mat'];
    save(path,'group')
end

% day 2-6
% overlay
for stim = 1:3
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
for stim = 1:3
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

% day 3-6
% overlay
for stim = 1:3
    % MeanHbMatrix.Train = nan(3,7,12,11,2,28)
    data = MeanHbMatrix.Train(stim,:,3:6,:,:,:);
    HbData = nanmean(nanmean(nanmean(data,2),4),3);
    HbData = squeeze(HbData);
    dc(:,1,:) = repmat(HbData(1,:),10,1);
    dc(:,2,:) = repmat(HbData(2,:),10,1);
    group.procResult.dcAvg = dc*1e6;
    path = [savepath,'/day3-6/',char(stim_codes{stim}),'/groupResults.mat'];
    save(path,'group')
end