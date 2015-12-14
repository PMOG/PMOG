% sqr_beam propagation example

L1 = 0.010;                     % Side length
M = 500;                        % Number of samples
dx1 = L1/M;                     % Source sample interval
x1 = -L1/2 : dx1 : L1/2 - dx1;  % Source plane coordinates
y1 = x1;                        % Source plane coordinates
x2 = x1;                        % Observation plane coordinates
y2 = y1;                        % Observation plane coordinates
lambda = 633*10^-9;             % Wavelength
k = 2*pi/lambda;                % Wavenumber

%%%%% Diffraction with a ring %%%%%

% Create the ring difraction grating
[X1, Y1] = meshgrid(x1, y1);
ri = 0.00235;                   % Ring internal radius (m)
re = 0.00250;                   % Ring external radius (m)
ri_2 = wi^2;
re_2 = we^2;
u1 = zeros(M,M);
for i = 1: M
    for j = 1: M
        R_2 = x1(i)^2 + y1(j)^2;
        u1(i, j) = R_2 >= ri_2 && R_2 <= re_2;  % Source field
    end
end
I1 = abs(u1.^2);            % Source irradiance
    
for i = 2:5

    z = (i-1)*0.39;                 % Propagation distance (m)
    u2 = propTF(u1, L1, lambda, z); % Propagation
    I2 = abs(u2.^2);                % Observed irradiance
    
    imshow(I2, 'Colormap', hot);
    
    Name = strcat({'Ring_'},{mat2str(z)},{'.jpg'});
    Cmap = hot;
    Procesado_Imagen(I2, Cmap, Name);
end

%%%%% Diffraction with a circle %%%%%

% Create the circular difraction grating
[X1, Y1] = meshgrid(x1, y1);
r = 0.00070;                    % Circular grating radius
r_2 = r^2;                      % Radius squared
u1 = zeros(M,M);
for i = 1: M
    for j = 1: M
        R_2 = x1(i)^2 + y1(j)^2;
        u1(i, j) = R_2 <= r_2;  % Source field
    end
end
I1 = abs(u1.^2);            % Source irradiance
    
for i = 2:5

    z = (i-1)*0.39;                 % Propagation distance (m)
    u2 = propTF(u1, L1, lambda, z); % Propagation
    I2 = abs(u2.^2);                % Observed irradiance
    
    imshow(I2, 'Colormap', hot);
    
    Name = strcat({'Circle_'},{mat2str(z)},{'.jpg'});
    Cmap = hot;
    Procesado_Imagen(I2, Cmap, Name);
end

close all;