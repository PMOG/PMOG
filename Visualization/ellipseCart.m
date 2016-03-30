function [A] = ellipseCart(Ex, Ey, samp)
E=hypot(Ex, Ey);
% Stokes Parameters
[I,Q,U,V]=StokesParams(Ex./E,Ey./E);
L=hypot(Q,U);

% Elipse
a=(I+L)/2; % Semi-major axis
b=(I-L)/2; % Semi-minor axis
phi=atan2(U,Q)/2; % Rotation angle
h=sign(V); % Handedness: (+) Righthanded = Red (-) Lefthanded = Blue

% Sampling
ip = round(linspace(1,length(Ex),samp));
a1 = a(ip,ip);
b1 = b(ip,ip);
h1 = h(ip,ip);
phi1 = phi(ip,ip); 

% Plot ellipse
cmap=eye(3);
divs=size(a1);
big=size(E);
small=big./divs;
pts=2*small(1)+2*small(2);
[R,G,B]=ind2rgb(round(255*(E/max(E(:))).^2),gray(256));

s=linspace(0,2*pi,pts);
xt=cos(s);
yt=sin(s);
for i=1:divs(1)
    for j=1:divs(2)
        % Rotate
        xr=cos(phi1(i,j))*a1(i,j)*xt+sin(phi1(i,j))*b1(i,j)*yt;
        yr=-sin(phi1(i,j))*a1(i,j)*xt+cos(phi1(i,j))*b1(i,j)*yt;
        % Index
        idx=floor(small(1)*(xr+1)/2);
        idy=small(2)-1-floor(small(2)*(yr+1)/2);
        id=(((j-1)*small(1)+idx)*divs(1)+i-1)*small(2)+idy+1;
        p=cmap(2-h1(i,j),:);
        R(id)=p(1);
        G(id)=p(2);
        B(id)=p(3);
    end
end
A=cat(3,R,G,B);
end