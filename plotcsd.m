function h = plotcsd(DCM)

if iscell(DCM)
    for i = 1:length(DCM)
        y(i,:,:,:,:) = (cat(4,DCM{i}.xY.y{:}));
        m(i,:,:,:,:) = (cat(4,DCM{i}.Hc{:}));
    end
    y = permute(y,[1 5 2 3 4]);
    m = permute(m,[1 5 2 3 4]);
end
    y = squeeze(mean(y,1)); % mean over subs
    m = squeeze(mean(m,1));
    
nc = size(y,1); % conditions
nf = size(y,2); % freqs
ns = size(y,3); % nodes

Hz = DCM{i}.xY.Hz;

for c = 1:nc
    Y = squeeze(y(c,:,:,:));
    M = squeeze(m(c,:,:,:));
    figure, title(['condition ',num2str(c)]);
    
    n = 0;
    for xi = 1:ns
        for yi = 1:ns
            n = n + 1;
            subplot(ns,ns,n),...
                plot(Hz,squeeze(real(Y(:,xi,yi))),'b'); hold on
                plot(Hz,squeeze(real(M(:,xi,yi))),'r');
                
                if xi == yi; plot(Hz,squeeze(real(Y(:,xi,yi))),'g');
                end
        end
    end
end