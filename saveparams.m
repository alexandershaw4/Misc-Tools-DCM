function d = saveparams(f,p)
% Extract a parameter 'p' for a bunch of DCMs listed in the
% subject x condition matrix 'f' (and save).
%
% If re-run for a different parameter, will append to existing .mat
%  
% e.g.  f = {'Sub1.mat','Sub2.mat'};
%       d = saveparams(f,{'Eg.J','Ep.B'})
%
% AS2016

if iscell(f); try f = loadarraydcm(f); end; else return; end
if isstr(p);      p = {p}; elseif ~iscell(p); return; end


for i = 1:size(f,1)
    for j = 1:size(f,2)
        x = f{i,j};
        try x = x.DCM; end
        
        for ip = 1:length(p)
            
            n = stringparts(p{ip});
            n = n{end};
            eval([n,' = ','x.' p{ip},';']);
            
            sv = sprintf('Sub_%d_Cond_%d',i,j);
            
            try   save(sv,'-append',n);
            catch save(sv,n);
            end
            
            d{i,j,ip} = eval(n);
        end
    end
end