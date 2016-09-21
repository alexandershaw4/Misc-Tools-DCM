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
                                        [H,pval] = ttest2(X(1,:),X(2,:));
                                        
                                        O{k}(to,from) = pval;
                                        h{k}(to,from) = H;
                                        
                                    end
                                end
                            end
                            
                            stats.p = O;
                            stats.H = h;
                            return
                            
                    case {'G','T'};
                        
                        
                        
                        
                end
                
            case 2 % between conditions within gorup
                        
                        % not written yet
                        fprintf('\nnot written yet');
                        return
        end % end switch type
    
    case 2 % anova 
        
        switch P
            case 'B';
                
            
            
        end
        
        
        

end % end stat type

                
        
        
