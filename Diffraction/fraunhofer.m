function [Q,x] = fraunhofer(N)
% Fraunhoffer integral transform
L=sqrt(2*pi*N);
h=L/N;
n=(-N/2:N/2-1)';
x=h*n;
Q=@(u) h^2/(2*pi)*fftshift(fft2(fftshift(u)));
end