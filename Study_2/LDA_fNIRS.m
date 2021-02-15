function acc = LDA_fNIRS(TSHbMatrix,period)
fs = 1/0.128;

startpoint = 78+round(period.start*fs);
endpoint = 78+round(period.end*fs);

% train1
tDCS_matrix = nanmean(TSHbMatrix.Train(1,:,1:6,:,1,:,startpoint:endpoint),7);
tDCS_mean = zeros(462,8);
for area_code = 1:8
    tDCS = tDCS_matrix(:,:,:,:,:,area_code);
    tDCS_mean(:,area_code) = reshape(tDCS,462,1);
end
[nan_index,~] = find(isnan(tDCS_mean));
tDCS_mean(nan_index,:) = [];


Sham_matrix = nanmean(TSHbMatrix.Train(2,:,1:6,:,1,:,startpoint:endpoint),7);
Sham_mean = zeros(462,8);
for area_code = 1:8
    Sham = Sham_matrix(:,:,:,:,:,area_code);
    Sham_mean(:,area_code) = reshape(Sham,462,1);
end
[nan_index,~] = find(isnan(Sham_mean));
Sham_mean(nan_index,:) = [];

meanData.K = [size(tDCS_mean,1);size(Sham_mean,1)];
meanData.Z0 = [tDCS_mean;Sham_mean];

acc.train1 = accFDA(meanData);

% day7-12
tDCS_matrix = nanmean(TSHbMatrix.Train(1,:,7:12,:,1,:,startpoint:endpoint),7);
tDCS_mean = zeros(462,8);
for area_code = 1:8
    tDCS = tDCS_matrix(:,:,:,:,:,area_code);
    tDCS_mean(:,area_code) = reshape(tDCS,462,1);
end
[nan_index,~] = find(isnan(tDCS_mean));
tDCS_mean(nan_index,:) = [];

Sham_matrix = nanmean(TSHbMatrix.Train(2,:,7:12,:,1,:,startpoint:endpoint),7);
Sham_mean = zeros(462,8);
for area_code = 1:8
    Sham = Sham_matrix(:,:,:,:,:,area_code);
    Sham_mean(:,area_code) = reshape(Sham,462,1);
end
[nan_index,~] = find(isnan(Sham_mean));
Sham_mean(nan_index,:) = [];

% meanData.K = [size(tDCS_mean,1);size(tRNS_mean,1);size(Sham_mean,1)];
% meanData.Z0 = [tDCS_mean;tRNS_mean;Sham_mean];
meanData.K = [size(tDCS_mean,1);size(Sham_mean,1)];
meanData.Z0 = [tDCS_mean;Sham_mean];
acc.train2 = accFDA(meanData);
