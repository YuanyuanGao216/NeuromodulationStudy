% clear all
clc
close all
close all hidden

%% Performance data analysis

% load the performance data
% DM = ReadData;

% decide whether to delete learners
delete_unskilled = 1;% 0 - all the learners; 1 - only skilled learners; 2 - only unskilled learners

% Plot the learning curves
% PlotLearningCurveByDay(DM,delete_unskilled);

% SigTest(DM,delete_unskilled);
% PlotCUSUM(DM);

% Plot_2nd_day(DM,delete_unskilled,delete_high_starters)

%% fNIRS data analysis

%% first process the fNIRS data and save it
% DM = fNIRSextract(DM);
% save('../../../Processed_Data/DataMatrix.mat','DM');

%% after save, we can directly load the data
load('../../../Processed_Data/DataMatrix.mat','DM');

%% decide which period of fNIRS to use
% decide_period(DM,delete_unskilled);

%% we decide to use 10 to 20s
period.start = 10; 
period.end = 25; 
%% extract mean value of 10-20s and save it to path
MeanHbMatrixpath = MeanHb(DM,delete_unskilled,period);

%% we can load the data from the path
% load(MeanHbMatrixpath,'MeanHbMatrix');

%% overlay the mean values to the brain atlas
Overlay(MeanHbMatrix,delete_unskilled,period)
Overlay_unskilled(MeanHbMatrix,delete_unskilled,period)

%% do sig test to the mean values
Sig_Test_Hb(MeanHbMatrix,delete_unskilled,period)

%% plot the time seris fNIRS
Plot_Time_series_fNIRS

%% Plot safety data
% Demo_Safety