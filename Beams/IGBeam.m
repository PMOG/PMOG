function [E] = IGBeam(p, m, q, w, xx, yy)
% Generates a Ince-Gaussian Beam on coordinates [xx, yy]
rr2=(xx.^2+yy.^2)/w^2;
uu=acosh((xx+1i*yy)/w);
E=InceC(p,m,q,imag(uu)).*InceC(p,m,q,1i*real(uu)).*exp(-rr2);
end