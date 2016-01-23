function [B, idx, idy] = sampler(A, x, y)
% A(x,y):[-1,1]^2 -> Reals
idx=1+floor(size(A,1)*(x+1)/2);
idy=1+floor(size(A,2)*(y+1)/2);
id=(idx-1)*size(A,2)+idy;
B=A(id);
end