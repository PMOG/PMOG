N=32*20;
[xx,yy]=meshgrid(linspace(-1,1,N));

w=1/sqrt(pi*8);
Ex=BPBeam(0,1,w,xx,yy);
Ey=BPBeam(1,0,w,xx,yy);
Q=1/sqrt(2)*[1 1; 1i -1i];
[Ex, Ey]=TransformBeam(Q, Ex, Ey);
E=hypot(Ex, Ey);

% Stokes Parameters
[I,Q,U,V]=StokesParams(Ex./E,Ey./E);
L=hypot(Q,U);

% Elipse
a=(I+L)/2; % Semi-major axis
b=(I-L)/2; % Semi-minor axis
phi=atan2(U,Q)/2; % Rotation angle
h=sign(V); % Handedness: (-) Lefthanded = Blue (+) Right-Hand = Red

% Sampling
samp = 32;
ip = round(linspace(1,N,samp));
a1 = a(ip,ip);
b1 = b(ip,ip);
h1 = h(ip,ip);
phi1 = phi(ip,ip); 

% Plot ellipse
col=eye(3);
divs=size(a1);
big=size(E);
small=big./divs;
pts=2*small(1)+2*small(2);
[R,G,B]=ind2rgb(round(255*(E/max(E(:))).^2),gray(256));
for i=1:divs(1)
    for j=1:divs(2)
        [idx,idy]=ellipseCart(a1(i,j),b1(i,j),phi1(i,j),small,pts);
        id=(((j-1)*small(1)+idx+1)*divs(1)-i)*small(2)+idy+1;
        p=col(2-h1(i,j),:);
        R(id)=p(1);
        G(id)=p(2);
        B(id)=p(3);
    end
end
A=cat(3,R,G,B);

% Plot      
figure(2);
cmap=hot(256);
colormap(cmap);

subplot(2,3,1);
imagesc(a); title('a'); axis equal off;
subplot(2,3,2);
imagesc(b); title('b');axis equal off;
subplot(2,3,3);
imagesc(phi); title('theta'); axis equal off;

subplot(2,3,4);
imagesc(Ex.*conj(Ex)); title('|Ex|^2'); axis equal off;

subplot(2,3,5);
imagesc(Ey.*conj(Ey)); title('|Ey|^2'); axis equal off;

subplot(2,3,6);
imagesc(E.*E); title('|E|^2=|Ex|^2+|Ey|^2'); axis equal off;

figure(1);
imshow(A,'Border','tight','InitialMagnification','fit');
axis equal;
imwrite(A, 'PolarizationEllipse.png');