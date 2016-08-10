function F = getdcmf(in)
% Get fit values from a bunch of DCMs in an array.
% AS2016 [util]

if iscell(in) && ~isstruct(in{1,1});
     try    in = loadarraydcm(in);
     catch; return; 
     end
end

for i = 1:size(in,1)
    for j = 1:size(in,2)
        F(i,j) = in{i,j}.F; 
    end
end