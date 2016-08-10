function DoCorr(D,p,varargin)
% Correlation matrix (1 per group) for a given parameter [p] and condition
% [c]
%
% e.g. p = 'B' [parameter]
%      c = 1   [condition index]
% 

try c = varargin{1}; end
if isempty(c); c = 0; end

X = (D.Dubble(D.GetP(p)));

if c % if this parameter has condition speific values
    
    for i = 1:size(X,2)
        D.p = VecRetainDim(squeeze(X(:,i,c,:,:,:)));
        D.Shrink;
        
        if isempty(D.p); return; end
        
        r = find(logical(var(D.p))); % remove zero variance components
        D.p = D.p(:,r);
        
        figure,corr_mat(D.p)
    end
    
else
    switch p
        case 'G'
            for i = 1:size(X,2)
                D.p = (squeeze(X(:,i,:,:,:)));
                D.Shrink;
                
                if isempty(D.p); return; end
                
                r = find(logical(var(D.p))); % remove zero variance components
                D.p = D.p(:,r);
                
                figure,corr_mat(D.p)
            end
    
        case 'T'
            for i = 1:size(X,2)
                D.p = (squeeze(X(:,i,:,:,:)));
                D.Shrink;
                
                if isempty(D.p); return; end
                
                %r = find(logical(var(D.p))); % remove zero variance components
                %D.p = D.p(:,r);
                
                figure,corr_mat(D.p)
            end    
    end
end