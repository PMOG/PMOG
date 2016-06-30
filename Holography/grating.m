function [H] = grating(E, xx, yy, k, th, amp)
% Interferes the field E with a plane wave with parameters
% xx, yy : spatial coordinates (cartesian)
% k : wave number
% th : angle of propagation (degrees)
% amp defines whether the intensity is modulated or not
th=pi/180*th;
plane=sin(th)*xx+cos(th)*yy;
H=mod(angle(E)+k*plane+pi, 2*pi)-pi;
if amp
    EE=abs(E);
    H=(EE/max(EE(:))).*H;
end
H=uint8(255*(H+pi)/(2*pi)); % Normalize to grayscale
end
