% sqr_beam propagation example

L1 = 0.010;                     % Side length
M = 500;                        % Number of samples
dx1 = L1/M;                     % Source sample interval
x1 = -L1/2 : dx1 : L1/2 - dx1;  % Source coordinates
y1 = x1;                        % Source coordinates
x2 = x1;                        % Observation plane coordinates
y2 = y1;                        % Observation plane coordinates
lambda = 633*10^-9;             % Wavelength
k = 2*pi/lambda;                % Wavenumber

% Create the squared difraction grating
[X1, Y1] = meshgrid(x1, y1);
w = 0.0006;                             % Square half width (m)
u1 = rect(X1/(2*w)).*rect(Y1/(2*w));    % Source field
I1 = abs(u1.^2);                        % Source irradiance
    
for i = 1:5

    z = (i-1)*0.39;                 % Propagation distance (m)
    u2 = propTF(u1, L1, lambda, z); % Propagated field
    I2 = abs(u2.^2);                % Observed irradiance
    
    imshow(I2, 'Colormap', hot);
    
    Name = strcat({'Square_'},{mat2str(z)},{'.jpg'});
    Cmap = hot;
    Procesado_Imagen(I2, Cmap, Name);
end

close all;