function DCM_Graph(DCM)
% For DCM's using the canonical microcircuit (CMC), but could easily be
% made to take any input adjacency matrices.
%
% Plots [square] adjacency / connectivity matrix on a circle of nodes.
%
% AS2016 [dcm]

F1 = exp(DCM.Ep.A{1}); F1 = F1.*logical(round(F1)); % forward  (sp>ss)
F2 = exp(DCM.Ep.A{2}); F2 = F2.*logical(round(F2)); % forward  (sp>dp)
B1 = exp(DCM.Ep.A{3}); B1 = B1.*logical(round(B1)); % backward (dp>sp)
B2 = exp(DCM.Ep.A{4}); B2 = B2.*logical(round(B2)); % backward (dp>ii)
L  = (DCM.Ep.M.*double(logical(DCM.Ep.M)));         % plus laterals
C  = ones(size(F1));                                % all poss
l  = DCM.xY.name;                                   % node labels

theta = linspace(0,2*pi,1+length(F1));
[x,y] = pol2cart(theta,1);

bx = x *.98;  % this is just to stop lines overlapping!
by = y *.98;  
cx = x * .96; 
cy = y * .96; 
dx = x * .94; 
dy = y * .94; 

[indfa1,indfa2]=ind2sub(size(F1),find(F1(:)));
[indfb1,indfb2]=ind2sub(size(F2),find(F2(:)));
[indba1,indba2]=ind2sub(size(B1),find(B1(:)));
[indbb1,indbb2]=ind2sub(size(B2),find(B2(:)));
[indC1 ,indC2]=ind2sub(size(C),find(C(:)));
[indL1 ,indL2]=ind2sub(size(L),find(L(:)));

h=figure(1);clf(h); hold on;
for i = 1:length(F1)
    txt1 = ['\downarrow ',l{i}];
    text(x(i),(y(i)+.1),txt1);
end

% colour scheme
gr = [.2 .2 .2]*.25;
bl = [0  0  1 ]; bl2 = [0 .5  1];
rd = [1  0  0 ]; rd2 = [1 .5  0];

plot(x,y,'.k','markersize',20);hold on
plot([x(indC1); x(indC2)],[y(indC1); y(indC2)],'-.' ,'Color',gr,'LineWidth',.5);
plot([x(indL1); x(indL2)],[y(indL1); y(indL2)],'-.m','LineWidth',1.5);

plot([x(indfa1); x(indfa2)],[y(indfa1); y(indfa2)],'--','Color',bl,'LineWidth',1.5);
plot([bx(indfb1); bx(indfb2)],[by(indfb1); by(indfb2)],'--','Color',bl2,'LineWidth',1.5);

plot([cx(indba1); cx(indba2)],[cy(indba1); cy(indba2)],'--','Color',rd,'LineWidth',1.5);
plot([dx(indbb1); dx(indbb2)],[dy(indbb1); dy(indbb2)],'--','Color',rd2,'LineWidth',1.5);

axis equal off


