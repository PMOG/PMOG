% Definición de parámetros a simular.
% Selección de unidades normalizadas o reales.
% Units = 0 para unidades normalizadas, 1 para unidades reales.
% Normalizacion de unidades (las minúsculas son las unidades reales):
% X= x/Wo; Y=x/Wo; Z=z/Ld, 
% Ld=2*pi*Wo^2/lamb (Diffraction length o Rayleigh range)
% Se seleccionará el 1/2 en el laplaciano transversal para ser congruente con la aproximacción paraxial.

Units = 2;

global N Nx Ny L Lx Ly xspace yspace kspacex kspacey x y dx dy kx ky k2 Ld Wo r th lamb K ;

%*********************************************************************


switch Units

    case 0
        % Wo, escala transversal.
        
          Diameter_Beam = 0.88;   %mm
        Wo = Diameter_Beam/2;    %mm
        
        % lamb, longitud de onda.
        lamb = 6.32*1e-4;   %mm 

        %n_med, índice de refracción del medio.
        n_med = 1;

        % K, número de onda.
        K = 2*pi/lamb*n_med;

        % Ld, distancia de difracción.
        % Ld = k0*Wo.^2;
        
        % Scale Factors (SLM)
        Pixel = 4.65*1e-3;  %mm
%       Pixel = 0.032e-3;  %mm
        
%         PixelX = 1280;
        PixelX = 1920;
        PixelY = 1080;
        
        Width = Pixel*PixelX;     %mm
        Heigth = Pixel*PixelY;    %mm
        
    case 1

        Wo = 1;
        lamb = 2*pi;
        K = 2*pi/lamb;
        Width = 10*Wo; % Para perfil labo
        Heigth = 10*Wo;
        
    case 2
        
        Wo = 10;
        L = 2*Wo;
        lambda = (632.8e-9); % Longitudinal wave [m]
        lambda = 1;
        %K = (2*pi/lambda)*10^3;     % Number wave [1/mm]
        K = 1;

end
%*********************************************************************
% II.- Parámetros numéricos a usar, 2-D con posibilidad de asimetría.

        % Número de puntos en la ventana transversal.
        N = 512;
        Nx = 512;
        Ny = 512;
        
        Lx =5*Wo;
        Ly = 5*Wo;
        
        dx = Lx/Nx;
        dy = Ly/Ny;
        
%         dx = 0.001;
%         dy = 0.001;
                
%         Lx = dx*Nx; % Para perfil labo
%         Ly = dy*Ny;
%         
%         Nx = Lx/dx;
%         Ny = Ly/dy;

        % Discretización en espacio de Fourier.
        dkx = 2*pi/Lx;
        dky = 2*pi/Ly;

        % Discretización en espacio 2-D.
%         dx = Lx/Nx;
%         dy = Ly/Ny;

        % Espacio numérico en 2-D, se manejan 2 vectores por si se
        % desean cuestiones asimétricas.
        
        gralspace1x=linspace(-Nx/2,Nx/2-1,Nx);
        gralspace1y=linspace(-Ny/2,Ny/2-1,Ny);
     
        gralspace2x=linspace(-Nx/2,Nx/2-1,Nx);
        gralspace2y=linspace(-Ny/2,Ny/2-1,Ny);
        
        % Vectores transversales en espacio 2-D
        xspace =gralspace1x*dx;
        yspace =gralspace1y*dy;

        % Vectores transversales en espacio de Fourier.
        kspacex=gralspace2x*dkx;
        kspacey=gralspace2y*dky;

        % Espacio en 2-D 
        [x,y] = meshgrid(xspace,-yspace);  
             
        % Espacio en Fourier
        [kx,ky] = meshgrid(kspacex,-kspacey);

        % Coordenadas cilíndricas.
        r=sqrt(x.^2+y.^2);
        th= atan2(y,x);

        % Vector k.
%         k2 = kx.^2+ky.^2;
%         k = sqrt(k2);
    




        
        