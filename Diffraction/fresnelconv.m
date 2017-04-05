function [Q,x] = fresnelconv(N)
% Fresnel integral transform
L=sqrt(2*pi*N);
h=L/N;
n=(-N/2:N/2-1)';
x=h*n;
[xx,yy]=ndgrid(x);
A=exp(-1i*(xx.^2+yy.^2)/(2));
Q=@(u) (h^2/(2*pi))^2*N*fftshift(fft2(fftshift(A).*fft2(fftshift(u))));
end