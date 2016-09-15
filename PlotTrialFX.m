function PlotTrialFX(D,p)


try    X = (D.Dubble(D.GetP(p)));
catch; return; 
end




switch upper(p)
    
    % trial specific effects (beta matrix)
    case 'B'
        [ns,ng,nc,z,from,to] = size(X);
         X = squeeze(mean(X,1)); % mean over nsubs in group
        for grp = 1:ng
            figure

            ymx = max(spm_vec(X(:,:,:,:)));
            ymn = min(spm_vec(X(:,:,:,:)));
            for c = 1:nc
                subplot(1,nc,c), imagesc(squeeze(X(grp,c,:,:))); 
                caxis([ymn ymx]);
                set(gca, 'XTick',1:length(D.info.nodes), 'XTickLabel',D.info.nodes);
                set(gca, 'YTick',1:length(D.info.nodes), 'YTickLabel',D.info.nodes);
            end
        end

end