function [NIRSmatrix,flag] = fNIRSprocess(fNIRS_data)
NIRSmatrix = [];
%% read stimuli and deactivate the stimulies
if size(fNIRS_data.s,2) ~= 1
    fNIRS_data.s = sum(fNIRS_data.s,2);
end
stimuli_list = find(fNIRS_data.s==1);
n_stim = length(stimuli_list);
iseven = rem(n_stim, 2) == 0;
if ~iseven
    flag = 0;
elseif n_stim>20
    flag = 2;
else
    j = 1;
    for i = 1:2:n_stim
        s = fNIRS_data.s;
        if i == 1
            stim_del = stimuli_list(i+1:end);
        else
            stim_del = stimuli_list([1:i-1,i+1:end]);
        end
        s(stim_del)  = 0;
        stim_start   = fNIRS_data.t(stimuli_list(i));
        stim_end     = fNIRS_data.t(stimuli_list(i+1));
        stim_time    = stim_end - stim_start;
    %     stim_time = 439;
        d       = fNIRS_data.d;
        SD      = fNIRS_data.SD;
        t       = fNIRS_data.t;
        tIncMan = ones(size(t));
    %     Aaux    = fNIRS_data.aux;
        Aaux    = [];
        tIncAuto = [];

        SD      = enPruneChannels(d,SD,tIncMan,[0.01 10],3,[0  45],0);

        dod     = hmrIntensity2OD(d);

        [s,tRangeStimReject] = enStimRejection(t,s,tIncAuto,tIncMan,[0  0]);

        dod     = hmrBandpassFilt(dod,t,0,0.5);

        dc      = hmrOD2Conc(dod,SD,[6  6]);

        [dcAvg,dcAvgStd,tHRF,nTrials,dc,dcResid,dcSum2,beta,R] = hmrDeconvHRF_DriftSS(dc,s,t,SD,Aaux,tIncAuto,[-10  stim_time],1,1,[1  1],1,1,0,0);

        NIRSmatrix{j,1} = dcAvg;
        j = j + 1;
    end
    flag = 1;
end


