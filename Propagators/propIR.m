function [u2] = propIR(u1, L, lambda, z);
% propagation - impulse response approach
% assumes same x and y side lengths and
% uniform sampling
% u1    -  Source plane field
% L     -  Source and observation plane side length
% lambda - Wavelength
% z     -  Propagation distance
% u2    -  Observation plane field

[M, N] = size(u1);      % Get input field array size
dx = L/M;               % Sample interval
k = 2*pi/lambda;        % Wavenumber

x = -L/2 : dx : L/2 - dx;  % Spatial coordinates
[X, Y] = meshgrid(x, x);

h = 1 / (j*lambda*z) * exp(j*k/(2*z)*(X.^2+Y.^2));  % Impulse
H = fft2(fftshift(h))*dx^2; % Shift transfer function
U1 = fft2(fftshift(u1));    % Shift, fft source field
U2 = H.*U1;                 % Multiply
u2 = ifftshift(ifft2(U2));  % Inverted fft, center observed field
end