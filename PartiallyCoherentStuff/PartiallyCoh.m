% Holograms for partially coherent study
% tic;
clear;
clc;

ResX = 1920;
ResY = 1080;
ParameterHol = 25; % Grating parameter ... 5 works good. 25 for visualization

m=1;         % carga topologica
w0=round( 100 /sqrt(m+1));        % cintura
wV=200;      % parametro para small core vortex   
N=200;       % cantidad de vortices para generar un ensamble
Ne=200;      % cantidad de ensambles
a=80;%       % radio del circulo donde se generan los vortices a = [80,50,10]

% Folders
directory = pwd;
directoryInfo = ['m',num2str(m),'a',num2str(a),'w0',num2str(w0),'-'];
directoryDate = [directoryInfo, sprintf('%u-%u-%u-%u-%u-%2.0f',clock),'/'];
mkdir(directory,directoryDate);

% parametros de la simulacion
x=-ResX/2:ResX/2-1; 
y=-ResY/2:ResY/2-1; 
% circlex=linspace(-a,a,puntos);
% circlex=[-a:a];
[X,Y]=meshgrid(x,y);

% Tipo de vortice
% VORTEX=@(x,y,phi,m) tanh((sqrt(x.^2+y.^2)) ./ wV) .* exp((-x.^2 - y.^2)/(w0^2)) .* exp(1i*(m*atan2(y,x)+phi)); 
VORTEX=@(x,y,phi,m) (((x.^2+y.^2)/w0).^abs(m)) .* exp((-x.^2 - y.^2)/(w0^2)) .* exp(1i*(m*atan2(y,x)+phi)); 

for iteration = 1:N,
disp(iteration);
    
% initialization
U = zeros(ResY, ResX);
Campoaux1 = zeros(ResY, ResX);

% random positions to create a member of the ensamble
r = a*sqrt(rand(N,1));
theta = 2*pi*rand(N,1);
phi = 2*pi*rand(N,1);
xv = r.*cos(theta);
yv = r.*sin(theta);

    for n =1:N,
        Campoaux1 = VORTEX(X-xv(n),Y-yv(n),phi(n),m);
        U = Campoaux1 + U; 
    end


% Field = VORTEX(X,Y,,01);
% Field = Field./max(max(Field));
% PhaseField = angle(Field);
AmplitudeField = abs(U);
AmplitudeField = AmplitudeField./max(max(AmplitudeField));

% PhaseField = angle(U);
% PhaseHologram = AmplitudeField.*(mod(PhaseField + angle(exp(1i*(2*pi*(X)/ParameterHol))), 2*pi)/pi-1)+1;

figure(1),
imagesc(abs(U))
colormap gray
axis('equal','tight','off')
% 
% figure(2),
% imagesc(PhaseHologram)
% colormap gray
% axis('equal','tight','off')

% Create file with hologram encoded
% imwrite(PhaseHologram./max(max(PhaseHologram)),...
%     [directory,...
%     directoryDate,...
%     'PC',...
%     num2str(iteration,'%.3d'),...
%     '.jpg'],...
%     'Mode','lossy','Quality',100)
end
% time=toc;