function out = shrink(x)
% Shrink an m by n matrix by removing complete rows or columns of zeros.
%
% AS2016

if iscell(x); x = innercell(x); end
if ndims(x) > 2; out = x; return; end

x = full(x);
s = size(x);

for i = 1:s(1)
    e(i) = ~any(x(i,:));
end

i = find(e);
t = 1:s(1);
t = t(~ismember(t,i));
x = x(t,:);

for i = 1:s(2)
    o(i) = ~any(x(:,i));
end

i = find(o);
t = 1:s(2);
t = t(~ismember(t,i));

out = x(:,t);