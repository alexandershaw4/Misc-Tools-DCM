function o = innercell(x)
% for converting embedded arrays into full n-dim matrices
% 
% e.g.
%   t = {[randn(4,4)] [randn(4,4)] [randn(4,4)]}
%   y = innercell(t)
%   
%   returns y as a full 4D double of size y(3,1,4,4)
%   because size(t) = 1x3 and size t{1} = 4x4
%
%
% - obviously each cell of the input should be the same size, although this
% is dealt with by filling mismatched cells with the mean of the matrix in
% cell{1,1} (but retaining sparsity and 0's).
%
% AS2016

global nx

[nx,s] = CellSize(x);                     % full dimensions
y      = reshape(full(spm_vec(nx)),fliplr(s));  % reshape

if ~ismember(ndims(y),2:2:2.^10);
     nd = 1:(ndims(y)+1);
else nd = 1:ndims(y);
end
p      = flipud(reshape(nd,[2 length(nd)/2])'); % permutation order
p      = spm_vec(p')';                          % reshape permutation vector
o      = permute(y,p);                          % output

end

function [nx,S] = CellSize(nx)
    
    S = size(nx);  
    if iscell(nx{1});
        nx = CheckSize(nx);
        [~,dS] = CellSize(nx{1});
        S = [S dS];
    else
        S = [S size(nx{1})];
    end
end

function t = CheckSize(x)
    
    S = size(x{1,1});
    for i = 1:size(x,1)
        for j = 1:size(x,2)
            s = size(x{i,j});
            if ~all(S == s);
               % if dim mismatch, fill with mean of x{1,1}
               % while retaining structure
               v      = spm_vec(x{1,1});
               vi     = find(v);
               m      = v*0;
               m(vi)  = mean(v(vi));
               x{i,j} = spm_unvec(m,x{1,1});
            end
        end
    end
    t = x;
end
