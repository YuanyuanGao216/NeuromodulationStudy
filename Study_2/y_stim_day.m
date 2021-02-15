function [y,stim,day] = y_stim_day(data,y,stim,day,stim_type)

tmp = data(1,~isnan(data(1,:)));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
% elseif strcmp(stim_type,'tRNS')
%     stim = [stim, ones(1,n).*2];
end
day = [day, zeros(1,n)];

tmp = data(12,~isnan(data(12,:)));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
% elseif strcmp(stim_type,'tRNS')
%     stim = [stim, ones(1,n).*2];
end
day = [day, ones(1,n)];

follow = reshape(data(13:15,:),1,[]);
tmp = follow(~isnan(follow));
n = length(tmp);
y = [y,tmp];
if strcmp(stim_type,'Sham')
    stim = [stim, zeros(1,n)];
elseif strcmp(stim_type,'tDCS')
    stim = [stim, ones(1,n)];
% elseif strcmp(stim_type,'tRNS')
%     stim = [stim, ones(1,n).*2];
end
day = [day, ones(1,n).*2];
end