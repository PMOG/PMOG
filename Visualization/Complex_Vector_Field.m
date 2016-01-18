% Codigo
clear all
clc
% Parametros
parametros()

% Bessel Poincare
global th r



%% Prueba Elipse

% Theta = pi/4;
% 
% Eox = cos(Theta);
% Eoy = sin(Theta);
% Ex = Eox.*ones(N,N);
% Ey = -Eoy.*exp(-1i*pi/2).*ones(N,N);
% 
% 
% E = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey)); 
% 
% Ex = Ex./E;
% Ey = Ey./E;
% 
% 
% display(max(abs(Ex(:))))
% display(max(abs(Ey(:))))
% display(max(E(:)))


%% Prueba 1 (Radial, Azimuthal and Espiral)
% k = 0.3;
% l = 1;
% sigma = -1;
% phi0 = pi/4;
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


%% Prueba Bessel - Poincare
% k = 0.2;
% 
% l0 = 0;
% l1 = 1;
% sigma0 = 1;
% sigma1 = -1;
% 
% 
% Bessel0 = besselj(l0,k.*r);
% Bessel1 = besselj(l1,k.*r);
% 
% Ex = Bessel0.*exp(1i*th).*(cos(th) - 1i*sin(th)) + Bessel1.*(cos(th) + 1i*sin(th));
% Ey = Bessel0.*exp(1i*th).*(sin(th)+ 1i*cos(th)) + Bessel1.*(sin(th)-1i*cos(th));
% 
% E = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey));
% 
% Ex = Ex./E;
% Ey = Ey./E;

%% Prueba Modifyd Besell Poincare





%% Parametros Stokes y Elipse de Polarizacion

% https://en.wikipedia.org/wiki/Stokes_parameters
% http://spie.org/publications/optipedia-pages/press-content/fg05/fg05_p12-14_stokes_polarization_parameters
% https://en.wikipedia.org/wiki/Elliptical_polarization#Polarization_ellipse


I = Ex.*conj(Ex) + Ey.*conj(Ey);
Q = Ex.*conj(Ex) - Ey.*conj(Ey);
% U = Ex.*conj(Ey) + Ey.*conj(Ex);
% V1 = 1i*(Ex.*conj(Ey) - Ey.*conj(Ex));
U = 2*real(Ex.*conj(Ey));
V = -2*imag(Ex.*conj(Ey));
% I = abs(Q).^2 + abs(U).^2 + abs(V).^2;

La = Q + 1i*U;
absLa = sqrt(abs(Q).^2 + abs(U).^2);


% Elipse
ao = (1/2)*(I + absLa); % Semieje mayor
bo = (1/2)*(I - absLa); % Semieje menor
%thetao = (1/2)*atan(U./Q); % Angulo con respecto a eje x
thetao = (1/2).*angle(La);
h = sign(V); % Signo de orientacion de elipse (+ Left-Hand = Blue. - Right-Had + Red)


% % Fase Relativa
% Imaginario = imag(Ex.*conj(Ey));
% Real = real(Ex.*conj(Ey));
% Beta = atan(Imaginario./Real)/2;
% 
% % Semi-axis
% % thetao = abs(Ey);
% Factor1 = sqrt(1-(sin(2*thetao)).^2.*(sin(2*Beta)).^2);
% 
% ao = sqrt(E).*sqrt((1+Factor1)/2);
% bo = sqrt(E).*sqrt((1-Factor1)/2);




%% Sampling
Sampling = 64;
Spacing1 = 1:floor(N/Sampling):N;
a1 = ao(Spacing1,Spacing1);
b1 = bo(Spacing1,Spacing1);
ref = -pi/2; %For having agreement with polarization ellipse
theta1 = thetao(Spacing1,Spacing1)+ref ; 

% Plot ellipse
divs=size(a1);
big=[1024, 1024];
small=big./divs;
pts=2*(small(1)+small(2));
L=max(abs([a1(:); b1(:)]));
A(small(1), divs(1), small(2), divs(2))=uint8(0);
for i=1:divs(1)
    for j=1:divs(2)
        a=a1(i,j)/L;
        b=b1(i,j)/L;
        t=theta1(i,j);
        A(:,i,:,j)=ellipseCart(a,b,t,small,pts);
    end
end
A=reshape(A, big);
figure(1);
imshow(A,'Border','tight','InitialMagnification','fit');
colormap(flipud(gray(256)));
axis equal

imwrite(A, 'oh yea.jpg');
      
%% Plot      
figure(7)

subplot(2,2,1)
imagesc(ao)
title( ' ao ') 
axis equal

subplot(2,2,2)
imagesc(bo)
title( ' bo ') 
axis equal

subplot(2,2,3)
imagesc(ao + bo)
axis equal

subplot(2,2,4)
imagesc(thetao)
title( ' thetao ') 
colormap(hot)
axis equal


figure(8)
subplot(2,2,1)
imagesc(Ex.*conj(Ex))
title( ' Ex ') 
axis equal

subplot(2,2,2)
imagesc(Ey.*conj(Ey))
title( ' Ey ') 
axis equal

subplot(2,2,3)
imagesc(E)
title( ' E ') 
axis equal
colormap(hot)



% display(max(I(:)))
% display(max(Q(:)))
% display(max(U(:)))
% display(max(V(:)))
% display(max(h(:)))
% display(max(thetao(:)))

% figure(8)
% subplot(2,2,3)
% imagesc(U)
% title( ' U ') 
% subplot(2,2,4)
% imagesc(V)
% title( ' V ') 
% subplot(2,2,2)
% imagesc(Q)
% title( ' Q ') 
% subplot(2,2,1)
% imagesc(I)
% title( ' I ') 

