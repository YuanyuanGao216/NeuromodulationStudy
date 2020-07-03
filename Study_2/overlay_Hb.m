function overlay_Hb(MeanHbMatrix,stage,savepath)
stim_codes = {'tDCS','tRNS','Sham'};

if strcmp(stage,'transfer')
    trial_no = 2;
else
    trial_no = 1;
end
for t = 1:trial_no
    % overlay
    for stim = 1:3
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