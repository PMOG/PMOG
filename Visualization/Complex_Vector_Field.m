% Codigo
clear all
% Parametros
parametros()

% Bessel Poincare
global th r


%% Prueb
% Theta =  - pi/4; 
% 
% Eox = 3;
% Eoy = 1;
% Ex = Eox.*ones(N,N);
% Ey = Eoy.*exp(-1i.*1.5).*ones(N,N);
% thetao = Theta.*ones(N,N);
% 
% E1 = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey)); 
% 
% 
% 
% E = (Ex.*conj(Ex)+ Ey.*conj(Ey)); 
% 
% disp(max(abs(Ex(:))))
% disp(max(abs(Ey(:))))
% disp(max(E(:)))

%% Prueba 0
k = 0.4;
l1 = 1;
l2 = 1;
tho = pi/2;
sigma1 = 1;
sigma2 = -1;

J1 = besselj(l1,k.*r);
J2 = besselj(l2,k.*r);

Phase1 = exp(-2*1i.*((l1+sigma1).*th + l1.*tho));
Phase2 = exp(-2*1i.*((l2+sigma2).*th + l2.*tho + pi/2));

f = (1 + Phase1).*cos(th) - sigma1.*exp(1i*pi/2).*(1 + Phase2).*sin(th);
g = (1 + Phase1).*sin(th) + sigma2.*exp(1i*pi/2).*(1+Phase2).*cos(th);

Ex = J1.*f;
Ey = J2.*g;

E = (Ex.*conj(Ex)+ Ey.*conj(Ey)); 

Ex = J1.*f./max(E(:));
Ey = J2.*g./max(E(:));

%% Prueba 1
% k = 0.2;
% l = 1;
% sigma = -1;
% theta0 = pi/2;
% 
% Bessel = besselj(l,k.*r);
% 
% g1 = cos((l+sigma).*th+l*theta0);
% g2 = -sigma.*sin((l+sigma).*th+l*theta0);
% Ex = Bessel.*(g1.*cos(th)-g2.*sin(th));
% Ey = Bessel.*(g1.*sin(th)+g2.*cos(th));
% 
% E = sqrt(Ex.*conj(Ex)+ Ey.*conj(Ey));

%% Prueba 2
% k = 0.2;
% 
% l0 = 0;
% l1 = 1;
% sigma0 = -1;
% sigma1 = 1;
% theta0 = 0;
% 
% Bessel0 = besselj(l0,k.*r);
% Bessel1 = besselj(l1,k.*r);
% 
% Ex = Bessel0.*exp(1i*th).*(cos(th) - 1i*sin(th)) + Bessel1.*(cos(th) + 1i*sin(th));
% Ey = Bessel0.*exp(1i*th).*(sin(th)+ 1i*cos(th)) + Bessel1.*(sin(th)-1i*cos(th));
% 
% E = (Ex.*conj(Ex)+ Ey.*conj(Ey));
% 
% Ex = Bessel0.*exp(1i*th).*(cos(th) - 1i*sin(th)) + Bessel1.*(cos(th) + 1i*sin(th))./max(E(:));
% Ey = Bessel0.*exp(1i*th).*(sin(th)+ 1i*cos(th)) + Bessel1.*(sin(th)-1i*cos(th))./max(E(:));

% figure(1)
% imagesc(abs(Ex.*Ex))
% axis equal
% figure(2)
% imagesc(abs(Ey.*Ey))
% axis equal
% figure(3)
% imagesc(E)
% axis equal
%% Parametros

% Fase Relativa
Imaginario = imag(Ex.*conj(Ey));
Real = real(Ex.*conj(Ey));
Beta = atan(Imaginario./Real);

% Semi-axis
thetao = abs(Ey);
Factor1 = sqrt(1-(sin(2*thetao)).^2.*(sin(2*Beta)).^2);

ao = sqrt(E).*sqrt((1+Factor1)/2);
bo = sqrt(E).*sqrt((1-Factor1)/2);

%% Sampling
Sampling = 16;
Spacing1 = 1:floor(N/Sampling):N;
a1 = ao(Spacing1,Spacing1);
b1 = bo(Spacing1,Spacing1);
ref = 0;
theta1 = thetao(Spacing1,Spacing1)+ref ; 

% Plot ellipse
divs=size(a1);
big=[512, 1024];
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
A=imgaussfilt(A);
figure(1);
imshow(A,'Border','tight','InitialMagnification','fit');
colormap(gray(256));
axis equal
        
%% Parametros Elipse        
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