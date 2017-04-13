function h = ploterp(DCM)
% Auto retrieve data and predictions + labels (if available) from a [set
% of] DCM model(s). Either pass a single DCM structure as input, or a cell
% array of model names to load and average. Handles multi-channel and
% multi-condition ERP models.
%
% AS2016 [plot]

%try plot = @Bplot; end

% if cell in is >1 by >1, push data from cols 2+ into col 1
%--------------------------------------------------------------------------
% if iscell(DCM) && size(DCM,1) > 1 && size(DCM,2) > 1
%     npl = size(DCM,1); 
%     for i = 1:size(DCM,1)
%         for j = 2:size(DCM,2)
%             DCM{i,1}.xY.y = [DCM{i,1}.xY.y DCM{i,j}.xY.y];
%         try DCM{i,1}.H    = [DCM{i,1}.H DCM{i,j}.H]; end
%         try DCM{i,1}.Hc   = [DCM{i,1}.Hc DCM{i,j}.Hc]; end   
%         end
%     end
%     
%     ploterp(DCM(:,1)); 
%     return        
% end

% if is cell array of models, make a mean model structure
%--------------------------------------------------------------------------
if iscell(DCM)
    if isstruct(DCM{1})
        for i = 1:length(DCM)
            try   P(i,:) = spm_vec(DCM{i});
            catch P(i,:) = mean(P(1:i-1,:));
            end
            d.DCM = DCM{1};
        end
    else
        for i = 1:length(DCM)
            d      = load(DCM{i});
            P(i,:) = spm_vec(d.DCM); % extract values as vector
        end
    end
    P   = squeeze(mean(P,1));    % means over subjects
    NEW = spm_unvec(P,d.DCM);    % place means into new DCM
    DCM = NEW;                   % BUT have lost labels & functions
    DCM.xY.name = d.DCM.xY.name; % manually copy channel labels for plot
    DCM.xU.name = d.DCM.xY.name; % and condition labels if available
    
end


% Do the plot[s]
%--------------------------------------------------------------------------
%h = figure;   % 
Y = DCM.xY.y; % data
try   H = DCM.H;T=0; % prediction [ERP]
catch H = DCM.Hc;T=1;% prediction [Hz] 
end

% data dimensions
[~  ,t] = size(Y);    % n trials / observations
[erp,s] = size(Y{1}); % n erps * sensors

% get labels
sLab = 1:s;   try sLab = DCM.xY.name; end
cLab = 1:t;   try cLab = DCM.xU.X;    end; if ismatrix(cLab) && ~isvector(cLab); cLab = 1:size(cLab,2); end
Time = 1:erp; try Time = DCM.xY.pst;  end; tit = 'Time (ms)';

if T; Time = DCM.xY.Hz; tit = 'Frequency (Hz)'; end

% plot
lw    = 2;
n     = 0;
for j = 1:t
    for i = 1:s ... loop sensors per trial

        n = n + 1;
        subplot(t,s,n),...
            plot(Time,Y{j}(:,i),'--b','LineWidth',lw); hold on;
            plot(Time,H{j}(:,i),'--r','LineWidth',lw); hold off;
            
            if isnumeric(cLab); C = num2str(cLab(j)); else C = cLab{j}; end
            if isnumeric(sLab); S = num2str(sLab(i)); else S = sLab{i}; end
            
            title([S ' Cond: ' C]);
            xlabel(tit,'fontsize',18);
            set(gca,'fontsize',18);
    end
end
