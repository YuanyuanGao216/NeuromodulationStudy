function overlay_Hb(MeanHbMatrix,stage,savepath)
stim_codes = {'tDCS','Sham'};
% get group structure
filepath = '../../../Raw_Data/Study_#2/L2';
oldpath = cd(filepath);
load('groupResults.mat')
cd(oldpath)
t = 0.128:0.128:0.128*10;
group.procResult.tHRF = t;
brain_areas = {'lPFC';'mPFC';'rPFC';'llM1';'lmM1';'rmM1';'rlM1';'SMA'};
brain_channels = [2,2,2,5,4,4,5,4];
if strcmp(stage,'transfer')
    trial_no = 2;
else
    trial_no = 1;
end
for t = 1:trial_no
    % overlay
    for stim = 1:length(stim_codes)
        % MeanHbMatrix.Transfer = nan(3,7,2,1,2,28)
        if strcmp(stage,'transfer')
            data = MeanHbMatrix.Transfer(stim,:,t,:,:,:);
            HbData = nanmean(nanmean(data,2),4);
        elseif strcmp(stage,'follow')
            data = MeanHbMatrix.Follow(stim,:,:,:,:,:);
            HbData = nanmean(nanmean(data,2),4);
        elseif strcmp(stage,'day2-6')
            data = MeanHbMatrix.Train(stim,:,2:6,:,:,:);  
            HbData = nanmean(nanmean(nanmean(data,2),4),3);
        elseif strcmp(stage,'day7-12')
            data = MeanHbMatrix.Train(stim,:,7:12,:,:,:);
            HbData = nanmean(nanmean(nanmean(data,2),4),3);
        end
        
        HbData = squeeze(HbData);
        for brain_area = 1:length(brain_areas)
            channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            foo = nanmean(HbData(:,channels),2);
            foo = repmat(foo, 1, length(channels));
            HbData(:,channels) = foo;
        end
        dc(:,1,:) = repmat(HbData(1,:),10,1);
        dc(:,2,:) = repmat(HbData(2,:),10,1);
        group.procResult.dcAvg = dc*1e6;
        if strcmp(stage,'transfer')
            path = [savepath,'/transfer',char(string(t)),'/',char(stim_codes{stim}),'/groupResults.mat'];
        elseif strcmp(stage,'follow')
            path = [savepath,'/follow/',char(stim_codes{stim}),'/groupResults.mat'];
        elseif strcmp(stage,'day2-6')
            path = [savepath,'/day2-6/',char(stim_codes{stim}),'/groupResults.mat'];
        elseif strcmp(stage,'day7-12')
            path = [savepath,'/day7-12/',char(stim_codes{stim}),'/groupResults.mat'];

        end
         
        save(path,'group')
    end
end