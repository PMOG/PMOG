function [E] = HGBeam(m, n, w, xx, yy)
% Generates a Hermite-Gaussian Beam on coordinates [xx, yy] with parameters 
% m: x order
% n: y order
% w: radius
rr2=xx.^2+yy.^2;
cx(m+1)=1; cy(n+1)=1;
E=HermiteH(cx, sqrt(2)/w*xx).*HermiteH(cy, sqrt(2)/w*yy).*exp(-rr2/w^2);
end