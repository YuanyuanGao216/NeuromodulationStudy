function LearningCurve3Feature(DataMatrix,delete_unskilled)
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
%three learning curve features
N = length(Data_by_Sub);
LC_3features = zeros(N,3);
c_code = strings(N,1);
s_code = zeros(N,1);
for i = 1:N
    Code = Data_by_Sub(i).code;
    if strcmp(Code,'A')
        c_code(i) = 'b';
        s_code(i) = 1;
    elseif strcmp(Code,'B')
        c_code(i)  = 'r';
        s_code(i) = 2;
    elseif strcmp(Code,'C')
        c_code(i)  = 'k';
        s_code(i) = 3;
    end
    Traindata = Data_by_Sub(i).TrainData;
    Initial_level = mean(Traindata(1:3,6));
    Final_level = mean(Traindata(40:50,6));
    % within 98 seconds on 2 consecutive repetitions
    Time = Traindata(:,4);
    index = find(Time < 98);
    for j = 2:length(index)
        if index(j)-1 == index(j-1)
            index_prof = index(j);
            break
        end
    end
    No_trials = index_prof;
    LC_3features(i,:) = [Initial_level,Final_level,No_trials];
end
figure
for i = 1:N
    color_code = char(c_code(i));
    plot3(LC_3features(i,1),LC_3features(i,2),LC_3features(i,3),'o','Color',color_code);hold on;
end
rotate3d on
% axis equal
xlabel('Inital level')
ylabel('Final level')
zlabel('No of trials')
display(LC_3features)

[Y, W, lambda] = LDA(LC_3features,s_code);

figure
for i = 1:N
    color_code = char(c_code(i));
    plot3(Y(i,1),Y(i,2),Y(i,3),'o','Color',color_code);hold on;
end
rotate3d on