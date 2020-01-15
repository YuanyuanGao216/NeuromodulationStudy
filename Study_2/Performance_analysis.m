clear all
clc
close all
close all hidden

DM = ReadData;
delete_unskilled = 1;
% PlotLearningCurve(DM,delete_unskilled);
% PlotLearningCurveByDay(DM,delete_unskilled);
SigTest(DM,delete_unskilled);
% PlotCUSUM(DM);







