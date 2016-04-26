function [H] = grating(E, xx, yy, k, th, mode)
% Interferes the field E with a plane wave with parameters
% xx, yy : spatial coordinates (cartesian)
% k : wave number
% th : angle of propagation (degrees)
% mode defines whether the intensity is modulated or not
th=pi/180*th;
plane=sin(th)*xx+cos(th)*yy;
phase=angle(E);
H=mod(phase+k*plane+pi, 2*pi)-pi;
if mode 
    H=(E.*conj(E)).*H;
end
H=uint8(255*(H+pi)/(2*pi)); % Normalize to grayscale
end