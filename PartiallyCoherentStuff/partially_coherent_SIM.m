% Genera un vortice parcialmente coherente 
% basado en la tesis de Raul Hernandez Aranda
% version optimizada 0.0.1

clear;
% tic;
puntos=128;  % Numero de puntos del campo
m=1;         % carga topologica
w0=1.0;        % cintura
%w0=200*256/1024;
wV=0.3;      % parametro para small core vortex   
%wV=80*256*1024; 
N=100;       % N = 100 cantidad de vortices para generar un ensamble
Ne=200;     % N= 1000 cantidad de ensambles
xmax=2*w0;
%Yo soy el Alfa y la Omega, el principio y el fin, dice el Señor, el que
%es y que era y que ha de venir, el Todopoderoso
%xmax=puntos/2;
a=1;% w0*0.4;    % radio del circulo donde se generan los vortices
% a=0.8; 0.55
%a=100*256/1024;

% parametros de la simulacion
x=linspace(-xmax,xmax*(puntos-2)/puntos,puntos); % x=0 est� en puntos/2+1.
xx = linspace(-xmax,xmax*(puntos-2)/puntos,2*puntos-1);
circlex=linspace(-a,a,puntos);
%circlex=[-a:a];
[X,Y]=meshgrid(x,x);

% inicializacion
U = zeros(puntos,puntos);
I = zeros(puntos,puntos);
%Xi = zeros(2*puntos-1,2*puntos-1);
Xi = I;
Isuma = zeros(puntos, puntos);
Xisuma = zeros(puntos, puntos);
%Xisuma = zeros(2*puntos-1,2*puntos-1);
TimeCoherentSum = zeros(Ne,1);
TimeIncoherentSum = zeros(Ne,1);
Tiempo = TimeCoherentSum;
circley = real(sqrt(a^2 - circlex.^2));

% Tipo de vortice
VORTEX=@(x,y,phi,m) tanh((sqrt(x.^2+y.^2)) ./ wV) .* exp((-x.^2 - y.^2)/(w0^2)) .* exp(1i*(m*atan2(y,x)+phi)); 
% VORTEX=@(x,y,phi,m) (((x.^2+y.^2)/w0).^abs(m)) .* exp((-x.^2 - y.^2)/(w0^2)) .* exp(1i*(m*atan2(y,x)+phi)); 

%tic;    % monitorear tiempo de ejecucion
for k =1:Ne,
% tic;
U = zeros(puntos, puntos);
Campoaux1 = zeros(puntos, puntos);

% valores aleatorios para la posicion de los vortices
% distribucion uniforme en un circulo de radio a
r = a*sqrt(rand(N,1));
theta = 2*pi*rand(N,1);
phi = 2*pi*rand(N,1);
xv = r.*cos(theta);
yv = r.*sin(theta);

% tic;    % monitorear tiempo suma coherente
for n =1:N,
Campoaux1 = VORTEX(X-xv(n),Y-yv(n),phi(n),m);
Campoaux1 = Campoaux1 ./ max(max(Campoaux1));
U = Campoaux1 + U; % Suma de vortices
    
%% Descomentar/comentar para monitorear vortices    
%   figure(1), 
%   subplot(1,2,1),pcolor(x,x,abs(U)), shading interp, colormap gray, axis square;
%   line(circlex,circley,'Color','b'),line(circlex,-circley,'Color','b');
%   subplot(1,2,2),pcolor(x,x,angle(U)), shading interp, colormap gray, axis square;
%   line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
%   pause(0.1);   
end
% TimeCoherentSum(k) = toc;

figure(1), 
imagesc(x,x,abs(U)), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','b'),line(circlex,-circley,'Color','b');

% tic;
I=abs(U);
%Xi=abs(xcorr2(U,rot90(conj(U),180)));
Xi = (abs(U+rot90(U,2))-(abs(U) - abs(rot90(U,2))))/2;
% Xi=abs(FastCC2(U,rot90(U,90)));
% Xi=sqrt(abs(xcorr2(U,U)));
% F1 = fftshift(fft2(U));0
% Xi = abs(fftshift(ifft2(conj(F1).*F1)));

% Suma de ensambles
Isuma = Isuma + I;
Xisuma = Xisuma + Xi;
% TimeIncoherentSum(k) = toc;

%% Descomentar/comentar para monitorear ensambles
figure(2),
subplot(2,2,1), imagesc(x,x,I), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
subplot(2,2,2), imagesc(x,x,((Xi))), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
subplot(2,2,3), imagesc(x,x,(Isuma)), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
subplot(2,2,4), imagesc(x,x,((Xisuma))), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
pause(0.001);
disp(k);    % monitorea en que iteracion se encuentra
% Tiempo(k) = toc;
end
%TimePartiallyCoherentVB = toc;

% Promedios de I y Xi
Iaverage=(1/Ne) .* Isuma;
Xiaverage=((1/Ne) .* Xisuma);

% Descomentar/comentar para ver resultados
figure(3),
subplot(1,2,1),imagesc(x,x,Iaverage), shading interp, colormap gray, axis square;
line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');
subplot(1,2,2),imagesc(x,x,Xiaverage), shading interp, colormap gray, axis square;
% line(circlex,circley,'Color','g'),line(circlex,-circley,'Color','g');

% TIME=toc;
% Archivo que se enviara por correo
%save /home/ben/Dropbox/Documents/Tec/PartiallyCoherentM1_SMALLA512.mat