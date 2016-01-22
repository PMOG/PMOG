function [T] = ellipseCart(a, b, phi, dim, pts)
T(dim(1), dim(2))=uint8(0);
if(isnan(a) || isnan(b))
    return;
end
th=linspace(0,2*pi,pts);
xt=a*cos(th);
yt=b*sin(th);
% Rotate
xr=cos(phi)*xt-sin(phi)*yt;
yr=sin(phi)*xt+cos(phi)*yt;
% Index
xi=floor(dim(1)*(xr+1)/2);
yi=floor(dim(2)*(yr+1)/2);
idx=yi*dim(1)+xi+1;
T(idx)=255;
end