function [] = propHerm(n)
lambda=1;
k=2*pi/lambda;

w0=1/sqrt(2);          % waist size
zr=pi/lambda*w0^2;     % Rayleigh Range

[D,x,w]=hermD(n);      % Differeantial operator and 1D nodes
[xx,yy]=meshgrid(x);   % 2D nodes

nframes=100;           % Simualtion parameters
dz=4*zr/nframes;

E=IGBeam(20,10,2,w0,xx,yy);  % Electric field
Q=expm(1i*dz/(2*k)*D^2);     % Propagation operator

% Interpolation and display
[xq,yq]=meshgrid(linspace(x(1),x(end),1024));
Eq=interp2(xx,yy,E,xq,yq,'spline');
h=imagesc(abs(Eq).^2); colormap(gray(256)); axis equal; axis off;

% Variance calculator
r2=xx.^2+yy.^2;
w=w(:).*exp(x(:).^2);
R=diag(w)*r2*diag(w);
var1=real(E(:)'*(R(:).*E(:)));

% Propagation
for i=1:nframes
    E=exp(1i*k*dz)*(Q*E*Q.');
    Eq=interp2(xx,yy,E,xq,yq,'spline');
    set(h,'CData',abs(Eq).^2);
    drawnow;
    
    var2=real(E(:)'*(R(:).*E(:)));
    %disp((var2/var1));
end
end