function[u2, L2] = propFF(u1, L1, lambda, z);
% Propagation - Fraunhofer pattern
% Assumes uniform sampling
% u1    - Source plane field
% L1    - Source plane side length
% lambda - Wavelength
% z     - Propagation distance
% L2    - Observation plane side length
% u2    - Observation plane field

[M, N] = size(u1);      % Get input field array size
dx1 = L1/M;             % Source sample interval
k = 2*pi/lambda;        % Wavenumber

L2 = lambda*z/dx1;      % Obs sidelength
dx2 = lambda*z/L1;      % Obs sample interval
x2 = -L2/2:dx2:L2/2-dx2;    %Obs coordinates
[X2, Y2] = meshgrid(x2, x2);

c = 1/(j*lambda*z)*exp(j*k/(2*z)*(X2.^2 + Y2.^2));
u2 = c.*ifftshift(fft2(fftshift(u1)))*dx1^2;
end