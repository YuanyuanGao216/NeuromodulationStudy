function DM = fNIRSextract(DM)
hmr2path = '../../../../Tools/homer2_src_v2_3_10202017';
oldpath = cd(hmr2path);
setpaths;
cd(oldpath)
DataDir = '../../../Raw_Data/Study_#2';
Subfolders = dir(DataDir);
if ispc
    start_point = 3;
else
    start_point =4;
end
for i = start_point:length(Subfolders)
    name = Subfolders(i).name;
    fprintf('subject is %s\n',name);
    SubDir = [DataDir,'/',name];
    Files = dir(fullfile(SubDir,'*.nirs'));
    index = 0;
    for k = 1:length(DM)
        subname = DM(k).name;
        if strcmp(subname,name)
            index = k;
        end
    end
    if index == 0
        fprintf('cannot find %s\n',name);
        continue
    end
    DM(index).fNIRS = cell(13,1);
    NIRSmatrix_temp = [];
    k = 1;
    for j = 1:length(Files)
        filename = Files(j).name;
        fprintf('fnirs file is %s\n',filename);
        fNIRSfile = load([SubDir,'/',filename],'-mat');
        if strcmp(filename,'NIRS-2019-08-14_008.nirs')
            [NIRSmatrix_temp,flag] = fNIRSprocess(fNIRSfile);
        elseif strcmp(filename,'NIRS-2019-08-14_011.nirs')
            [NIRSmatrix2,flag] = fNIRSprocess(fNIRSfile);
            NIRSmatrix = [NIRSmatrix_temp;{[]};NIRSmatrix2];
            DM(index).fNIRS{k} = NIRSmatrix;
            k = k+1;
        else
            [NIRSmatrix,flag] = fNIRSprocess(fNIRSfile);
            DM(index).fNIRS{k} = NIRSmatrix;
            k = k+1;
        end
        if flag == 0
            fprintf('Stim number is not even, please check %s: %s\n',name,filename);
            return
        elseif flag == 2 && ~strcmp(filename,'NIRS-2019-08-17_005.nirs')
            fprintf('Stim number is larger than 10, please check %s: %s\n',name,filename);
            return
        end
    end
end

save('../../../Processed_Data/DataMatrix.mat','DM');