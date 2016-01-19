%% Poincare Sphere

% Codigo
clear all
clc
close all
% Parametros
parametros()

% Bessel Poincare
global th r
%% Prueba Bessel - Poincare
k = 0.25;

l0 = 0;
l1 = 1;
sigma0 = 1;
sigma1 = -1;


Bessel0 = besselj(l0,k.*r);
Bessel1 = besselj(l1,k.*r);

Ex = Bessel0.*exp(1i*th).*(cos(th) - 1i*sin(th)) + Bessel1.*(cos(th) + 1i*sin(th));
Ey = Bessel0.*exp(1i*th).*(sin(th)+ 1i*cos(th)) + Bessel1.*(sin(th)-1i*cos(th));

E = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey));

Ex = Ex./E;
Ey = Ey./E;
%% Prueba 1 (Radial, Azimuthal and Espiral)
% k = 0.3;
% l = 1;
% sigma = -1;
% phi0 = pi/3;
% 
% Bessel = besselj(l,k.*r);
% 
% g1 = cos((l+sigma).*th+l*phi0);
% g2 = -sigma.*sin((l+sigma).*th+l*phi0);
% Ex = Bessel.*(g1.*cos(th)-g2.*sin(th));
% Ey = Bessel.*(g1.*sin(th)+g2.*cos(th));
% 
% E = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey));
% 
% Ex = Ex./E;
% Ey = Ey./E;
%% Parametros Stokes y Elipse de Polarizacion

% https://en.wikipedia.org/wiki/Stokes_parameters
% http://spie.org/publications/optipedia-pages/press-content/fg05/fg05_p12-14_stokes_polarization_parameters
% https://en.wikipedia.org/wiki/Elliptical_polarization#Polarization_ellipse


% I = Ex.*conj(Ex) + Ey.*conj(Ey);
Q = Ex.*conj(Ex) - Ey.*conj(Ey);
% U = Ex.*conj(Ey) + Ey.*conj(Ex);
% V1 = 1i*(Ex.*conj(Ey) - Ey.*conj(Ex));
U = 2*real(Ex.*conj(Ey));
V = -2*imag(Ex.*conj(Ey));
I = abs(Q).^2 + abs(U).^2 + abs(V).^2;

La = Q + 1i*U;
absLa = sqrt(abs(Q).^2 + abs(U).^2);


% Elipse
ao = (1/2)*(I + absLa); % Semieje mayor
bo = (1/2)*(I - absLa); % Semieje menor
%thetao = (1/2)*atan(U./Q); % Angulo con respecto a eje x
thetao = (1/2).*angle(La);
h = sign(V);


%% Sampling
Sampling = 32;
Spacing1 = 1:floor(N/Sampling):N;
a1 = ao(Spacing1,Spacing1);
b1 = bo(Spacing1,Spacing1);
ref = -pi/2; % For having agreement with polarization ellipse
theta1 = thetao(Spacing1,Spacing1)+ref ; 

S1 = Q(Spacing1,Spacing1);
S2 = U(Spacing1,Spacing1);
S3 = V(Spacing1,Spacing1);

% Plot ellipse
divs=size(a1);
big=[1024, 1024];
small=big./divs;
pts=2*(small(1)+small(2));
L=max(abs([a1(:); b1(:)]));
R(small(1), divs(1), small(2), divs(2))=uint8(0);
G(small(1), divs(1), small(2), divs(2))=uint8(0);
B(small(1), divs(1), small(2), divs(2))=uint8(0);
for i=1:divs(1)
    for j=1:divs(2)
        a=a1(i,j)/L;
        b=b1(i,j)/L;
        t=theta1(i,j);
        if h(i,j) > 0
            B(:,i,:,j)=ellipseCart(a,b,t,small,pts);
        elseif h(i,j) < 0
            G(:,i,:,j)=ellipseCart(a,b,t,small,pts);
        end
    end
end
B=reshape(B, big);
B=imgaussfilt(B);
figure(1);
imshow(B,'Border','tight','InitialMagnification','fit');
colormap((gray(256)));
axis equal
%% Plot
figure(2)
% surf(Q,U,V,'LineStyle','none')
% 
% hold on
% surf(S1,S2,S3,'.','MarkerSize',14)
surf(S1,S2,S3,'LineStyle','none')
% shading FLAT 
% shading INTERP 
% shading FACETED 
% axis ( [-1.1 1.1], [-1.1 1.1],[-1.1 1.1])
axis equal
figure(3)
subplot(2,2,1)
imagesc(Q)
title('Q')
axis equal
subplot(2,2,2)
imagesc(U)
title('U')
axis equal
subplot(2,2,3)
imagesc(V)
title('V')
axis equal