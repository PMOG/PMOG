function [A] = ellipseCart(a, b, phi, N, M)
A(N(1),N(2))=uint8(0);
if(isnan(a) || isnan(b))
    return;
end
th=linspace(0,2*pi,M);
xt=a*cos(th);
yt=b*sin(th);
% Rotate
xr=cos(phi)*xt-sin(phi)*yt;
yr=sin(phi)*xt+cos(phi)*yt;
% Index
xi=floor(N(1)*(xr+1)/2);
yi=floor(N(2)*(yr+1)/2);
idx=yi*N(1)+xi+1;
A(idx)=255;
end