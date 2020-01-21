function LR = OLSmodel(LC,code)

if strcmp(code,'score')
    n = length(LC);
    X = 1:n;
    Y = LC;
    Y = 300 - Y;
    log_X = log(X)';
    log_Y = log(Y+1);

    bA = regress(log_Y,[ones(size(log_X)),log_X]);
    sApred = bA(1)+bA(2)*(log(1:n))';
    figure
    plot(X,300-Y,'o');hold on;
    plot(1:n,300-(exp(sApred)-1),'-');hold on;
    set(gcf, 'Position',  [100, 100, 250, 200])
    set(gca,'FontSize',12,'LineWidth',5)
    LR = bA(2);
else
    n = length(LC);
    X = 1:n;
    Y = LC;

    log_X = log(X)';
    log_Y = log(Y);

    bA = regress(log_Y,[ones(size(log_X)),log_X]);
    sApred = bA(1)+bA(2)*(log(1:n))';
    figure
    plot(X,Y,'o');hold on;
    plot(1:n,exp(sApred),'-');hold on;
    set(gcf, 'Position',  [100, 100, 250, 200])
    set(gca,'FontSize',12,'LineWidth',1.0)
    LR = bA(2);
end
