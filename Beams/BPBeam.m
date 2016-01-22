function [E] = BPBeam(l, m, w, xx, yy)
% Generates a Bessel-Poincare Beam on coordinates [xx, yy] with parameters
% l: radial order
% m: topological charge
% w: waist
rr=hypot(xx,yy);
th=atan2(yy,xx);
E=besselj(l,rr/w).*exp(1i*m*th);
end