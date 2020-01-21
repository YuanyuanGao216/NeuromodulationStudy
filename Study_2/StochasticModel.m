function paras = StochasticModel(DataMatrix,delete_unskilled)
f = fieldnames(DataMatrix)';
f{2,1} = {};
Data_by_Sub = struct(f{:});

j = 1;
if delete_unskilled == 1
    for i = 1:length(DataMatrix)
        if DataMatrix(i).skilled  == 1
            Data_by_Sub(j) = DataMatrix(i);
            j = j + 1;
        end
    end
else
    Data_by_Sub = DataMatrix;
end
N = length(Data_by_Sub);
n_trials_min = 2000;
for i = 1:N
    Traindata = Data_by_Sub(i).TrainData;
    n_trails = size(Traindata,1);
    if n_trails < n_trials_min
        n_trials_min = n_trails;
    end
end
LCmatrix = zeros(n_trials_min,N);
prompt = 'Which var? 1 for time, 2 for error, 3 for score ';
var_code = input(prompt);
for i = 1:N
    Traindata = Data_by_Sub(i).TrainData;
    y = Traindata(1:n_trials_min,var_code+3);
    LCmatrix(:,i) = y;
end

ft = fittype('b*exp(-c/x)+a');
paras = zeros(N,3);
c_code = strings(N,1);

for i = 1:N
    Code = Data_by_Sub(i).code;
    if strcmp(Code,'A')
        c_code(i) = 'b';
    elseif strcmp(Code,'B')
        c_code(i)  = 'r';
    elseif strcmp(Code,'C')
        c_code(i)  = 'k';
    end
    y = LCmatrix(:,i);
    x = 1:length(y);
    f = fit(x',y,ft);
    figure
    plot(f,x,y);
    paras(i,:) = [f.a,f.b,f.c];
end
figure
for i = 1:N
    color_code = char(c_code(i));
    plot3(paras(i,1),paras(i,2),paras(i,3),'o','Color',color_code);hold on;
end

rotate3d on
% axis equal
xlabel('a')
ylabel('b')
zlabel('c')
display(paras)
