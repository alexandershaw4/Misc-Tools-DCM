function o = DoBMS(d)
% Auto BMS for use with dcm_handler methods.
%
% - needs data present in D.a
% - needs data to have 'Mod_n' in the file names, e.g.
%    Sub1_blahblah_Mod_1_blah.mat
%    Sub1_blahx_Mod_2_anything.mat
%
% AS2016

for i = 1:size(d,1)
    sp(i,:) = stringparts(d(i,:));
    n   = find(strcmp(sp{i},'Mod'));
    id  = n+1;% model id
    for j = 1:size(d,2)
        ID(i,j) = str2num(sp{i,j}{id});
    end
end


fI = d;

n = 0;
for j = 1:size(ID,2)
    for i = 1:size(ID,1)
        n = n + 1;
        FI(n) = fI(i,j);
        IF(n) = ID(i,j);
    end
end

[Y,I] = sort(IF,'ascend');
Dat   = (FI(I));

ns = length(Dat)/length(unique(Y)); % n subs [pooled if groups]
nm = length(Dat)/ns;                % n mods
fI = reshape(Dat,[ns nm]);          % subs by models


for xi = 1:size(fI,1)
    for yi = 1:size(fI,2)
        clear DCM; 
        load(fI{xi,yi});
        F(xi,yi) = DCM.F;
        
    end
end

% normalise to lowest F & calc posterior prob - see spm_api_bmc
%----------------------------------------------------------------
FF = F';
F  = sum(F',2);
   
F    = F - min(F);          % F = normed F
i    = F < (max(F) - 32);
P    = F;
P(i) = max(F) - 32;
P    = P - min(P);
P    = exp(P);
P    = P/sum(P);            % Winning model


% deltaF = how much bigger winner is than 2nd winner:
F2    = F;
[~,i] = max(F2);
F2(i) = 0;

dF    = max(F) - max(F2);

% plot
%----------------------------------------------------------------
nm = 1:length(F);
subplot(121),plot(nm,F,'o',nm,P*max(F),'--r');
set(gca, 'XTick',1:length(nm), 'XTickLabel',nm); xlim([0 nm(end)+1]);
title('Posterior probabilities (Winning = dotted peak','Fontsize',18);
subplot(122),bar(F)
set(gca, 'XTick',1:length(nm), 'XTickLabel',nm); xlim([0 nm(end)+1]);
title('Posterior probabilities','Fontsize',18);

% Select winning model and reduce intrinsic connectivity?
%----------------------------------------------------------------
W      = find(round(P)); % winning model
Mods   = fI(:,W);        % corresponding files

o.F  = F;    % posterior F
o.PF = P;    % posterior binary
o.W  = Mods; % winning models
o.ModWin = W;% model number
o.df = dF;   % delta F (how much better than 2nd best)

