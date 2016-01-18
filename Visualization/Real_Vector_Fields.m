% Created by Arturo Canales

%% Real vector Fields
clear all
clc

%% Parametros
parametros()

global th r
%% Prueba 
k = 0.2;
l = 1;
sigma = -1;
phi0 = pi/4; % +/- (pi, 2*pi,..) for Radial, (pi/2, 3pi/2, ..) for azhimutal, anything else for espiral

Bessel = besselj(l,k.*r);
g1 = cos((l+sigma).*th+l*phi0);
g2 = -sigma.*sin((l+sigma).*th+l*phi0);

u = Bessel.*(g1.*cos(th)-g2.*sin(th));
v = Bessel.*(g1.*sin(th)+g2.*cos(th));

%% Plot
figure(1)
quiver(u,-v)
axis equal
