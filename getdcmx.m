function out  = getdcmx(in)

if iscell(in) && ~isstruct(in{1,1});
     try    in = loadarraydcm(in);
     catch; out = []; return; 
     end
end


out = cell(size(in));


for i = 1:size(in,1)
    for j = 1:size(in,2)
        for k = 1:size(in{i,j}.x)
            
            out{i,j,k} = in{i,j}.x{k};
        end
    end
end
