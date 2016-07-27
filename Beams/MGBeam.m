function [E] = MGBeam(m, q, w, xx, yy)
% Generates a Mathieu-Gauss Beam on coordinates [xx, yy]
uu=acosh((xx+1i*yy)/w);
zeta=real(uu);
eta=imag(uu);
rr2=(xx.^2+yy.^2)/w^2;
E=MathieuS(m,q,eta).*MathieuJo(m,q,zeta).*exp(-rr2);
end
