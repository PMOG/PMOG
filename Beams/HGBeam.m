function [E] = HGBeam(m, n, w, xx, yy)
% Generates a Hermite-Gaussian Beam on coordinates [xx, yy] with parameters 
% m: x order
% n: y order
% w: waist
cx(m+1)=1; cy(n+1)=1;
E=HermitePsi(cx, sqrt(2)/w*xx).*HermitePsi(cy, sqrt(2)/w*yy);
end