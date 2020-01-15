function PlotCUSUM(DataMatrix)
Data_by_Sub = DataMatrix;
f_CUSUM = figure;
hold on
f_CUSUM_each = figure;
hold on

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
n = 120;
j1 = 1;
j2 = 1;
j3 = 1;
for i = 1:length(Data_by_Sub)
    S_name = string(Data_by_Sub(i).name);
    CUSUM_scores = Data_by_Sub(i).CUSUM;
    n = length(CUSUM_scores);
    figure(f_CUSUM);plot(1:n, CUSUM_scores,'*-','DisplayName',string(S_name));
    figure(f_CUSUM_each);
    
    stim_code = Data_by_Sub(i).code;
    if strcmp(stim_code,'A')
        col = 1;
        plot_num = (j1-1)*3+col;
        j1 = j1 + 1;
        color_code = 'b';
    elseif strcmp(stim_code,'B')
        col = 2;
        plot_num = (j2-1)*3+col;
        j2 = j2 + 1;
        color_code = 'r';
    elseif strcmp(stim_code,'C')
        col = 3;
        plot_num = (j3-1)*3+col;
        j3 = j3 + 1;
        color_code = 'k';
    end
    subplot(7,3,plot_num);hold on;
    plot(1:n, CUSUM_scores,'*-','DisplayName',S_name,'color',color_code);
    h_h0 = plot(0:n,ones(1,n+1)*h0);
    h_h1 = plot(0:n,ones(1,n+1)*h1);
    set(h_h0                               ,...
        'LineStyle'         ,'--'         ,...
        'LineWidth'         ,2.0        ,...
        'Color'             , 'k'       ,...
        'DisplayName'       , 'h0');
    set(h_h1                               ,...
        'LineStyle'         ,'-'         ,...
        'LineWidth'         ,2.0        ,...
        'Color'             , 'k'      ,...
        'DisplayName'       , 'h1');
    title(S_name)
end
figure(f_CUSUM);set(gcf, 'Position',  [100, 100, 500, 300])
figure(f_CUSUM_each);set(gcf, 'Position',  [100, 100, 1000, 1000])
figure(f_CUSUM)

h_h0 = plot(0:n,ones(1,n+1)*h0);
h_h1 = plot(0:n,ones(1,n+1)*h1);
set(h_h0                               ,...
    'LineStyle'         ,'--'         ,...
    'LineWidth'         ,2.0        ,...
    'Color'             , 'k'       ,...
    'DisplayName'       , 'h0');
set(h_h1                               ,...
    'LineStyle'         ,'-'         ,...
    'LineWidth'         ,2.0        ,...
    'Color'             , 'k'      ,...
    'DisplayName'       , 'h1');

hXLabel = xlabel('Trial');
hYLabel = ylabel('CUSUM score');
set([hXLabel, hYLabel]                  ,...
    'FontName'      ,'Times New Roman'  ,...
    'FontSize'      ,15                 );

legend('Location','BestOutside');