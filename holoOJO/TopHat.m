function U=TopHat(X,Y,bbeta,r0)
% U=TopHat(X,Y,bbeta,r0)
% This function computes the phase to transform an input Gaussian beam into
% a flat-top beam.

% ResR=1*1080;
% % pixels
% ResC=1*1920;
% Ux=2*7.68E-3; % [m]
% Uy=8.64E-3;
% 
% % HOLOGRAM PARAMETERS
% downScale=1/1;%0.50;          % Scale factor for tests
% Nx=ResC*downScale;
% Ny=ResR*downScale;
% 
% % Spatial sampling at 2*fNyquist, spatial gratings
% sx=linspace(-Ux/2,Ux/2,Nx);
% sy=linspace(-Uy/2,Uy/2,Ny);
% [X,Y]=meshgrid(sx,sy);
% 
% % bbeta=20;
% r0=1.025e-3;

% Quadrature method (Brubeck's code)
nquad=16;
[xq,wq]=ClenshawCurtis(0,1,nquad); xq=xq(:); wq=wq(:);
rr=sqrt(2)/r0*hypot(X(:),Y(:)); 
PhiInt=(rr).*(bbeta*sqrt(pi)/2*sqrt(1-exp(-(rr*xq').^2))*wq);
PhiInt=reshape(PhiInt, size(X));
U = exp(1i*PhiInt);
end