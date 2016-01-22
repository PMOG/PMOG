% Parametros
N=512;
[xx,yy]=meshgrid(sqrt(pi/(2*N))*(-N:2:N-2));

%% Prueba Bessel - Poincare
A=1/sqrt(2)*[1 1; 1i -1i];
Ex=BPBeam(1,2,w,xx,yy);
Ey=BPBeam(2,1,w,xx,yy);
[Ex, Ey]=TransformBeam(A, Ex, Ey);
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
th1 = thetao(Spacing1,Spacing1)+ref; 

%% Plot ellipse
clear R G B A;
divs=size(a1);
big=size(E);
small=big./divs;
pts=2*(small(1)+small(2));
R(small(1), divs(1), small(2), divs(2))=uint8(0);
G(small(1), divs(1), small(2), divs(2))=uint8(0);
B(small(1), divs(1), small(2), divs(2))=uint8(0);
for i=1:divs(1)
    for j=1:divs(2)
        col=[255*(1+h1(i,j))/2,0, 255*(1-h1(i,j))/2];
        T=ellipseCart(a1(i,j),b1(i,j),th1(i,j),small,pts);
        R(:,i,:,j)=col(1)*T;
        G(:,i,:,j)=col(2)*T;
        B(:,i,:,j)=col(3)*T;
    end
end
R=reshape(R, big);
G=reshape(G, big);
B=reshape(B, big);
idx=(R==0 & G==0 & B==0);
[I1,I2,I3]=ind2rgb(round(255*(E/max(E(:))).^2),gray(256));
R(idx)=255*I1(idx);
G(idx)=255*I2(idx);
B(idx)=255*I3(idx);
A=cat(3,R,G,B);

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

