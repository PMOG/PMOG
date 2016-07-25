function [E] = MGBeam(m, q, xx, yy)
% Generates a Mathieu-Gauss Beam on coordinates [xx, yy]
w=acosh(xx+1i*yy);
zeta=real(w);
eta=imag(w);
rr2=xx.^2+yy.^2;
E=MathieuC(m,q,eta).*MathieuJe(m,q,zeta).*exp(-rr2);
end
