function Data_by_Sub = delete_sub(DataMatrix,delete_unskilled)

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