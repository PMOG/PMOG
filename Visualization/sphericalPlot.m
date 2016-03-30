function [h,th,ph] = sphericalPlot(n, m)
u=2*mod((0:n-1),n/2)/(n/2-1)-1;
v=2*(0:m-1)/(m-1)-1;
k=2*(0:n-1)>=n;
[uu,vv]=meshgrid(v,u);
vv(k,:)=-vv(k,:);

idx=(uu.^2>=vv.^2);
rr(idx)=uu(idx);
rr(~idx)=vv(~idx);
if(mod(n,2)==1 && mod(m,2)==1)
    uu((n+1)/2,(m+1)/2)=1;
end
th(idx)=pi/4*(vv(idx)./uu(idx));
th(~idx)=pi/4*(2-uu(~idx)./vv(~idx));

rr=reshape(rr,size(uu));
th=reshape(th,size(uu));

tt=rr.*sqrt(2-rr.^2);
xx=tt.*cos(th); 
yy=tt.*sin(th); 
zz=(1-rr.^2);
zz(k,:)=-zz(k,:);

ph=acos(sign(zz).*(1-rr.^2));
th=mod(th+pi*(rr<=0), 2*pi);
h=surf(xx,yy,zz); axis equal;
end