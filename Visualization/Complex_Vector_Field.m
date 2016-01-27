N=32*20;
[xx,yy]=meshgrid(linspace(-1,1,N));

w=1/sqrt(pi*8);
Q=1/sqrt(2)*[1 1; 1i -1i];
Ex=BPBeam(0,1,w,xx,yy);
Ey=BPBeam(1,0,w,xx,yy);
[Ex, Ey]=TransformBeam(Q, Ex, Ey);
A=ellipseCart(Ex,Ey,4);

figure(1);
h=imshow(A,'Border','tight','InitialMagnification','fit');
axis equal;

imwrite(A, 'PolarizationEllipse.png');