close all
%tRNS
figure
Fs = 100;
t = 0:1/Fs/60:10;
n = length(t);
std = 0.333;
y = std.*randn(n,1);
plot(t,y)
ylabel('Current intensity (mA)')
xlabel('Time (min)')
xticks([0 5 10])
ax = gca;
ax.YGrid = 'on';
set(gca,'FontSize',18)
set(gca, 'FontName', 'Arial')
box off
set(gcf, 'Position',  [77 1211 435 166])
% tDCS
figure
y = ones(1,n)*1;
t_ramp = 0.5/(1/Fs/60);
y(1:t_ramp) = (1/0.5) * t(1:t_ramp);
y(end-t_ramp+1:end) = -(1/0.5) * t(1:t_ramp)+1;
plot(t,y)
ylabel('Current intensity (mA)')
xlabel('Time (min)')
xticks([0 5 10])
ax = gca;
ax.YGrid = 'on';
set(gca,'FontSize',18)
set(gca, 'FontName', 'Arial')
box off
set(gcf, 'Position',  [77 1211 435 166])
ylim([-2 2])
% Sham
figure
y = zeros(1,n);
t_ramp = 0.5/(1/Fs/60);
y(1:t_ramp) = (1/0.5) * t(1:t_ramp);
y(end-t_ramp+1:end) = -(1/0.5) * t(1:t_ramp)+1;
plot(t,y)
ylabel('Current intensity (mA)')
xlabel('Time (min)')
xticks([0 5 10])
ax = gca;
ax.YGrid = 'on';
set(gca,'FontSize',18)
set(gca, 'FontName', 'Arial')
box off
set(gcf, 'Position',  [77 1211 435 166])
ylim([-2 2])