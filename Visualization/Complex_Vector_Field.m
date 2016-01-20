% Parametros
parametros()
global x y


%% Prueba Elipse

% Theta = pi/4;
% 
% Eox = cos(Theta);
% Eoy = sin(Theta);
% Ex = Eox.*ones(N,N);
% Ey = -Eoy.*exp (-1i*pi/2).*ones(N,N);
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
[Ex,Ey]=BPBeam(0.2,1,2,x,y);
E=hypot(Ex, Ey);
Ex=Ex./E;
Ey=Ey./E;

%% Parametros Stokes y Elipse de Polarizacion
% http://spie.org/publications/optipedia-pages/press-content/fg05/fg05_p12-14_stokes _polarization _parameters
% https://en.wikipedia.org/wiki/Elliptical_polarization#Polarization _ellipse

[I,Q,U,V]=StokesParams(Ex,Ey);
absLa=hypot(Q,U); %La=Q+1i*U;

% Elipse
ao=(I+absLa)/2; % Semieje mayor
bo=(I-absLa)/2; % Semieje menor
thetao=atan2(U,Q)/2; % Angulo con respecto a eje x
h=sign(V); % Signo de orientacion de elipse (+ Left-Hand = Blue. - Right-Had = Red)

%% Sampling
Sampling = 32;
Spacing1 = round(linspace(1,N,Sampling));
a1 = ao(Spacing1,Spacing1);
b1 = bo(Spacing1,Spacing1);
h1 = h(Spacing1,Spacing1);
ref = -pi/2; % For having agreement with polarization ellipse
theta1 = thetao(Spacing1,Spacing1)+ref; 

%% Plot ellipse
clear R G B A;
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
        T=ellipseCart(a,b,t,small,pts); 
        if h1(i,j) > 0
            R(:,i,:,j)=T;
        elseif h1(i,j) < 0
            G(:,i,:,j)=T;
        else
            B(:,i,:,j)=T;
        end
    end
end
R=reshape(R, big);
G=reshape(G, big);
B=reshape(B, big);
A=cat(3,R,G,B);
A=imgaussfilt(A);
figure(1);
imshow(A,'Border','tight','InitialMagnification','fit');
colormap(gray(256));
axis equal;

imwrite(A, 'oh yea.jpg');
      
%% Plot      
figure(2);

subplot(2,2,1);
imagesc(ao);
title('ao');
axis equal;

subplot(2,2,2);
imagesc(bo);
title('bo');
axis equal;

subplot(2,2,3);
imagesc(ao + bo);
axis equal;

subplot(2,2,4);
imagesc(thetao);
title('thetao'); 
colormap(hot);
axis equal;


figure(3);
subplot(2,2,1);
imagesc(Ex.*conj(Ex));
title('Ex');
axis equal;

subplot(2,2,2);
imagesc(Ey.*conj(Ey));
title('Ey');
axis equal;

subplot(2,2,3);
imagesc(E);
title('E'); 
axis equal;
colormap(hot);



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

