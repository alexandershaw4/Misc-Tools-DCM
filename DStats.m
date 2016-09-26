function stats = DStats(D)
% D is a dcm_handler object 
%
%
% AS2016

try D.f ; catch return; end

if ~isempty(D.p) && ~isempty(D.info.P)
    % use previously extacted parameter (in D.p)
    P = D.info.P;
else
    
    % otherwise do param selection
    f = fieldnames(D.f{1}.Ep);
    [s,v] = listdlg('PromptString','Select param:',...
            'SelectionMode','single',...
            'ListString',f);
    if isempty(s); return; end
    D.GetP(f{s});
    P = f{s};
end


% Double matrix & remove empty
try D.Dubble; end
try D.Shrink; end

% what stats test
ttype = {'ttest','anova/glm'};
[s,v] = listdlg('PromptString','What statistical test?:',...
    'SelectionMode','single',...
    'ListString',ttype);

switch s
    case 1 

        % between group or within but between condition
        type = {'BETWEEN GROUPS FOR EACH CONDITION','WITHIN GROUPS BETWEEN CONDITIONS'};
        [ss,v] = listdlg('PromptString','Between groups or conditions?:',...
            'SelectionMode','single',...
            'ListString',type);
        Q = @squeeze;
        switch ss
            case 1 % between groups
                D.p = squeeze(D.p);
                
                switch P
                    case 'B'
                        nd = ndims(D.p);
                        ns = size(D.p,nd); % number of sources
                            for k = 1:size(D.p,3) % conditions
                                for to = 1:ns % to 
                                    for from = 1:ns % from
                                        clear X
                                        for gr = 1:size(D.p,2) % group
                                            X{gr} = Q(D.p(:,gr,k,to,from));
                                        end
                                        X = squeeze(innercell(X));
                                        [H,pval,~,T] = ttest2(X(1,:),X(2,:));
                                        
                                        O{k}(to,from) = pval;
                                        h{k}(to,from) = H;
                                        t{k}(to,from) = T.tstat;
                                        
                                    end
                                end
                            end
                            
                            stats.p = O;
                            stats.H = h;
                            stats.T = t;
                            try stats.names = D.info.nodes; end
                            try stats.conditions = D.info.conditions; end
                            return
                            
                    case {'G','T','D','J'}; % not trial specific params
                        nd   = ndims(D.p);
                        ns   = size(D.p,nd);
                        nprm = size(D.p,nd-1);
                        
                        for prm = 1:nprm
                            for node = 1:ns
                                clear X
                                X{1} = Q(D.p(:,1,prm,node));
                                X{2} = Q(D.p(:,2,prm,node));
                            
                                X = squeeze(innercell(X));
                                [H,pval,~,T] = ttest2(X(1,:),X(2,:));
                                
                                O(prm,node) = pval';
                                h(prm,node) = H';
                                t(prm,node) = T.tstat;
                            
                            end
                        end
                        
                        stats.p = O;
                        stats.H = h;
                        stats.t = t;
                        
                        try stats.names = D.info.nodes; end
                        return
                        
                    case {'C','R'}
                        nd = ndims(D.p);
                        ninp = size(D.p,nd);
                        
                        for i = 1:ninp
                            clear X
                            X{1} = Q(D.p(:,1,i));
                            X{2} = Q(D.p(:,2,i));
                            
                            X = squeeze(innercell(X));
                            [H,pval,~,T] = ttest2(X(1,:),X(2,:));
                            
                            O(i) = pval;
                            h(i) = H;
                            t(i) = T.tstat;
                            
                        end
                        
                        stats.p = O;
                        stats.h = h;
                        stats.t = t;
                        
                        try if ss == 'C';
                                stats.names = D.info.nodes; 
                            end
                        end
                        return
                        
                    case {'S','F'}
                        switch P
                            case 'F'; D.p = D.p'; 
                        end;
                            
                        
                        [H,pval,~,T] = ttest2(D.p(:,1),D.p(:,2));
                        
                        stats.p = pval;
                        stats.h = H;
                        stats.t = T.tstat;
                        
                        return;
                        
                        
                        
                        
                        
                    case 'A' % this is specific to the cmc i think
                        nd   = ndims(D.p);
                        ns   = size(D.p,nd);     % n sources
                        ncon = size(D.p,(nd-2)); % n connections
                        
                        for nc = 1:ncon
                            for to = 1:ns
                                for from = 1:ns
                                    clear X
                                    X{1} = Q(D.p(:,1,nc,to,from));
                                    X{2} = Q(D.p(:,2,nc,to,from));
                                    
                                    X = Q(innercell(X));
                                    [H,pval,~,T] = ttest2(X(1,:),X(2,:));
                                    
                                    O{nc}(to,from) = pval;
                                    h{nc}(to,from) = H;
                                    t{nc}(to,from) = T.tstat;
                                    
                                end
                            end
                        end
                        stats.p = O;
                        stats.h = h;
                        stats.t = t;
                        try stats.names = D.info.nodes; end
                        stats.ConType = {'Fwd:sp->ss','Fwd:sp->dp','Bkw:dp->sp','Bkw:dp->ii'};
                
                end
                
            case 2 % between conditions within gorup
                        
                        %not written yet
                        fprintf('\nnot written yet');
                        return
                        
                        
                        
                        
                        
                        
                        
        end % end switch type
    
    case 2 % anova 
        
        switch P
            case 'B';
                nd = ndims(D.p);
                
                return;
            
        end
        
        
        

end % end stat type

                
        
        
