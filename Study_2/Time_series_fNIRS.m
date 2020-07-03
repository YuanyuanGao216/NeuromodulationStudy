function Time_series_fNIRS(TSHbMatrix,delete_unskilled)
if delete_unskilled == 1
    TSHbMatrix.Train(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Train(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Train(1,2,:,:,:,:,:) = nan;
    TSHbMatrix.Train(2,6,:,:,:,:,:) = nan;
    
    TSHbMatrix.Follow(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Follow(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Follow(1,2,:,:,:,:,:) = nan;
    TSHbMatrix.Follow(2,6,:,:,:,:,:) = nan;
    
    TSHbMatrix.Transfer(2,1,:,:,:,:,:) = nan;
    TSHbMatrix.Transfer(1,1,:,:,:,:,:) = nan;
    TSHbMatrix.Transfer(1,2,:,:,:,:,:) = nan;
    TSHbMatrix.Transfer(2,6,:,:,:,:,:) = nan;
end

period = 60;
fs = 1/0.128;

for bio = 1:2
    for i = 1:8
        data = TSHbMatrix.Train(:,:,1,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),[2 3]));
        Hb{bio}.Day1{i} = [y;dy;n];
        
        data = TSHbMatrix.Train(:,:,2:6,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),[2 3 4]));
        Hb{bio}.train1{i} = [y;dy;n];
        
        data = TSHbMatrix.Train(:,:,7:12,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),[2 3 4]));
        Hb{bio}.train2{i} = [y;dy;n];
        
        data = TSHbMatrix.Follow(:,:,:,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),[2 3]));
        Hb{bio}.follow{i} = [y;dy;n];
        
        data = TSHbMatrix.Transfer(:,:,1,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),2));
        Hb{bio}.transfer1{i} = [y;dy;n];
        
        data = TSHbMatrix.Transfer(:,:,2,:,bio,i,1:78+round(period*fs));
        y = squeeze(nanmean(data,[2,3,4]));
        dy = squeeze(nanstd(data,0,[2,3,4]));
        temp = squeeze(data);
        n = squeeze(sum(~isnan(temp),2));
        Hb{bio}.transfer2{i} = [y;dy;n];
    end
end

save('../../../Processed_Data/TSHbMatrix.mat','Hb')

