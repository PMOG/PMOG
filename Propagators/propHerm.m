function [] = propHerm(n)
lambda=2;
k=2*pi/lambda;

w0=sqrt(2)/2;          % waist size
zr=pi/lambda*w0^2;     % Rayleigh Range

[D,x,w]=hermD(n);      % Differeantial operator and 1D nodes
[xx,yy]=meshgrid(x);   % 2D nodes

nframes=100;           % Simualtion parameters
dz=5*zr/nframes;

rr2=(xx.^2+yy.^2)/w0^2;
E=LGBeam(3,2,w0,xx,yy);      % Electric field
Q=expm(1i*dz/(2*k)*D^2);     % Propagation operator

% Interpolation and display
[xq,yq]=meshgrid(linspace(x(1),x(end),512));
Eq=interp2(xx,yy,E,xq,yq,'spline');

map=hsv(256);
phase=angle(Eq)/(2*pi);
phase=phase-floor(phase);
H=ind2rgb(uint8((length(map)-1)*phase), map);
V=mat2gray(abs(Eq).^2);
V=cat(3, V, V, V);

figure(1);
h1=image(H.*V); axis equal; axis off;
figure(2);
h2=plot(xq(end/2,:), [abs(Eq(end/2,:)).^2; real(Eq(end/2,:)); imag(Eq(end/2,:))]);
ylim([-1,1]);

% Variance calculator
r2=xx.^2+yy.^2;
w=w(:).*exp(x(:).^2);
R=diag(w)*r2*diag(w);
var1=real(E(:)'*(R(:).*E(:)));

% Propagation
for i=1:nframes
    E=exp(1i*k*dz)*(Q*E*Q.');
    Eq=interp2(xx,yy,E,xq,yq,'spline');
        
    phase=angle(Eq)/(2*pi);
    phase=phase-floor(phase);
    H=ind2rgb(uint8((length(map)-1)*phase), map);
    V=mat2gray(abs(Eq).^2);
    V=cat(3, V, V, V);
    set(h1,'CData',H.*V);
    set(h2,{'YData'},{abs(Eq(end/2,:)).^2; real(Eq(end/2,:)); imag(Eq(end/2,:))});
    drawnow;
    
    var2=real(E(:)'*(R(:).*E(:)));
    %disp((var2/var1));
end
end