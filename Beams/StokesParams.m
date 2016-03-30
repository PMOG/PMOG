function [I,Q,U,V] = StokesParams(Ex,Ey)
% Stokes Parameters
% https://en.wikipedia.org/wiki/Stokes_parameters
Exx=conj(Ex).*Ex;
Eyy=conj(Ey).*Ey;
Exy=conj(Ex).*Ey;
I=Exx+Eyy;
Q=(Exx-Eyy)./I;
U=2*real(Exy)./I;
V=2*imag(Exy)./I;
end