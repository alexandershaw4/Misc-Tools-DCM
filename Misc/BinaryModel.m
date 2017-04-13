function P = BinaryModel(DCM,varargin)
% returns model space structure as logical: 0 = parameter is OFF.
%
% AS2016

if     isstruct(DCM);                   % that's fine
elseif iscell(DCM); DCM = load(DCM{1}); % load
elseif ischar(DCM); DCM = load(DCM);
end

try   type = varargin{1}; 
catch type = 'posterior'; 
end

switch type
    case {'pC','prior'};
        V = DCM.M.pC;
    case {'Cp','posterior'};
        V = DCM.Cp;
end

% reshape
if     isstruct(V); 
elseif ismatrix(V); V = diag(V); V = spm_unvec(V,DCM.M.pE);
end

  
v = full(spm_vec(V));
F = find(v);

o = full(v)*0;

o(F) = 1;

P = spm_unvec(full(o),V);