function x = autoplot(in,varargin)
% a utility plotter that handles structures, cell arrays and matrices 
% (& combinations of), currently up to 4D. Handles infinite layer
% structures and cell arrays through recursive calls. Output 'x' is a cell
% array of all the matrices found (useful for putting large structures into
% one cell array). Second, third & fourth [optional] inputs are for
% stopping after first pass [depth iteraton] and killing plots. Designed
% as a quick plotter that doens't need data in a specific format.
% AS2016 [util]

Plot = 1; try if varargin{4} == 0; Plot = 0; end; end


% sort inputs [allowing recursive calls]:
%----------------------------------------
if iscell(in)
   if   ischar(in{1}); x = 0; 
   else
       
   [sx,sy]   = size(in);
   [sz1,sz2] = size(in{1});
   in        = matrixcompatibility(in);
   temp      = spm_cat(in);
   x         = reshape(full(temp),[sz1 sz2 sx sy]); % reshape full matrix
   x         = permute(x,[3 4 1 2]);                % permute to original
  
   try if varargin{2} == 1; return; end; end
   end
elseif isnumeric(in);
       x       = in;
       try if varargin{2} == 1; return; end; end

elseif isstruct(in)
       f     = fieldnames(in);
       for i = 1:length(f)
           if ~ischar(in.(f{i})) && ~isempty(in.(f{i}))
                try   temp{i} = autoplot(squeeze(cat(3,in.(f{i}))),1,[],0);
                catch temp{i} = autoplot(              in.(f{i}),  1,[],0);
                end
           end
       end
       for i    = 1:length(temp)
           try   x{i} = autoplot(full(temp{i}),[],f{i},Plot);
           catch x{i} = autoplot(     temp{i} ,[],f{i},Plot);
           end
       end
       return;
end

try if varargin{3} == 0; return; end;end % kill plots
try if Plot        == 0; return; end;end
    
% get dimentions for plot[s]:
%----------------------------------------
x = squeeze(x);
S = size(x);
N = ndims(x);
    figure;
Q = @squeeze;

if nargin == 3;
     lab = varargin{2};
else lab = ' ';
end

if     sum(sum(sum(sum(x)))) == 0;
       close;
    
elseif isvector(x)
       % line plot vector with points
       plot(x,'--o');    
    
elseif N == 2 && S(1)==S(2)
       % adjacency matrix
       imagesc(x);
       
elseif N == 2 && S(1)~=S(2)
       % just a line plot with points
       plot(x,'--o');
       
elseif N == 3
       % line subplot over first dimention
       for np = 1:S(1)
           subplot(S(1),1,np),imagesc(Q(x(np,:,:)));
       end
       
elseif N == 4
       xi = S(1);
       yi = S(2);
       np = 0;
       for i = 1:xi
           for j = 1:yi
               np = np + 1;
               subplot(xi,yi,np), plot(Q(x(i,j,:,:)));
           end
       end
        
end

title(lab);

return

