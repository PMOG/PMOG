function [H] = planeWave(E, xx, yy, m, theta, mode)
% Interferes the field E wirh a plane wave with parameters
% xx, yy : spatial coordinates (cartesian)
% m : frequency of oscilation
% theta : angle of propagation
% mode defines whether the intensity is modulated or not
theta=pi/180*theta;
plane=sin(theta)*xx+cos(theta)*yy;
phase=angle(E);
if mode 
    I=E.*conj(E);
    H=I.*(mod(phase+m*plane+pi, 2*pi)-pi);
else
    H=(mod(phase+m*plane+pi, 2*pi)-pi);
end
a=min(H(:)); b=max(H(:));
H=uint8(255*(H-a)/(b-a));
end

