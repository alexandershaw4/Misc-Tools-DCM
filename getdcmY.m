function [Y,y,nt,varargout] = getdcmY(in)
% Get data + predictions from a bunch of DCMs in an array.
% + number of trials, if recorded.
% + freq vec (Hz) if is SSR/CSD & 4 outputs requested
% [averged over sources / nodes]
% AS2016 [util]

if iscell(in) && ~isstruct(in{1,1});
     try    in = loadarraydcm(in);
     catch; return; 
     end
end

% ERPs

if ~isfield(in{1,1}.xY,'Hz')

for i = 1:size(in,1)
    for j = 1:size(in,2)
        for k = 1:length(in{1,1}.xY.y)
            
            Y (i,j,k,:) = mean(in{i,j}.xY.y{k},2);  % data
            nt(i,j,k)   = in{i,j}.xY.nt(k);         % number of trials     
      try   y (i,j,k,:) = mean(in{i,j}.H{k},2);     % prediction [if avail]
      catch y = [];
      end 
      try   t           = in{i,j}.xY.pst;  end
        
        end
    end
end

Hz = [];
if nargout > 3
    varargout{1} = Hz;
    varargout{2} = t;
end

return


% SSR / CSDs

elseif isfield(in{1,1}.xY,'Hz') 
    
for i = 1:size(in,1)
    for j = 1:size(in,2)
        for k = 1:length(in{1,1}.xY.y)
            
            if ndims(in{i,j}.xY.y{k}) == 2 % ssr
            
                    Y (i,j,k,:) = mean(in{i,j}.xY.y{k},2);
              try   nt(i,j,k,:) = in{i,j}.xY.nt(k);  end     
              try   y (i,j,k,:) = mean(in{i,j}.Hc{k},2); 
              catch y = [];
              end
              try   t           = in{i,j}.xY.pst;  end
              
            elseif ndims(in{i,j}.xY.y{k}) == 3 % csd
                
                    Y (i,j,k,:,:,:) = in{i,j}.xY.y{k};
              try   nt(i,j,k,:) = in{i,j}.xY.nt(k);  
              catch nt = [];
              end
              try   y (i,j,k,:,:,:) = in{i,j}.Hc{k};
              catch y = [];
              end
              try   t           = in{i,j}.xY.pst;  end 
                
                
                
            end

        end
    end
end


if nargout > 3;
    varargout{1} = in{1,1}.xY.Hz;
end
if nargout == 5
    try   varargout{1} = Hz; 
    catch varargout{2} = t; 
    end
end



end