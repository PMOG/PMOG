function [xx, yy] = disk(n,m)
u=linspace(-1,1,n);
v=linspace(-1,1,m);
[uu,vv]=meshgrid(u,v);
idx=(uu.^2>=vv.^2);
rr(idx)=uu(idx);
if(mod(n,2)==1 && mod(m,2)==1)
    uu((n+1)/2,(m+1)/2)=1;
end
th(idx)=pi/4*(vv(idx)./uu(idx));
rr(~idx)=vv(~idx);
th(~idx)=pi/4*(2-uu(~idx)./vv(~idx));
xx=rr.*cos(th);
yy=rr.*sin(th);
end