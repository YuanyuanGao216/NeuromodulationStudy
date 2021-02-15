channels = [1:2,4:5,7:8,10:14,16:19,21:24,26:30,32:35];
brain_channels = [2,2,2,5,4,4,5,4];
fs = 1/0.128;
startpoint = 78+round(period.start*fs);
endpoint = 78+round(period.end*fs);

for subj = 1:length(DM)
    fNIRS = DM(subj).fNIRS;
    fNIRSmean = zeros(size(DM(subj).TrainData,1),8);
    for i = 1:size(DM(subj).TrainData,1)
        Day = DM(subj).TrainData(i,1);
        Trial = DM(subj).TrainData(i,2);
        Day_fnirs = DM(subj).fNIRS{Day,1};
        if Trial > length(Day_fnirs)
            DM(subj).TrainData(i,7:14) = nan;
            continue
        end
        fNIRS = Day_fnirs{Trial};
        if isempty(fNIRS)
            DM(subj).TrainData(i,7:14) = nan;
            continue
        end
        HbO = fNIRS;
        Hb = zero2nan(HbO);
        meanHb = nan(2,28);
        if period.end == 0 || endpoint> size(Hb,1)
            meanHb = squeeze(nanmean(Hb(startpoint:end,1:2,:),1));
        else
            meanHb = squeeze(nanmean(Hb(startpoint:endpoint,1:2,:),1));
        end
        for brain_area = 1:length(brain_channels)
            ba_channels = (sum(brain_channels(1:(brain_area-1)))+1):sum(brain_channels(1:(brain_area)));
            area = channels(ba_channels);
            meanvalues = nanmean(meanHb(:,area),2);
            if meanvalues == 0
                DM(subj).TrainData(i,6+brain_area) = nan;
            else
                DM(subj).TrainData(i,6+brain_area) = meanvalues(1);
            end
        end
    end
end
TrainMatrix = [];
TrainMatrix_tDCS = [];
TrainMatrix_Sham = [];
TrainMatrix_tDCS_day2_6 = [];
TrainMatrix_Sham_day2_6 = [];
TrainMatrix_tDCS_day7_12 = [];
TrainMatrix_Sham_day7_12 = [];

for subj = 1:length(DM)
    if DM(subj).skilled == 0
        continue
    end
    Traindata = DM(subj).TrainData;
    TrainMatrix = [TrainMatrix; Traindata];
    if strcmp(DM(subj).code,'A')
        TrainMatrix_tDCS = [TrainMatrix_tDCS; Traindata];
        TrainMatrix_tDCS_day2_6 = [TrainMatrix_tDCS_day2_6; Traindata(ismember(Traindata(:,1),2:6),:)];
        TrainMatrix_tDCS_day7_12 = [TrainMatrix_tDCS_day7_12; Traindata(ismember(Traindata(:,1),7:12),:)];
    else
        TrainMatrix_Sham = [TrainMatrix_Sham; Traindata];
        TrainMatrix_Sham_day2_6 = [TrainMatrix_Sham_day2_6; Traindata(ismember(Traindata(:,1),2:6),:)];
        TrainMatrix_Sham_day7_12 = [TrainMatrix_Sham_day7_12; Traindata(ismember(Traindata(:,1),7:12),:)];
    end
end
figure
corrplot(TrainMatrix(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'Time','Error','Score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('all data points')
figure
corrplot(TrainMatrix_tDCS(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('tDCS')

figure
corrplot(TrainMatrix_Sham(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('Sham')

figure
corrplot(TrainMatrix_tDCS_day2_6(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('tDCS day 2-6')

figure
corrplot(TrainMatrix_tDCS_day7_12(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('tDCS day 7-12')

figure
corrplot(TrainMatrix_Sham_day2_6(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('Sham day 2-6')

figure
corrplot(TrainMatrix_Sham_day7_12(:,4:14),'testR','on','alpha',0.05/24,'varNames',{'time','error','score','lPFC','mPFC','rPFC','llM1','lmM1','rmM1','rlM1','SMA'});
title('Sham day 7-12')