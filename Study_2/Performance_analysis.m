clear all
clc
close all
close all hidden

DM = ReadData;
delete_unskilled = 0;
% PlotLearningCurve(DM,delete_unskilled);
% PlotLearningCurveByDay(DM,delete_unskilled);
% SigTest(DM,delete_unskilled);
% PlotCUSUM(DM);
% LearningCurveFeature(DM,delete_unskilled);%OLS
LearningCurve3Feature(DM,delete_unskilled);
% paras = StochasticModel(DM,delete_unskilled);







