function po = permuterBMS(D)
% do BMS with leave-one-out permutations
%
% input D is a dcm object created with dcm_make or a structure with field
% 'a' containing cell array of dcm filenames organised sub x group (n x 2)
%
% Default nperms = 1e3
%
% AS2016

try D.a; catch error('please set up D.a using dcm_make.m'); return; end

[ng,ns] = size(D.a);

np  = 1e3;     % n perms
nm  = 21;      % n mods
npg = ns / nm; % num subs per group


% sort input list around model number so that D.a(1,:) == all subs model 1
% then all subs model 2 and so on. And D.A(2,:) == all patients model 1,
% then all patients model 2 and so on.

% group 1
s  = stringparts(D.a(1,:));
s  = squeeze(cat(3,s{:}));
mi = find(strcmp(s(:,1),'Mod')) + 1;
for i = 1:length(s)
    mod(i) = str2num(s{mi,i});
end
[Y,I] = sort(mod,'ascend');
D.a(1,:) = D.a(1,I);

% group 2
s  = stringparts(D.a(2,:));
s  = squeeze(cat(3,s{:}));
mi = find(strcmp(s(:,1),'Mod')) + 1;
for i = 1:length(s)
    mod(i) = str2num(s{mi,i});
end
[Y,I] = sort(mod,'ascend');
D.a(2,:) = D.a(2,I);

% now do the leave-one-out and recalc BMS:
for i = 1:np
    
    excld = randi(npg); % identify subject to kill
    for j = 1:nm        % find all instances and kill
        if j == 1; Eadd = excld;
        else       Eadd = Eadd + npg;
        end
        E(j) = Eadd;
    end
    
    f    = D.a(:,~ismember(1:ns,E));
    o(i) = DoBMS(f); close;
    
    
end
    
po = o; return;


    