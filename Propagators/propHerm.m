function [] = propHerm(n)
k=1;
dz=0.2;

[D,x]=hermD(n);
[xx,yy]=meshgrid(x);

E=HGBeam(3,3,4*sqrt(2),xx,yy);
Q=expm(1i*dz/(2*k)*D^2);

[xq,yq]=meshgrid(linspace(x(1),x(end),2048));
Eq=interp2(xx,yy,E,xq,yq,'spline');

h=imagesc(abs(Eq).^2);
for i=1:100
    E=exp(1i*k*dz)*(Q*E*Q.');
    Eq=interp2(xx,yy,E,xq,yq,'spline');
    
    set(h,'CData',abs(Eq).^2);
    drawnow;
end

end

