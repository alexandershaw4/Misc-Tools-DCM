function r = getraw(D)

for g = 1:size(D.f,1)     ... each group
    for s = 1:size(D.f,2) ... each subject
        
        f = D.f{g,s};
        
        for c = 1:size(f.xY.y,2) ... each condition
            y = (f.xY.y{c})';    ... sources by samples
            
            y = clean(y);
            
            r(g,s,c,:,:) = y;
        end
        
    end
end

end

function y = clean(x)


y         = remmean(y);
[ica,A,W] = fastica(y); clc;
y         = ica;




end
