function [MeanHbMatrix_path] = MeanHb(Data_by_Sub,delete_unskilled,period)


fs = 1/0.128;
startpoint = 78+round(period.start*fs);
endpoint = 78+round(period.end*fs);

MeanHbMatrix.Train = nan(2,7,12,11,2,28);
% 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
% biomarkers(HbO&HbR); 28 channels;
MeanHbMatrix.Follow = nan(2,7,1,3,2,28);
MeanHbMatrix.Transfer = nan(2,7,2,1,2,28);

TSHbMatrix.Train = nan(2,7,12,11,2,8,6803);
% 3 stims (tDCS,tRNS,Sham);7subjects;12days;11trials at most; 2
% biomarkers(HbO&HbR); 28 channels;
TSHbMatrix.Follow = nan(2,7,1,3,2,8,6803);
TSHbMatrix.Transfer = nan(2,7,2,1,2,8,6803);

s_index = ones(3,1);
channels = [1:2,4:5,7:8,10:14,16:19,21:24,26:30,32:35];
brain_channels = [2,2,2,5,4,4,5,4];
for sub = 1:length(Data_by_Sub)
    code = Data_by_Sub(sub).code;
    if strcmp(code,'A')
        code = 1;
    elseif strcmp(code,'C')
        code = 2;
    end
    Data = Data_by_Sub(sub).fNIRS;
    n_day = length(Data);
    if n_day ~= 13
        fprintf('subject #%d: day number is not 13!',sub);
    end
    
    for day = 1:12
        Hb_by_day = Data{day,1};
        if day < 12
            n_trail = length(Hb_by_day);
        elseif day == 12
            n_trail = 5;
        end
        for trail = 1:n_trail
            Hb = Hb_by_day{trail,1};
            meanHb = nan(2,28);
            TSHb = nan(2,8,6803);
            if ~isempty(Hb)
                Hb = zero2nan(Hb);
                if period.end == 0 || endpoint> size(Hb,1)
                    meanHb = squeeze(nanmean(Hb(startpoint:end,1:2,channels),1));
                else
                    meanHb = squeeze(nanmean(Hb(startpoint:endpoint,1:2,channels),1));
                end
                n_time = size(Hb,1);
                for brain_area = 1:length(brain_channels)
                    ba_channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
                    area = channels(ba_channels);
                    TSHb(:,brain_area,1:n_time) = nanmean(Hb(:,1:2,area),3)';
                end
            end
            MeanHbMatrix.Train(code,s_index(code),day,trail,:,:) = meanHb;
            TSHbMatrix.Train(code,s_index(code),day,trail,:,:,:) = TSHb(:,:,:);
        end
    end
    % transfer #1
    day = 12;
    Hb_by_day = Data{day,1};
    trail = 6;
    Hb = Hb_by_day{trail,1};
    meanHb = nan(2,28);
    TSHb = nan(2,8,6803);
    if ~isempty(Hb)
        Hb = zero2nan(Hb);
        if endpoint == 0 || endpoint > size(Hb,1)
            meanHb = squeeze(nanmean(Hb(startpoint:end,1:2,channels),1));
        else
            meanHb = squeeze(nanmean(Hb(startpoint:endpoint,1:2,channels),1));
        end
        n_time = size(Hb,1);
        for brain_area = 1:length(brain_channels)
            ba_channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            area = channels(ba_channels);
            TSHb(:,brain_area,1:n_time) = nanmean(Hb(:,1:2,area),3)';
        end
    end
    % MeanHbMatrix.Transfer = nan(3,7,2,1,2,28);
    MeanHbMatrix.Transfer(code,s_index(code),1,1,:,:) = meanHb;
%     TSHbMatrix.Transfer = nan(3,7,2,1,2,8,6803);
    TSHbMatrix.Transfer(code,s_index(code),1,1,:,:,:) = TSHb(:,:,:);
    % transfer #2
    day = 13;
    Hb_by_day = Data{day,1};
    trail = 4;
    Hb = Hb_by_day{trail,1};
    meanHb = nan(2,28);
    TSHb = nan(2,8,6803);
    if ~isempty(Hb)
        Hb = zero2nan(Hb);
        if endpoint == 0 || endpoint> size(Hb,1)
            meanHb = squeeze(nanmean(Hb(startpoint:end,1:2,channels),1));
        else
            meanHb = squeeze(nanmean(Hb(startpoint:endpoint,1:2,channels),1));
        end
        n_time = size(Hb,1);
        for brain_area = 1:length(brain_channels)
            ba_channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            area = channels(ba_channels);
            TSHb(:,brain_area,1:n_time) = nanmean(Hb(:,1:2,area),3)';
        end
    end
    % MeanHbMatrix.Transfer = nan(3,7,2,1,2,28);
    MeanHbMatrix.Transfer(code,s_index(code),2,1,:,:) = meanHb;
    TSHbMatrix.Transfer(code,s_index(code),2,1,:,:,:) = TSHb(:,:,:);
    
    % follow up
    day = 13;
    Hb_by_day = Data{day,1};
    n_trail = 3;
    for trail = 1:n_trail
        Hb = Hb_by_day{trail,1};
        meanHb = nan(2,28);
        TSHb = nan(2,8,6803);
        if ~isempty(Hb)
            Hb = zero2nan(Hb);
            if endpoint == 0 || endpoint> size(Hb,1)
                meanHb = squeeze(nanmean(Hb(startpoint:end,1:2,channels),1));
            else
                meanHb = squeeze(nanmean(Hb(startpoint:endpoint,1:2,channels),1));
            end
            n_time = size(Hb,1);
            for brain_area = 1:length(brain_channels)
                ba_channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
                area = channels(ba_channels);
                TSHb(:,brain_area,1:n_time) = nanmean(Hb(:,1:2,area),3)';
            end
        end
        % MeanHbMatrix.Follow = nan(3,7,1,3,2,28);
        MeanHbMatrix.Follow(code,s_index(code),1,trail,:,:) = meanHb;
%         TSHbMatrix.Follow = nan(3,7,1,3,2,8,6803);
        TSHbMatrix.Follow(code,s_index(code),1,trail,:,:,:) = TSHb(:,:,:);
    end
    
    s_index(code) = s_index(code) + 1;
end
MeanHbMatrix_path = ['../../../Processed_Data/MeanHbMatrix_',int2str(delete_unskilled),'_'];

if period.end == 0
    MeanHbMatrix_path = [MeanHbMatrix_path,'0.mat'];
    
else
    MeanHbMatrix_path = [MeanHbMatrix_path,int2str(period.start),int2str(period.end),'.mat'];
end
save(MeanHbMatrix_path,'MeanHbMatrix');


Time_series_fNIRS(TSHbMatrix,delete_unskilled,period);

