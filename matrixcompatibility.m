function out = matrixcompatibility(in, varargin)
% Ensure compatibility of multidimentional arrays of matrices by
% cropping or padding to match sizing. Has a lot of optional inputs see
% below.
%
% Optional uses:
% 1: Use In{1,:,:} as the standard size to apply to all others.
% 2: State in the second input which cell to use: matrixcompatibility(in,3)
% 3: State in second, third and possible fourth input, the size of the
% desired matrices: out = matrixcompatibility(in, 3960, 60, 20)
%
% AS2014 [util] 
% + 4D update 2015

% Sort inputs
%-----------------------------------------
try varargin{4};
    os1   = varargin{1};
    os2   = varargin{2};
    os3   = varargin{3};
    os4   = varargin{4};
    temp1 = zeros(os1, os2, os3, os4);
catch   
try varargin{3};
    os1   = varargin{1};
    os2   = varargin{2};
    os3   = varargin{3};
    temp1 = zeros(os1, os2, os3);
catch
    try varargin{2};
    os1   = varargin{1};
    os2   = varargin{2};
    temp1 = zeros(os1, os2);
    catch
        try   varargin{1};
              orig = varargin{1};
        
        catch orig = 1;
        end
    end
end
end

try   temp1;
catch try temp1 = in{orig,:,:,:};
    catch temp1 = in{orig(1),orig(2),:,:}
    end
end

[os1, os2, os3, os4]=size(temp1);

% Decompose matrix
%------------------------------------------
[l, m, n, s] = size(in);

for q = 1:l             % x
    for o = 1:m         % y
        for p = 1:n     % z
            for r = 1:s % sup
         
          if isempty(in{q, o, p, r}) 
             out{q,o,p,r} = in{q,o,p,r};
             out{q,o,p,r} = [zeros(size(temp1))];
          else
            % Get x
            x = in{q,o,p,r};

                % Pad with zeros or crop as required
                %------------------------------------------

                [s1, s2] = size(x);

                if     s2 < os2
                       x = [x, zeros(os1,os2-s2)]; 

                elseif s2 > os2
                       x = x(:,1:os2); 
                end
                
                [s1, s2] = size(x);
                
                if     s1 < os1
                       x = [x; zeros(os1-s1,s2)]; 
                elseif s1 > os1
                       x = x(1:os1,:); 
                end

              % put x back
              out{q,o,p,r} = [x];
          end
          end
        end
    end
end


