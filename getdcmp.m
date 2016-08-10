function out = getdcmp(in,target,varargin)
% Get parameter values from a bunch of DCMs in an array.
% Second input is the field to retrieve, e.g. "B" to get posterior beta
% matrix (i.e. the letter corresponds to fieldnames of DCM.Ep).
%
% *Update: optionally add third input = 1 to return exp(n) values
% AS2016 [util]

if iscell(in) && ~isstruct(in{1,1});
     try    in = loadarraydcm(in);
     catch; out = []; return; 
     end
end

out = cell(size(in));

if strcmp(target,'J');
    out = getdcmj(in,target);
    return;
end

if strcmp(target,'x');
    out = getdcmx(in);
    return;
end


try   varargin{1};
      Exp = 1;
catch Exp = 0; 
end

%try eval(['in{1,1}',target])
    
    for i = 1:size(in,1)
        for j = 1:size(in,2)
            %out{i,j} = eval(['in{i,j}',target]);
            if   ~Exp; out{i,j} = in{i,j}.Ep.(target);
            else       t1 = in{i,j}.Ep.(target);
                       t2 = exp(spm_vec(t1));
                       t1 = spm_unvec(t2,t1);
                        
                       out{i,j} = t1;
            end
        end
    end
%catch fprintf('Warning: coudn''t find parameter %s\n',target);
%end