function Data = Performance_segment(Data_by_Sub)
% segment the data into three groups: tDCS, tRNS and Sham; 
% and into measurements: time, error, score
% To get the data, use Data.tDCS_TIME for example
% variance is also calculated:
% Data.tDCS_TIME_VAR

tDCS_TIME = nan(15,7*11);
tRNS_TIME = nan(15,7*11);
Sham_TIME = nan(15,7*11);
tDCS_ERROR = nan(15,7*11);
tRNS_ERROR = nan(15,7*11);
Sham_ERROR = nan(15,7*11);
tDCS_SCORE = nan(15,7*11);
tRNS_SCORE = nan(15,7*11);
Sham_SCORE = nan(15,7*11);
tDCS_TIME_VAR = nan(12,7);
tRNS_TIME_VAR = nan(12,7);
Sham_TIME_VAR = nan(12,7);
tDCS_ERROR_VAR = nan(12,7);
tRNS_ERROR_VAR = nan(12,7);
Sham_ERROR_VAR = nan(12,7);
tDCS_SCORE_VAR = nan(12,7);
tRNS_SCORE_VAR = nan(12,7);
Sham_SCORE_VAR = nan(12,7);
for d = 1:15
    tDCS_idx = 0;
    tRNS_idx = 0;
    Sham_idx = 0;
    for i = 1:length(Data_by_Sub)
        data = Data_by_Sub(i).TrainData;
        code = Data_by_Sub(i).code;
        f_data = Data_by_Sub(i).FollowUpData;
        if d <13
            data = data(data(:,1)==d,:);
            n_data = size(data,1);
            if strcmp(code, 'A')
                tDCS_TIME(d,tDCS_idx*11+1:tDCS_idx*11+n_data) = data(:,4);
                tDCS_ERROR(d,tDCS_idx*11+1:tDCS_idx*11+n_data) = data(:,5);
                tDCS_SCORE(d,tDCS_idx*11+1:tDCS_idx*11+n_data) = data(:,6);
                
                tDCS_idx = tDCS_idx + 1;
                if d ~= 1
                    tDCS_TIME_VAR(d,tDCS_idx) = nanstd(data(:,4));
                    tDCS_ERROR_VAR(d,tDCS_idx) = nanstd(data(:,5));
                    tDCS_SCORE_VAR(d,tDCS_idx) = nanstd(data(:,6));
                end 
            elseif strcmp(code, 'B')
                tRNS_TIME(d,tRNS_idx*11+1:tRNS_idx*11+n_data) = data(:,4);
                tRNS_ERROR(d,tRNS_idx*11+1:tRNS_idx*11+n_data) = data(:,5);
                tRNS_SCORE(d,tRNS_idx*11+1:tRNS_idx*11+n_data) = data(:,6);
                
                tRNS_idx = tRNS_idx + 1;
                if d ~= 1
                    tRNS_TIME_VAR(d,tRNS_idx) = nanstd(data(:,4));
                    tRNS_ERROR_VAR(d,tRNS_idx) = nanstd(data(:,5));
                    tRNS_SCORE_VAR(d,tRNS_idx) = nanstd(data(:,6));
                end
            elseif strcmp(code, 'C')
                Sham_TIME(d,Sham_idx*11+1:Sham_idx*11+n_data) = data(:,4);
                Sham_ERROR(d,Sham_idx*11+1:Sham_idx*11+n_data) = data(:,5);
                Sham_SCORE(d,Sham_idx*11+1:Sham_idx*11+n_data) = data(:,6);
                
                Sham_idx = Sham_idx + 1;
                if d ~= 1
                    Sham_TIME_VAR(d,Sham_idx) = nanstd(data(:,4));
                    Sham_ERROR_VAR(d,Sham_idx) = nanstd(data(:,5));
                    Sham_SCORE_VAR(d,Sham_idx) = nanstd(data(:,6));
                end
            end
        else
            f_trial = d-12;
            if strcmp(code, 'A')
                tDCS_TIME(d,tDCS_idx*11+f_trial) = f_data(f_trial,1);
                tDCS_ERROR(d,tDCS_idx*11+f_trial) = f_data(f_trial,2);
                tDCS_SCORE(d,tDCS_idx*11+f_trial) = f_data(f_trial,3);
                tDCS_idx = tDCS_idx + 1;
            elseif strcmp(code, 'B')
                tRNS_TIME(d,tRNS_idx*11+f_trial) = f_data(f_trial,1);
                tRNS_ERROR(d,tRNS_idx*11+f_trial) = f_data(f_trial,2);
                tRNS_SCORE(d,tRNS_idx*11+f_trial) = f_data(f_trial,3);
                tRNS_idx = tRNS_idx + 1;
            elseif strcmp(code, 'C')
                Sham_TIME(d,Sham_idx*11+f_trial) = f_data(f_trial,1);
                Sham_ERROR(d,Sham_idx*11+f_trial) = f_data(f_trial,2);
                Sham_SCORE(d,Sham_idx*11+f_trial) = f_data(f_trial,3);
                Sham_idx = Sham_idx + 1;
            end
        end
    end
end


Data.tDCS_TIME = tDCS_TIME;
Data.tRNS_TIME = tRNS_TIME;
Data.Sham_TIME = Sham_TIME;
Data.tDCS_ERROR = tDCS_ERROR * 36;
Data.tRNS_ERROR = tRNS_ERROR * 36;
Data.Sham_ERROR = Sham_ERROR * 36;
Data.tDCS_SCORE = tDCS_SCORE;
Data.tRNS_SCORE = tRNS_SCORE;
Data.Sham_SCORE = Sham_SCORE;
% Data.tDCS_TIME_VAR = tDCS_TIME_VAR;
% Data.tRNS_TIME_VAR = tRNS_TIME_VAR;
% Data.Sham_TIME_VAR = Sham_TIME_VAR;
% Data.tDCS_ERROR_VAR = tDCS_ERROR_VAR;
% Data.tRNS_ERROR_VAR = tRNS_ERROR_VAR;
% Data.Sham_ERROR_VAR = Sham_ERROR_VAR;
% Data.tDCS_SCORE_VAR = tDCS_SCORE_VAR;
% Data.tRNS_SCORE_VAR = tRNS_SCORE_VAR;
% Data.Sham_SCORE_VAR = Sham_SCORE_VAR;