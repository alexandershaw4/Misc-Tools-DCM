function [C,Ca] = DCov(D)

try D.f{1,1}; catch try D.loader; catch;try d=D;D=dcm_hander;D.a=d;[C,Ca]=DCov(D); return;;end;return; end; end

for i = 1:size(D.f,1)
    for j = 1:size(D.f,2)
        C{i,j} = full(D.f{i,j}.Cp);
    end
end

for j = 1:size(D.f,1)
    Ca{j} = mean(cat(3,C{j,:}),3);
end

if isobject(D)
    D.p = C;
    D.info.P = 'Covar';
    D.Dubble;
end