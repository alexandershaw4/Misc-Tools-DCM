 function ModelFields = DCMVECNAMES(DCMM,varargin)
% for getting the model field names & size from a dcm (or any structure!).
% useful for plotting & identifying models in spm_dcm_post_hoc
%
% Alex 2014
% update: can handle cell inputs


% Get Model Structure & Field Names
%------------------------------------------
try if varargin{1}==1; try DCMM = DCMM.M.pE; catch; DCMM = DCMM.pE; end; end; end

if iscell(DCMM);
   for g = 1:length(DCMM)
       Mod(g,:) = DCMVECNAMES(DCMM{g},1);
   end
       Mod         = Mod';
       ModelFields = reshape(Mod,[size(Mod,1)*size(Mod,2),1]);
       return
end

NL     = zeros(size(spm_vec(DCMM))); % size
Fields = fieldnames(DCMM);           % parameters

for  i    = 1:length(Fields)
     x(i) = length(spm_vec(DCMM.(Fields{i})));
end; %x(find(~x)) = 1;

% Rebuild list
%------------------------------------------

      NL   = num2cell(NL);
      y    = x(1);
for   i    = 1:length(x)
try   y(i) = x(i) + y(i-1); 
catch y(i) = x(i); end
end
      y    = [1, 1+y(1:i-1)]; 
      
     NL(y) = Fields;

% Fill in blanks
%------------------------------------------
for j = 1:length(NL)
    if NL{j} == [0];
       NL{j} = NL{j-1};
    end
end

% Add numbering
%------------------------------------------
Nums    = ones(size(NL));
for k   = 2:length(NL)
  try if NL{k} == NL{k-1}; Nums(k) = Nums(k-1)+1; end
  catch  NL{k}; end
end; 

NL      = strcat(NL,num2str(Nums));
for l   = 1:length(NL)
 NL{l}  = NL{l}(NL{l}~=' ');
end

% Return
%------------------------------------------
ModelFields = NL; 
return

