function GroupPloterp(D)
% DCM: Plot ERP + model prediction in Group by Condition subplot
%
% D.Y & D.y are 4D doubles returned by getdcmY or class D.GetY;
%
% AS2016

try D.Y; D.y; catch; D.GetY; end

[ng,nsub,nc,nsamp] = size(D.Y);

try       unit = D.t;    ut = 'time (ms)' ;
end
if ~isempty(D.Hz)
    try   unit = D.Hz;   ut = 'Frequency (Hz)'; end
end
if isempty(unit)
    unit = 1:nsamp;ut = 'samples' ;       
end


Q  = @squeeze;
lw = 2;

n = 0;
for i = 1:ng
    for k = 1:nc
        n = n + 1;
        subplot(ng,nc,n);
        plot(unit,Q(mean(D.Y(i,:,k,:),2)),'LineWidth',lw); hold on;
        plot(unit,Q(mean(D.y(i,:,k,:),2)),'r','LineWidth',lw);
        
        title(sprintf('Group %d  Condition %d  ',i,k),'fontsize',18);
        if n == 1; legend({'Data','Prediction'}); end
        xlabel(ut,'fontsize',18);
        set(gca,'fontsize',18);
        
    end
end