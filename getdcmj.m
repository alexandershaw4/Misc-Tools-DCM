function out = getdcmj(in,target,varargin)
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

try   varargin{1};
      Exp = 1;
catch Exp = 0; 
end



try % erps  
    for i = 1:size(in,1)
        for j = 1:size(in,2)
            %out{i,j} = eval(['in{i,j}',target]);
            if   ~Exp; out{i,j} = in{i,j}.Eg.(target);
            else       t1 = in{i,j}.Eg.(target);
                       t2 = exp(spm_vec(t1));
                       t1 = spm_unvec(t2,t1);
                        
                       out{i,j} = t1;
            end
        end
    end

    
catch % ssr/csd
   
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
end