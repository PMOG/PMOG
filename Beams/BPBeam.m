function [Ex, Ey] = BPBeam(k,l0,l1,xx,yy)
% Bessel Poincare Beam
rr=hypot(xx,yy);
tt=atan2(yy,xx);

J0 = besselj(l0,k*rr);
J1 = besselj(l1,k*rr);

Ex = J0+J1.*exp(1i*tt);
Ey = 1i*(J0-J1.*exp(1i*tt));
end