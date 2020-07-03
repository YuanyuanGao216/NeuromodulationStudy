% clear all
clc
close all
close all hidden

%% Performance data analysis

% load the performance data
DM = ReadData;

% decide whether to delete learners
delete_unskilled = 1;% 0 - all the learners; 1 - only skilled learners; 2 - only unskilled learners

% Plot the learning curves
PlotLearningCurveByDay(DM,delete_unskilled);

% SigTest(DM,delete_unskilled);
% PlotCUSUM(DM);
% LearningCurveFeature(DM,delete_unskilled); %OLS
% Paras = LearningCurve3Feature(DM,delete_unskilled); % initial level, 
% Paras = StochasticModel(DM,delete_unskilled); 
% Data_Analysis(Paras);
% Data_Analysis_KFDA(Paras);
% Data_Analysis_KFDA2(Paras); % pairwise comparision
% Plot_2nd_day(DM,delete_unskilled,delete_high_starters)


% % % % DM = fNIRSextract(DM);
% % % % save('../../../Processed_Data/DataMatrix.mat','DM');
load('../../../Processed_Data/DataMatrix.mat','DM');
% % % % 
% % decide_period(DM,delete_unskilled);
period.start = 10; 
period.end = 25; 
MeanHbMatrixpath = MeanHb(DM,delete_unskilled,period);
% % % % fprintf('path is %s\n',MeanHbMatrixpath)
% % % % % % % PlotfNIRS(DM,delete_unskilled)
% % % % % % % PlotfNIRSByDay(DM,delete_unskilled)
% % % % % % % SigTestfNIRS(DM,delete_unskilled)
load(MeanHbMatrixpath,'MeanHbMatrix');
% % % 
% Overlay(MeanHbMatrix,delete_unskilled,period)
% Overlay_unskilled(MeanHbMatrix,delete_unskilled,period)
Sig_Test_Hb(MeanHbMatrix,delete_unskilled,period)
% % LOO_Test_Hb(MeanHbMatrix,delete_unskilled)
% % load(TSHbMatrix_path,'TSHbMatrix')
% Plot_Time_series_fNIRS
% Demo_Safety
% Overlay_non_responder(MeanHbMatrix,delete_unskilled,period)