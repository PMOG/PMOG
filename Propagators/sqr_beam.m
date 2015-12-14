% sqr_beam propagation example

L1 = 0.010;           % Side length
M = 500;            % Number of samples
dx1 = L1/M;         % Source sample interval
x1 = -L1/2 : dx1 : L1/2 - dx1;  % Source coordinates
y1 = x1;
lambda = 633*10^-9; % Wavelength
k = 2*pi/lambda;    % Wavenumber
w = 0.0006;          % Source half width (m)
z = 1*0.39;           % Propagation distance (m)

[X1, Y1] = meshgrid(x1, y1);
u1 = rect(X1/(2*w)).*rect(Y1/(2*w));    % Source field
I1 = abs(u1.^2);    % Source irradiance

% figure(1)
% imagesc(x1, y1, I1);
% axis square;
% axis xy;
% colormap('gray');
% xlabel('x (m)');
% ylabel('y (m)');
% title('z = 0 m');

u2 = propTF(u1, L1, lambda, z); % Propagation
%u2 = propIR(u1, L1, lambda, z); % Propagation

x2 = x1;                % Observed coordinates
y2 = y1;
I2 = abs(u2.^2);        % Observed irradiance

figure(2)               % Display observed irradiance
imagesc(x2, y2, I2);
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