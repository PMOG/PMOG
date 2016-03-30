N=640;
[xx,yy]=meshgrid(linspace(-1,1,N));

w=1/sqrt(pi*8);
Q=1/sqrt(2)*[1 1; 1i -1i];
m1=1; m2=0;

L=BPBeam(m1,m1,w,xx,yy);
R=BPBeam(m2,m2,w,xx,yy);
[Ex, Ey]=TransformBeam(Q, L, R);
A=ellipseCart(Ex,Ey,32);

figure(1);
h=imshow(A,'Border','tight','InitialMagnification','fit');
axis equal;

imwrite(A, 'PolarizationEllipse.png');