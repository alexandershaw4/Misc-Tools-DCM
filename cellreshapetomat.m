function y = cellreshapetomat(p)

sp  = size(p);
sp2 = size(p{1});
dp  = spm_vec(p);

np = reshape(dp,[sp2 sp]);

dims = 1:ndims(np);

y  = permute(np,[dims(~ismember(dims,[1 2])) [1 2]]);