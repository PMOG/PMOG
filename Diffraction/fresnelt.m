function [Q] = fresnelt(x,w)
% Fresnel integral transform kernel
[u1,u2]=ndgrid(x);
Q=exp(1i*pi/4*(u1-u2).^2)*diag(w);
end