function DM = delte_tRNS(DM)

n = length(DM);

for i = n:-1:1
    code = DM(i).code;
    code = code{1};
    if strcmp(code,'B')
        DM(i) = [];
    end
end

