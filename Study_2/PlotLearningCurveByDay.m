function PlotLearningCurveByDay(DataMatrix,delete_unskilled)
% Plot the learning curves by day
%% prepare data
Data_by_Sub = delete_sub(DataMatrix,delete_unskilled);
Data = Performance_segment(Data_by_Sub);
%% time 
var = 'time';
Plot_LC(Data, var)
Plot_std(Data,var)
Plot_1_12_f(Data, var)
%% error
var = 'error';
Plot_LC(Data,var)
Plot_LC_error_fitting
Plot_std(Data,var)
Plot_1_12_f(Data,var)
%% score
var = 'score';
Plot_LC(Data,var)
Plot_std(Data,var)
Plot_1_12_f(Data,var)
