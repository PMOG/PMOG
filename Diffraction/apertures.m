function [] = apertures(N)
% Parameters

m=1;
L=sqrt(pi/2*N)/2;
field=@(a,xx,yy) charge(m,xx,yy).*aptri(a,xx,yy);
cm=hot(256);

[fres,x]=fresnelconv(N); % Near field - Fresnel integral
[fran,x]=fraunhofer(N);  % Far field - Fraunhofer integral
[xx, yy]=ndgrid(x);

a1=sqrt(pi/2*N)/2*0.21;
a2=sqrt(pi/2*N)/2*0.02;

U1=feval(field,a1,xx,yy);
U2=feval(field,a2,xx,yy);
Ufres=fres(U1);
Ufran=fran(U2);

figure(1);
imagesc(x,x,abs(Ufres)'.^2);
set(gca,'YDir','normal');
colormap(cm); axis square off;
xlim([-L,L]); ylim([-L,L]);

figure(2);
imagesc(x,x,abs(Ufran)'.^2);
set(gca,'YDir','normal');
colormap(cm); axis square off;
xlim([-L,L]); ylim([-L,L]);

figure(3);
imagesc(x,x,abs(U1)'.^2);
set(gca,'YDir','normal');
colormap(cm); axis square off;
xlim([-L,L]); ylim([-L,L]);
end

function U=apcirc(a,xx,yy)
U=(hypot(xx,yy)<=a);
end

function U=apsquare(a,xx,yy)
U=(abs(xx)<=a).*(abs(yy)<=a);
end

function U=aptri(a,xx,yy)
U=(yy<=(a-sqrt(3)*abs(xx))).*(yy>=-a/2);
end

function U=charge(m,xx,yy)
U=exp(1i*m*atan2(yy,xx));
end