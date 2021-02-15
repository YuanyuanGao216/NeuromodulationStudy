function Time_series_fNIRS(TSHbMatrix,delete_unskilled,p)
if delete_unskilled == 1
%     TSHbMatrix.Train(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Train(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Train(1,2,:,:,:,:,:) = nan;
%     TSHbMatrix.Train(2,6,:,:,:,:,:) = nan;
    
%     TSHbMatrix.Follow(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Follow(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Follow(1,2,:,:,:,:,:) = nan;
%     TSHbMatrix.Follow(2,6,:,:,:,:,:) = nan;
    
%     TSHbMatrix.Transfer(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Transfer(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Transfer(1,2,:,:,:,:,:) = nan;
%     TSHbMatrix.Transfer(2,6,:,:,:,:,:) = nan;
end

period = 60;
fs = 1/0.128;

for bio = 1:2
    for i = 1:8
        data = TSHbMatrix.Train(:,:,1,:,bio,i,1:78+round(period*fs));
        % 2 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
        % biomarkers(HbO&HbR); 28 channels;
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data); % 2*7*11*547
        data_group = nanmean(temp(:,:,:,78 + round(p.start * fs): 78 + round(p.end * fs)),4);% 2*7*11*1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.Day1{i} = data_group;
        n = squeeze(sum(~isnan(temp),[2 3]));
        Hb{bio}.Day1{i} = [y;dy;n];
        
        data = TSHbMatrix.Train(:,:,2:6,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data); % 3     7     5    11   547
        data_group = nanmean(temp(:, :, :, :, 78 + round(p.start * fs): 78 + round(p.end * fs)),5);% 3     7     5    11   1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.train1{i} = data_group;
        n = squeeze(sum(~isnan(temp),[2 3 4]));
        Hb{bio}.train1{i} = [y;dy;n];
        
        data = TSHbMatrix.Train(:,:,7:12,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        data_group = nanmean(temp(:, :, :, :, 78 + round(p.start * fs): 78 + round(p.end * fs)),5);% 3     7     5    11   1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.train2{i} = data_group;
        n = squeeze(sum(~isnan(temp),[2 3 4]));
        Hb{bio}.train2{i} = [y;dy;n];
        
        data = TSHbMatrix.Follow(:,:,:,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);% 3     7     3   547
        data_group = nanmean(temp(:, :, :, 78 + round(p.start * fs): 78 + round(p.end * fs)),4);% 3     7     3    1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.follow{i} = data_group;
        n = squeeze(sum(~isnan(temp),[2 3]));
        Hb{bio}.follow{i} = [y;dy;n];
        
        data = TSHbMatrix.Transfer(:,:,1,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data); % 3     7   547
        data_group = nanmean(temp(:, :, 78 + round(p.start * fs): 78 + round(p.end * fs)),3);% 3     7   1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.transfer1{i} = data_group;
        n = squeeze(sum(~isnan(temp),2));
        Hb{bio}.transfer1{i} = [y;dy;n];
        
        data = TSHbMatrix.Transfer(:,:,2,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);% 3     7   547
        data_group = nanmean(temp(:, :, 78 + round(p.start * fs): 78 + round(p.end * fs)),3);% 3     7   1
        data_group = reshape(data_group,2,[]);
        Hb{bio}.group.transfer2{i} = data_group;
        n = squeeze(sum(~isnan(temp),2));
        Hb{bio}.transfer2{i} = [y;dy;n];
    end
end

save('../../../Processed_Data/TSHbMatrix.mat','Hb')

