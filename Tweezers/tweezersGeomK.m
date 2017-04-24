function [kx] = tweezersGeomK(N)
% Physical params
a=1;
ns=1.496;
nm=1.343;
mu=ns/nm;
th0=63.55*pi/180;
Pl=16;
w0=1200;
NA=1.4;
R0=a*tan(th0);
f=(1.5*R0)/NA;

% Plot params
Nq=[256,32];
L=2;

th=linspace(0,th0,N);
phi=2*pi*(0:N-1)/N;
[th,phi]=ndgrid(th,phi);

% Ray frame
Z(:,:,1)=-sin(th).*cos(phi);
Z(:,:,2)=-sin(th).*sin(phi);
Z(:,:,3)=-cos(th);

% Power differential
dP=(Pl*f^2/(2*pi*w0^2*(1-exp(-f^2*sin(th0).^2/(2*w0^2)))))*exp(-f^2*sin(th).^2/(2*w0^2)).*sin(th).*cos(th);

function F=force(r,g)
    % Incidence and refraction angles
    t=sin(g)*sin(th).*cos(phi)+cos(g)*cos(th);
    d=sqrt(a^2+r^2*(t.^2-1))+r*t;
    c=(d.^2+a^2-r^2)./(2*a*d);
    alpha=acos(c);
    beta=asin(sqrt(1-c.^2)/mu);
    
    % Force direction
    R=0.5*((sin(alpha-beta)./sin(alpha+beta)).^2+(tan(alpha-beta)./tan(alpha+beta)).^2);
    T=1-R;
    Q=1+R.*exp(2i*alpha)-(T.^2).*exp(2i*(alpha-beta))./(1+R.*exp(-2i*beta));
    
    rvec=[sin(g);0;cos(g)];
    proj=rvec(1)*Z(:,:,1)+rvec(2)*Z(:,:,2)+rvec(2)*Z(:,:,2);
    Y(:,:,1)=rvec(1)-proj.*Z(:,:,1);
    Y(:,:,2)=rvec(2)-proj.*Z(:,:,2);
    Y(:,:,3)=rvec(3)-proj.*Z(:,:,3);    
    Ynorm=sqrt(Y(:,:,1).^2+Y(:,:,2).^2+Y(:,:,3).^2);
    Y(:,:,1)=Y(:,:,1)./Ynorm;
    Y(:,:,2)=Y(:,:,2)./Ynorm;
    Y(:,:,3)=Y(:,:,3)./Ynorm;
    
    dF=(real(Q).*Z+imag(Q).*Y).*dP;
    F=nm*(2*pi*th0)/N^2*squeeze(sum(sum(dF)));
end

dx=0.003;
x=0.003:dx:0.3;
Fx=zeros(size(x));
for i=1:length(x)
    Fx(i)=[1,0,0]*force(x(i),-pi/2);
end

plot(x,Fx,'-ok', 'MarkerFaceColor', 'k');
xlim([0,0.035]);
ylim([0,0.12]);
set(gcf,'DefaultTextInterpreter','latex');
set(gca,'TickLabelInterpreter','latex','fontsize',14);
xlabel('$\Delta x/\mu$m');
title('$F_x$/pN');

kx=mean(diff(Fx)/dx);
end

