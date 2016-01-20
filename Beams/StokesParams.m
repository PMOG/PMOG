function [I,Q,U,V] = StokesParams(Ex,Ey)
% Stokes Parameters
% https://en.wikipedia.org/wiki/Stokes_parameters
Exx=Ex.*conj(Ex);
Eyy=Ey.*conj(Ey);
Exy=Ex.*conj(Ey);
I=Exx+Eyy;
Q=Exx-Eyy;
U=2*real(Exy);
V=-2*imag(Exy);
end