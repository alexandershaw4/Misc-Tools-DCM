function stringO = stringparts(string)
% Split string into parts around a common seperator (delimit). 
% Autodetects commas, dashes, underescores, backslash(space)
% Works on structures and cells and most stuff
% Alex


% Sort inputs
%---------------------------------------
try tp = fieldnames(string(1));
    try eval(['string(1).',tp{1}, ';']);
        try for tp1 = 1:length(string);
            fnms{tp1} = eval(['fieldnames(string(tp1));']);
        end; end
    string    = [tp, cat(2,fnms{:})];
    [tp2 tp3] = size(string);
    string = reshape(string, [1, tp2*tp3]);
    string = {string}';
    end
end


if isstruct(string);
    string1 = fieldnames(string);
    if iscell(eval(['string.' string1{1}]));
    for m = 1:length(string1)    
      str = eval(['string.' string1{m}]);
      try   string2 = [string2, str]; catch string2 = str; end
    end
    end
    try   string = [string1; string2']; 
    catch string = string1;
    end
    string = {string'};
end

if iscell(string); 
    dim    = ndims(string);
    string = squeeze(cat(dim+1,string));   
    if iscell(string{1})
       string =  squeeze(cat(3,string{:}));
       [a b]  = size(string);
       string = reshape(string, [a*b, 1]);
    end
end


% Check whether to loop inputs
%---------------------------------------
if ~iscell(string)
    stringO = parts(string);
    
elseif iscell(string)
    for i = 1:length(string)
        file         = string{i};
        stringO{i,:} = parts(file);
        if isempty(stringO); 
           stringO{i}=0; 
        end
    end
  end
end

function stringO=parts(file)

    % Look for common fileparts
    %---------------------------------------
    sep = 0;
    if  find(file=='-');
        sep = [find(file=='-'), sep];
    end
    if  find(file=='_');
        sep = [find(file=='_'), sep];
    end
    if  find(file==',');
        sep = [find(file==','), sep];
    end
    if  find(file=='\');
        sep = [find(file=='\'), sep];
    end
    if  find(file=='.');
        sep = [find(file=='.'), sep];
    end
    sep     = unique(sep);
    sep     = sep(sep~=0);
    stringO = seperate(file, sep);
end

function stringO = seperate(file, sep)
    if isempty(sep); stringO=[]; end
    
    if length(sep) == 1 && sep~=0;
    stringO{1} = file(1:sep-1);
    stringO{2} = file(sep+1:end);
    elseif length(sep)~=0

        for         j = 1:length(sep)+1
            if      j ==1;             stringO{j} = file(1:sep(j)-1);
            elseif  j ==length(sep)+1; stringO{j} = file(sep(end)+1:end);
            else                       stringO{j} = file(sep(j-1)+1:sep(j)-1);
            end
        end
    end
end