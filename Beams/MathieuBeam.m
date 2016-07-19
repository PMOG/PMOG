function [E] = MathieuBeam(m, q, xx, yy)
% Generates a Mathieu Beam on coordinates [xx, yy]
w=acosh(xx+1i*yy);
zeta=real(w);
eta=imag(w);
E=MathieuC(m,q,eta).*MathieuJe(m,q,zeta);
end
