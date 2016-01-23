function [idx,idy] = ellipseCart(a, b, phi, dim, pts)
if(isnan(a) || isnan(b))
    idx=0;
    idy=0;
    return;
end
th=linspace(0,2*pi,pts);
xt=a*cos(th);
yt=b*sin(th);
% Rotate
xr=cos(phi)*xt+sin(phi)*yt;
yr=-sin(phi)*xt+cos(phi)*yt;
% Index
idx=floor(dim(1)*(xr+1)/2);
idy=dim(2)-1-floor(dim(2)*(yr+1)/2);
end