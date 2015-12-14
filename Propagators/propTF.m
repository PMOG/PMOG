function [u2] = propTF(u1, L, lambda, z);
% propagation - transfer function approach
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

fx = -1/(2*dx) : 1/L : 1/(2*dx) - 1/L;  % Frequency coordinates
[FX, FY] = meshgrid(fx, fx);

H = exp(-j*pi*lambda*z*(FX.^2 + FY.^2));    % Transfer function
H = fftshift(H);            % Shift transfer function
U1 = fft2(fftshift(u1));    % Shift, fft source field
U2 = H.*U1;                 % Multiply
u2 = ifftshift(ifft2(U2));  % Inverted fft, center observed field
end