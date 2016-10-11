function [] = propLag(n)
lambda=1;
k=2*pi/lambda;

w0=sqrt(2)/2;          % waist size
zr=pi/lambda*w0^2;     % Rayleigh Range

[Dr,r,w]=lagD(n);         % Differeantial operator and 1D nodes
[Dt2,t]=periodicD2(n);    % 2D nodes
[rr,tt]=ndgrid(r,t);   
xx=rr.*cos(tt);
yy=rr.*sin(tt);

nframes=100;           % Simualtion parameters
dz=5*zr/nframes;

E=(rr.^4).*exp(-rr/2).*(exp(2i*tt)+exp(1i*tt));  % Electric field
U=rr.*E;
Qr=expm(1i*dz/(2*k)*Dr^2);     % Propagation operator
Qt=expm(1i*dz/(2*k)*Dt2);

map=hsv(256);
phase=angle(E)/(2*pi);
phase=phase-floor(phase);
H=ind2rgb(uint8((length(map)-1)*phase), map);
V=mat2gray(abs(E).^2);
V=cat(3, V, V, V);
h=surf(xx,yy,abs(0*U).^2); 
set(h,'CData',H.*V);
shading interp;
axis equal; axis off;
view(0,90);

% Propagation
for i=1:nframes
    U=exp(1i*k*dz)*(Qr*U*Qt.');
    E=U./rr;
        
    phase=angle(U)/(2*pi);
    phase=phase-floor(phase);
    H=ind2rgb(uint8((length(map)-1)*phase), map);
    V=mat2gray(abs(U).^2);
    V=cat(3, V, V, V);
    set(h,'ZData',abs(0*U).^2);
    set(h,'CData',H.*V);
    drawnow;
end
end