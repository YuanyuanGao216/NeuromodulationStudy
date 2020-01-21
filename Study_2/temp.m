clear all
clc
close all
x = (0:0.2:5)';
y = 2*exp(-0.2*x) + 0.5*randn(size(x));
f = fit(x,y,'exp1');
plot(f,x,y)