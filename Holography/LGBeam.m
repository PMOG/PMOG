function [E] = LGBeam(p, l, w, xx, yy)
% Generates a Laguerre-Gaussian Beam on coordinates [xx, yy] with parameters 
% p: radial order
% l: topologial charge
% w: radius
th=atan2(yy, xx);
rr2=(xx.^2+yy.^2)/w^2;
c(p+1)=1;
E=(2*rr2).^(abs(l)/2).*exp(-rr2+1i*l*th).*LaguerreL(c, abs(l), 2*rr2);
end