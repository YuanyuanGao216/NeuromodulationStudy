function DataMatrix = ReadData()
% output DataMatrix is a structure:
% name: subject name
% TrainData: trials X [day, trial, total trial, time, error, score]
% TransferData: trials X time
% FollowUpData: trials X [time, error, score]

if ismac
    DataPath = '../../../raw_data';
else
    DataPath = '..\..\..\Raw_data';
end
DataFile = 'data collection form 2.xlsx';
if ismac
    filename = [DataPath, '/', DataFile];
else
    filename = [DataPath, '\', DataFile];
end

sheet = 'Study 2';
xlRange = 'A3:J2185';
[num,txt,raw] = xlsread(filename,sheet,xlRange);

TrainData = struct([]);
FollowUpData = struct([]);
TransferData = struct([]);

n = 1;
n_Train = 1;
n_Follow = 1;
n_Transfer = 1;

while n < length(raw)
    Sub_name = string(raw(n,1));
    D = cell2mat(raw(n,2));
    T = cell2mat(raw(n,3));
    TT = cell2mat(raw(n,4));
    Time = cell2mat(raw(n,7));
    Error = cell2mat(raw(n,8));
    Score = cell2mat(raw(n,9));
    Score(Score<0) = 0;
    Note = string(raw(n,10));
    
    if ~isa(D,'char')
        TrainData(n_Train).Sub_name = Sub_name;
        TrainData(n_Train).D        = D;
        TrainData(n_Train).T        = T;
        TrainData(n_Train).TT       = TT;
        TrainData(n_Train).Time     = Time;
        TrainData(n_Train).Error    = Error;
        TrainData(n_Train).Score    = Score;
        TrainData(n_Train).Note     = Note;
        n_Train                     = n_Train + 1;
    elseif strcmp(D,'T1') || strcmp(D,'T2')
        TransferData(n_Transfer).Sub_name = Sub_name;
        TransferData(n_Transfer).T = D;
        TransferData(n_Transfer).Time = Time;
        TransferData(n_Transfer).Note = Note;
        n_Transfer = n_Transfer + 1;
    elseif strcmp(D,'F1') || strcmp(D,'F2') || strcmp(D,'F3')
        FollowUpData(n_Follow).Sub_name = Sub_name;
        FollowUpData(n_Follow).T = D;
        FollowUpData(n_Follow).Time = Time;
        FollowUpData(n_Follow).Error = Error;
        FollowUpData(n_Follow).Score = Score;
        FollowUpData(n_Follow).Note = Note;
        n_Follow = n_Follow + 1;
    end
    n = n + 1;
end
Sub_array = {'L2','L3','L4','L5','L6','L7','L9','L10',...
    'L11', 'L13','L14','L15','L17','L18','L19','L21','L22',...
    'L23','L24','L25','L26'};
Data_by_Sub = struct([]);
sheet = 'S2-stim-code';
xlRange = 'A1:B21';
[~,~,code] = xlsread(filename,sheet,xlRange);

for sub_j = 1:length(Sub_array)
    sub = Sub_array(sub_j);
    N_trail = 1;
    data = zeros(70,6);
    for i = 1:length(TrainData)
        Sub_name = TrainData(i).Sub_name;
        if strcmp(Sub_name,string(sub))
            data(N_trail,1) = TrainData(i).D;
            data(N_trail,2) = TrainData(i).T;
            data(N_trail,3) = TrainData(i).TT;
            data(N_trail,4) = TrainData(i).Time;
            data(N_trail,5) = TrainData(i).Error;
            data(N_trail,6) = TrainData(i).Score;
            N_trail = N_trail + 1;
        end
    end
    for i = 1:length(TransferData)
        Sub_name = TransferData(i).Sub_name;
        if strcmp(Sub_name,string(sub))
            if strcmp(TransferData(i).T,'T1')
                transfer_data(1,1) = TransferData(i).Time;
            elseif strcmp(TransferData(i).T,'T2')
                transfer_data(2,1) = TransferData(i).Time;
            end
        end
    end
    for i = 1:length(FollowUpData)
        Sub_name = FollowUpData(i).Sub_name;
        if strcmp(Sub_name,string(sub))
            if strcmp(FollowUpData(i).T,'F1')
                follow_up_data(1,1) = FollowUpData(i).Time;
                follow_up_data(1,2) = FollowUpData(i).Error;
                follow_up_data(1,3) = FollowUpData(i).Score;
            elseif strcmp(FollowUpData(i).T,'F2')
                follow_up_data(2,1) = FollowUpData(i).Time;
                follow_up_data(2,2) = FollowUpData(i).Error;
                follow_up_data(2,3) = FollowUpData(i).Score;
            elseif strcmp(FollowUpData(i).T,'F3')
                follow_up_data(3,1) = FollowUpData(i).Time;
                follow_up_data(3,2) = FollowUpData(i).Error;
                follow_up_data(3,3) = FollowUpData(i).Score;
            end
        end
    end
    for i = 1:length(code)
        Sub_name = code(i,1);
        if strcmp(Sub_name,string(sub))
            stim_code = code(i,2);
        end
    end
    Data_by_Sub(sub_j).name = sub;
    Data_by_Sub(sub_j).TrainData = data;
    Data_by_Sub(sub_j).TransferData = transfer_data;
    Data_by_Sub(sub_j).FollowUpData = follow_up_data;
    Data_by_Sub(sub_j).code = stim_code;
end
p0 = 0.05;
p1 = 2*p0;
alpha = 0.05;
beta = 0.20;

P = log(p1/p0);
Q = log((1-p0)/(1-p1));
s = Q/(P+Q);
s1 = 1-s;
a = log((1-beta)/alpha);
b = log((1-alpha)/beta);
h0 = -b/(P+Q);
h1 = a/(P+Q);
Scores_0 = zeros(5,1);
for i = 1:length(Data_by_Sub)
    Data = Data_by_Sub(i);
    Scores = Data.TrainData(1:5,6);
    Scores_0 = Scores_0 + Scores;
end
% FLS_THRESH = mean(Scores_0./length(Data_by_Sub));
% FLS_THRESH = 151.2;
% FLS_THRESH = 76; %Junior: 41, Intermediate: 65, Senior: 76
FLS_THRESH = 109.2;
for i = 1:length(Data_by_Sub)
    Data = Data_by_Sub(i);
    Scores = Data.TrainData(:,6);
    CUSUM_scores = CUSUM(Scores,FLS_THRESH,s);
    Data_by_Sub(i).CUSUM = CUSUM_scores;
%     fprintf('i = %d; lastCUSUM = %.2f;\n',i,CUSUM_scores(end));
    if CUSUM_scores(end) > h0
        Data_by_Sub(i).skilled = 0;
    else
        Data_by_Sub(i).skilled = 1;
    end
end
DataMatrix = Data_by_Sub;