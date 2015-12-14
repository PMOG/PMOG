% sqr_beam propagation example

L1 = 0.5;           % Side length
M = 250;            % Number of samples
dx1 = L1/M;         % Source sample interval
x1 = -L1/2 : dx1 : L1/2 - dx1;  % Source coordinates
y1 = x1;
lambda = 0.5*10^-6; % Wavelength
k = 2*pi/lambda;    % Wavenumber
w = 0.011;          % Source half width (m)
z = 2000;           % Propagation distance (m)

[X1, Y1] = meshgrid(x1, y1);
u1 = rect(X1/(2*w)).*rect(Y1/(2*w));    % Source field
I1 = abs(u1.^2);    % Source irradiance

figure(1)
imagesc(x1, y1, I1);
axis square;
axis xy;
colormap('gray');
xlabel('x (m)');
ylabel('y (m)');
title('z = 0 m');

[u2, L2] = propFF(u1, L1, lambda, z); % Propagation

dx2 = L2/M;
x2 = -L2/2 : dx2 : L2/2-dx2;    % Observed coordinates
y2 = x2;

I2 = abs(u2.^2);        % Observed irradiance

% Theoretical irradiance calculation
I2_t = (4*w^2/(lambda*z))^2 * (sinc(2*w/(lambda*z)*x2).^2)' * (sinc(2*w/(lambda*z)*y2).^2);

figure(2)               % Display observed irradiance
imagesc(x2, y2, nthroot(I2, 3));    % Strength image contrast
axis square;
axis xy;
colormap('gray');
xlabel('x (m)');
ylabel('y (m)');
title(['z = ', num2str(z), ' m']);

figure(3)               % Display observed irradiance
imagesc(x2, y2, nthroot(I2_t, 3));    % Strength image contrast
axis square;
axis xy;
colormap('gray');
xlabel('x (m)');
ylabel('y (m)');
title(['z = ', num2str(z), ' m']);

% figure(3)               % Irradiance profile
% plot(x2, I2(M/2+1, :));
% xlabel('x (m)');
% ylabel('Irradiance');
% title(['z = ', num2str(z), ' m']);
% 
% figure(4)               % Plot observed field magnitude
% plot(x2, abs(u2(M/2+1, :)));
% xlabel('x (m)');
% ylabel('Magnitude');
% title(['z = ', num2str(z), ' m']);
% 
% figure(5)               % Plot observed field phase
% plot(x2, unwrap(angle(u2(M/2+1, :))));
% xlabel('x (m)');
% ylabel('Phase (rad)');
% title(['z = ', num2str(z), ' m']);